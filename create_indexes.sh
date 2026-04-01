#!/bin/bash
# Creates index.md for every section that needs one
# Run from: ~/Syncthing/masterDoc/myMethodology

D="docs"

create_index() {
  local path="$1"
  local title="$2"
  local desc="$3"
  mkdir -p "$D/$path"
  cat > "$D/$path/index.md" << MD
# $title

$desc
MD
  echo "Created $D/$path/index.md"
}

create_index "recon" "Recon & Enumeration" "Passive OSINT, active scanning, service enumeration, and web reconnaissance."
create_index "recon/passive" "Passive Recon" "OSINT techniques that don't interact directly with the target."
create_index "recon/active" "Active Scanning" "Direct interaction with the target — port scanning, service detection, and network mapping."
create_index "recon/services" "Service Enumeration" "Protocol-specific enumeration — DNS, SMB, SMTP, SNMP and more."
create_index "recon/web" "Web Recon" "Directory brute forcing, fingerprinting, and web application enumeration."
create_index "recon/web/xss" "XSS" "Cross-site scripting — stored, reflected, and DOM-based."
create_index "recon/web/wordpress" "WordPress" "WordPress-specific enumeration and exploitation."
create_index "recon/windows" "Windows Enumeration" "Enumeration techniques specific to Windows environments."
create_index "recon/flag-search" "Flag Search" "Finding flags, passwords, and interesting content on compromised systems."

create_index "exploitation" "Exploitation" "Web attacks, service exploitation, reverse shells, tunneling, and password cracking."
create_index "exploitation/web" "Web Exploitation" "LFI, SQLi, webshells, file uploads, and other web application attacks."
create_index "exploitation/web/sqli" "SQL Injection" "UNION-based, error-based, blind SQLi and database-specific techniques."
create_index "exploitation/services" "Service Exploitation" "SSH, SMB, RDP, impacket suite and Windows-specific service attacks."
create_index "exploitation/services/impacket" "Impacket" "Impacket suite — psexec, wmiexec, smbclient, ntlmrelayx and more."
create_index "exploitation/reverse-shells" "Reverse Shells" "Shell stabilization, TTY treatment, and payload generation for Linux and Windows."
create_index "exploitation/tunneling" "Tunneling" "Chisel and Ligolo for port forwarding and network pivoting."
create_index "exploitation/phishing" "Phishing" "Phishing techniques and tools used in engagements."
create_index "exploitation/password-cracking" "Password Cracking" "Hydra, John, Hashcat, password spraying, and hash cracking methodology."
create_index "exploitation/password-cracking/hash" "Hash Cracking" "NTLM, Net-NTLMv2, hashcat formats, and pass-the-hash techniques."

create_index "privilege-escalation" "Privilege Escalation" "Linux and Windows privilege escalation techniques, tools, and CVEs."
create_index "privilege-escalation/linux" "Linux PrivEsc" "linpeas, GTFOBins, SUID, sudo exploits, and wildcard injection."
create_index "privilege-escalation/windows" "Windows PrivEsc" "winpeas, mimikatz, SAM, token impersonation, and potato attacks."
create_index "privilege-escalation/windows/potatoes" "Potato Attacks" "Token impersonation exploits — GodPotato, JuicyPotato, PrintSpoofer and more."

create_index "active-directory" "Active Directory" "AD enumeration, attacks, lateral movement, persistence, and abuse techniques."
create_index "active-directory/enumeration" "AD Enumeration" "Bloodhound, PowerView, Kerbrute and other AD enumeration tools."
create_index "active-directory/attacks" "AD Attacks" "Kerberoasting, AS-REP roasting, Pass-the-Hash and Rubeus."
create_index "active-directory/lateral-movement" "Lateral Movement" "Overpass-the-Hash and Pass-the-Ticket for moving through AD environments."
create_index "active-directory/persistence" "Persistence" "DCSync, Golden Tickets, Silver Tickets and Shadow Copies."
create_index "active-directory/abuse" "AD Abuse" "DACL abuse, GPO abuse, and Jenkins exploitation."

create_index "linux-misc" "Linux Miscellaneous" "Shell tips, Kali tweaks, Python tools and general Linux utilities."
create_index "linux-misc/kali" "Kali Linux" "Kali-specific fixes, tweaks and shared folder setup."

create_index "tools" "Tools" "Custom tools and general information gathering references."
create_index "tools/s4v" "s4v Tools" "Personal custom tools — extractPorts, htbExplorer, whichSystem and more."

echo ""
echo "All index files created. Run: mkdocs build"
