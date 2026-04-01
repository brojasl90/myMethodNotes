#!/bin/bash
# ============================================================
# Vault Restructure Script
# Run from: ~/Syncthing/masterDoc/myMethodology
# ============================================================

set -e
DOCS="docs"

echo "Creating new folder structure..."

# ── 1. RECON ────────────────────────────────────────────────
mkdir -p $DOCS/recon/passive
mkdir -p $DOCS/recon/active
mkdir -p $DOCS/recon/services
mkdir -p $DOCS/recon/web/xss
mkdir -p $DOCS/recon/web/wordpress
mkdir -p $DOCS/recon/windows
mkdir -p $DOCS/recon/flag-search

# ── 2. EXPLOITATION ─────────────────────────────────────────
mkdir -p $DOCS/exploitation/web/sqli
mkdir -p $DOCS/exploitation/web/xss
mkdir -p $DOCS/exploitation/services/impacket
mkdir -p $DOCS/exploitation/reverse-shells
mkdir -p $DOCS/exploitation/tunneling
mkdir -p $DOCS/exploitation/phishing
mkdir -p $DOCS/exploitation/password-cracking/hash

# ── 3. PRIVILEGE ESCALATION ─────────────────────────────────
mkdir -p $DOCS/privilege-escalation/linux
mkdir -p $DOCS/privilege-escalation/windows/potatoes

# ── 4. ACTIVE DIRECTORY ─────────────────────────────────────
mkdir -p $DOCS/active-directory/enumeration
mkdir -p $DOCS/active-directory/attacks
mkdir -p $DOCS/active-directory/lateral-movement
mkdir -p $DOCS/active-directory/persistence
mkdir -p $DOCS/active-directory/abuse

# ── 5. LINUX MISC ───────────────────────────────────────────
mkdir -p $DOCS/linux-misc/kali

# ── 6. TOOLS ────────────────────────────────────────────────
mkdir -p $DOCS/tools/s4v
mkdir -p $DOCS/tools/impacket

echo "Moving files..."

# ── RECON / PASSIVE ─────────────────────────────────────────
mv "$DOCS/reconn & enum/Information Gathering Tools/Passive/Google Hacking.md"            $DOCS/recon/passive/
mv "$DOCS/reconn & enum/Information Gathering Tools/Passive/Netcraft.md"                  $DOCS/recon/passive/
mv "$DOCS/reconn & enum/Information Gathering Tools/Passive/Open-Source Code.md"          $DOCS/recon/passive/
mv "$DOCS/reconn & enum/Information Gathering Tools/Passive/Security Headers and SSL - TLS.md" $DOCS/recon/passive/
mv "$DOCS/reconn & enum/Information Gathering Tools/Passive/Shodan.md"                    $DOCS/recon/passive/
mv "$DOCS/reconn & enum/Information Gathering Tools/Passive/Whois Enumeration.md"         $DOCS/recon/passive/
mv "$DOCS/reconn & enum/git.md"                                                            $DOCS/recon/passive/

# ── RECON / ACTIVE ──────────────────────────────────────────
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/Port Scanning with Nmap.md"    $DOCS/recon/active/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/Port Scanning with Nmap/nmap.md"         $DOCS/recon/active/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/Port Scanning with Nmap/iptables.md"     $DOCS/recon/active/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/Port Scanning with Nmap/Test-NetConnection.md" $DOCS/recon/active/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/TCP - UDP Port Scanning Theory.md"       $DOCS/recon/active/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/TCP - UDP Port Scanning Theory/nc - netcat.md" $DOCS/recon/active/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/TCP - UDP Port Scanning Theory/wireshark.md"   $DOCS/recon/active/
mv "$DOCS/reconn & enum/Enumeration/Autorecon.md"                                         $DOCS/recon/active/
mv "$DOCS/reconn & enum/Enumeration/nmap.md"                                              $DOCS/recon/active/
mv "$DOCS/reconn & enum/Enumeration/General approach based on ports and services.md"      $DOCS/recon/active/
mv "$DOCS/reconn & enum/network/from windows scan using CMD.md"                           $DOCS/recon/active/
mv "$DOCS/reconn & enum/network/icmp scan.md"                                             $DOCS/recon/active/
mv "$DOCS/reconn & enum/network/pingsweep.md"                                             $DOCS/recon/active/

# ── RECON / SERVICES ────────────────────────────────────────
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/DNS Enumeration.md"            $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/DNS Enumeration/dnsenum.md"    $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/DNS Enumeration/dnsrecon.md"   $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/DNS Enumeration/hosts.md"      $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SMB/SMB Enumeration.md"        $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SMB Enumeration/net view.md"   $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SMTP Enumeration.md"           $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SMTP Enumeration/dism.md"      $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SMTP Enumeration/python.md"    $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SMTP Enumeration/telnet.md"    $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SNMP Enumeration.md"           $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SNMP Enumeration/onesixtyone.md" $DOCS/recon/services/
mv "$DOCS/reconn & enum/Information Gathering Tools/Active/SNMP Enumeration/snmpwalk.md"  $DOCS/recon/services/
mv "$DOCS/reconn & enum/Enumeration/Active Directory/Inveigh.ps1.md"                      $DOCS/recon/services/
mv "$DOCS/reconn & enum/Enumeration/Active Directory/secretsdump.md"                      $DOCS/recon/services/
mv "$DOCS/reconn & enum/iwr - windows.md"                                                 $DOCS/recon/services/
mv "$DOCS/reconn & enum/wget - Linux.md"                                                  $DOCS/recon/services/

# ── RECON / WEB ─────────────────────────────────────────────
mv "$DOCS/reconn & enum/web methodology.md"                                               $DOCS/recon/web/
mv "$DOCS/reconn & enum/Directory Transversal.md"                                         $DOCS/recon/web/
mv "$DOCS/reconn & enum/Enumeration/Web/Burp Suite.md"                                   $DOCS/recon/web/
mv "$DOCS/reconn & enum/Enumeration/Web/feroxbuster.md"                                  $DOCS/recon/web/
mv "$DOCS/reconn & enum/Enumeration/Web/ffuf.md"                                         $DOCS/recon/web/
mv "$DOCS/reconn & enum/Enumeration/Web/Gobuster.md"                                     $DOCS/recon/web/
mv "$DOCS/reconn & enum/Enumeration/Web/Wappalyzer.md"                                   $DOCS/recon/web/
mv "$DOCS/reconn & enum/Enumeration/Web/whatweb.md"                                      $DOCS/recon/web/
mv "$DOCS/reconn & enum/Enumeration/Directory brute forcing/wordlists.md"                $DOCS/recon/web/
mv "$DOCS/reconn & enum/Enumeration/Web/XSS/DOM-based XSS.md"                           $DOCS/recon/web/xss/
mv "$DOCS/reconn & enum/Enumeration/Web/XSS/Reflected XSS.md"                           $DOCS/recon/web/xss/
mv "$DOCS/reconn & enum/Enumeration/Web/XSS/Stored XSS.md"                              $DOCS/recon/web/xss/
mv "$DOCS/reconn & enum/Enumeration/Web/wordpress/searchsploit.md"                      $DOCS/recon/web/wordpress/
mv "$DOCS/reconn & enum/Enumeration/Web/wordpress/wpscan - wordpress.md"                $DOCS/recon/web/wordpress/

# ── RECON / WINDOWS ─────────────────────────────────────────
mv "$DOCS/reconn & enum/Enumeration/Windows/enum General Windows.md"                    $DOCS/recon/windows/
mv "$DOCS/reconn & enum/Enumeration/Windows/scan network with powershell.md"            $DOCS/recon/windows/

# ── RECON / FLAG SEARCH ─────────────────────────────────────
mv "$DOCS/reconn & enum/Information Gathering Tools/flag search/grep - Searching interesting passwords or content.md" $DOCS/recon/flag-search/
mv "$DOCS/reconn & enum/Information Gathering Tools/flag search/meterpreter.md"         $DOCS/recon/flag-search/
mv "$DOCS/reconn & enum/Information Gathering Tools/flag search/search for every file in windows - powershell.md" $DOCS/recon/flag-search/
mv "$DOCS/reconn & enum/Information Gathering Tools/flag search/search recursively in Linux.md" $DOCS/recon/flag-search/
mv "$DOCS/reconn & enum/Information Gathering Tools/flag search/show the flag.md"       $DOCS/recon/flag-search/
mv "$DOCS/reconn & enum/Information Gathering Tools/flag search/Windows.md"             $DOCS/recon/flag-search/

# ── EXPLOITATION / WEB ──────────────────────────────────────
mv "$DOCS/Exploitation/web/Local File Inclusion - LFI.md"                               $DOCS/exploitation/web/
mv "$DOCS/Exploitation/web/basic webshell method.md"                                    $DOCS/exploitation/web/
mv "$DOCS/Exploitation/web/cewl - crawling.md"                                          $DOCS/exploitation/web/
mv "$DOCS/Exploitation/web/curl.md"                                                     $DOCS/exploitation/web/
mv "$DOCS/Exploitation/web/server http with python.md"                                  $DOCS/exploitation/web/
mv "$DOCS/Exploitation/web/Upload files.md"                                             $DOCS/exploitation/web/
mv "$DOCS/Exploitation/webshells/webshells.md"                                          $DOCS/exploitation/web/
mv "$DOCS/Exploitation/Injection/SQLi/Blind SQL injections.md"                         $DOCS/exploitation/web/sqli/
mv "$DOCS/Exploitation/Injection/SQLi/Error-based.md"                                  $DOCS/exploitation/web/sqli/
mv "$DOCS/Exploitation/Injection/SQLi/General approach.md"                             $DOCS/exploitation/web/sqli/
mv "$DOCS/Exploitation/Injection/SQLi/MSSQL.md"                                        $DOCS/exploitation/web/sqli/
mv "$DOCS/Exploitation/Injection/SQLi/Mysql.md"                                        $DOCS/exploitation/web/sqli/
mv "$DOCS/Exploitation/Injection/SQLi/UNION-based.md"                                  $DOCS/exploitation/web/sqli/
mv "$DOCS/Exploitation/Injection/SQLi/Validate type of Database.md"                    $DOCS/exploitation/web/sqli/
mv "$DOCS/Exploitation/Injection/SQLi/xp_cmdshell feature - MSSQL.md"                 $DOCS/exploitation/web/sqli/
mv "$DOCS/Exploitation/Injection/OS Injection/Python.md"                               $DOCS/exploitation/web/
mv "$DOCS/Exploitation/Injection/OS Injection/windows/xp_cmdshell.md"                 $DOCS/exploitation/web/

# ── EXPLOITATION / SERVICES ─────────────────────────────────
mv "$DOCS/Exploitation/Linux/ssh.md"                                                    $DOCS/exploitation/services/
mv "$DOCS/Exploitation/Linux/smb/crackmapexec.md"                                       $DOCS/exploitation/services/
mv "$DOCS/Exploitation/Linux/smb/responder.md"                                          $DOCS/exploitation/services/
mv "$DOCS/Exploitation/Linux/smb/smbclient.md"                                         $DOCS/exploitation/services/
mv "$DOCS/Exploitation/Linux/smb/Impacket/evil-winrm.md"                               $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/smb/Impacket/impacket-mssqlclient.md"                    $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/smb/Impacket/impacket-ntlmrelayx.md"                     $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/smb/Impacket/impacket-psexec.md"                         $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/smb/Impacket/impacket-smbclient.md"                      $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/smb/Impacket/impacket-smbserver.md"                      $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/smb/Impacket/impacket-wmiexec.md"                        $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/impacket/evil-winrm 1.md"                                $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/impacket/impacket-mssqlclient.md"                        $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/impacket/impacket-ntlmrelayx 1.md"                       $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/impacket/impacket-psexec 1.md"                           $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/impacket/impacket-smbclient 1.md"                        $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/impacket/impacket-smbserver 1.md"                        $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Linux/impacket/impacket-wmiexec 1.md"                          $DOCS/exploitation/services/impacket/
mv "$DOCS/Exploitation/Email/Email General.md"                                          $DOCS/exploitation/services/
mv "$DOCS/Exploitation/Email/sendemail.md"                                              $DOCS/exploitation/services/
mv "$DOCS/Exploitation/cve search.md"                                                   $DOCS/exploitation/services/
mv "$DOCS/Exploitation/Exploits/Mobile Mouse.md"                                        $DOCS/exploitation/services/
mv "$DOCS/Exploitation/Transferring file from Windows machine to local Kali VM.md"     $DOCS/exploitation/services/
mv "$DOCS/Exploitation/windows/Transferring file from Windows machine to local Kali VM.md" $DOCS/exploitation/services/
mv "$DOCS/Exploitation/windows/rdesktop.md"                                             $DOCS/exploitation/services/
mv "$DOCS/Exploitation/windows/xfreerdp.md"                                            $DOCS/exploitation/services/
mv "$DOCS/Exploitation/windows/Invoke-RunasCs.ps1.md"                                  $DOCS/exploitation/services/
mv "$DOCS/Exploitation/windows/run cmd as another user.md"                             $DOCS/exploitation/services/
mv "$DOCS/Exploitation/windows/powershell.md"                                          $DOCS/exploitation/services/

# ── EXPLOITATION / REVERSE SHELLS ───────────────────────────
mv "$DOCS/Exploitation/reverShell/Linux.md"                                            $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/Linux when blind and no nc.md"                       $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/Netcat.md"                                           $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/msfvenom.md"                                         $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/powershell onliner.md"                               $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/Estabilize powershell.md"                            $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/Stabilize your shell.md"                             $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/rlwrap with nc listener.md"                          $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/reverse shell generator.md"                          $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/pythonScript - DCOM.md"                              $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/python script.md"                                    $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/webShell PHP.md"                                     $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/reverShell/wordpress plugin.md"                                 $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/Linux/TTY Treatment.md"                                         $DOCS/exploitation/reverse-shells/
mv "$DOCS/Exploitation/Linux/base64 encode.md"                                         $DOCS/exploitation/reverse-shells/

# ── EXPLOITATION / TUNNELING ────────────────────────────────
mv "$DOCS/Exploitation/tunneling/chisel.md"                                            $DOCS/exploitation/tunneling/
mv "$DOCS/Exploitation/tunneling/ligolo.md"                                            $DOCS/exploitation/tunneling/

# ── EXPLOITATION / PHISHING ─────────────────────────────────
mv "$DOCS/Exploitation/phishing/WsgiDAV.md"                                            $DOCS/exploitation/phishing/

# ── EXPLOITATION / PASSWORD CRACKING ───────────────────────
mv "$DOCS/Exploitation/password cracking/Cracking methodology.md"                     $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/CRACKSTATION.md"                             $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/Hashcat.md"                                  $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/hydra.md"                                    $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/John the Ripper.md"                          $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/keepass2john.md"                             $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/Keepass.md"                                  $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/Password-Spray.md"                           $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/ssh2john.md"                                 $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/Mutating Wordlist List/mutating.md"          $DOCS/exploitation/password-cracking/
mv "$DOCS/Exploitation/password cracking/Hash/Cracking Net-NTLMv2.md"                $DOCS/exploitation/password-cracking/hash/
mv "$DOCS/Exploitation/password cracking/Hash/Cracking NTLM.md"                      $DOCS/exploitation/password-cracking/hash/
mv "$DOCS/Exploitation/password cracking/Hash/hashcat formats.md"                     $DOCS/exploitation/password-cracking/hash/
mv "$DOCS/Exploitation/password cracking/Hash/hashcat.md"                             $DOCS/exploitation/password-cracking/hash/
mv "$DOCS/Exploitation/password cracking/Hash/hash-identifier.md"                    $DOCS/exploitation/password-cracking/hash/
mv "$DOCS/Exploitation/password cracking/Hash/mimikatz.md"                            $DOCS/exploitation/password-cracking/hash/
mv "$DOCS/Exploitation/password cracking/Hash/pass-tha-hash/Passing NTLM.md"         $DOCS/exploitation/password-cracking/hash/
mv "$DOCS/Exploitation/password cracking/Hash/Relaying Net-NTLMv2.md"                $DOCS/exploitation/password-cracking/hash/

# ── PRIVILEGE ESCALATION / LINUX ────────────────────────────
mv "$DOCS/Exploitation/Escalation/linuxEscalation/Basic Linux priv escalation.md"    $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/GTFOBins.md"                       $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/linpeas.md"                        $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/powerup.ps1.md"                    $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/pspy.md"                           $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/sudo.md"                           $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/suid - find.md"                    $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/TCM_LinuxPriv/Enum General.md"     $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/unix-privesc-check.md"             $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Escalation/linuxEscalation/wildcard Unix Gone Wild.md"        $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Linux/linuxEscalation/GTFOBins.md"                            $DOCS/privilege-escalation/linux/GTFOBins-2.md
mv "$DOCS/Exploitation/Linux/linuxEscalation/linpeas.md"                             $DOCS/privilege-escalation/linux/linpeas-2.md
mv "$DOCS/Exploitation/Linux/linuxEscalation/sudo.md"                               $DOCS/privilege-escalation/linux/sudo-2.md
mv "$DOCS/Exploitation/Linux/linuxEscalation/suid - find.md"                        $DOCS/privilege-escalation/linux/suid-2.md
mv "$DOCS/Exploitation/Linux/linuxEscalation/Untitled.md"                           $DOCS/privilege-escalation/linux/
mv "$DOCS/Exploitation/Linux/sudo exploit 1.8.31.md"                                $DOCS/privilege-escalation/linux/

# ── PRIVILEGE ESCALATION / WINDOWS ──────────────────────────
mv "$DOCS/Exploitation/Escalation/winEscalation/Acl-FullControl.md"                 $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/binary Hijacking.md"                $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/CVE-2023-29360.exe.md"              $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/Enable RDP Powershell.md"           $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/hashcat.md"                         $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/john.md"                            $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/mimikatz.md"                        $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/samdump2.md"                        $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/SAM.md"                             $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/sharpGPOAbuse.md"                   $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/winpeas.md"                         $DOCS/privilege-escalation/windows/
mv "$DOCS/Exploitation/Escalation/winEscalation/potatos/DCOMPotato.md"              $DOCS/privilege-escalation/windows/potatoes/
mv "$DOCS/Exploitation/Escalation/winEscalation/potatos/EfsPotato.md"               $DOCS/privilege-escalation/windows/potatoes/
mv "$DOCS/Exploitation/Escalation/winEscalation/potatos/GodPotato.md"               $DOCS/privilege-escalation/windows/potatoes/
mv "$DOCS/Exploitation/Escalation/winEscalation/potatos/juicypotato.md"             $DOCS/privilege-escalation/windows/potatoes/
mv "$DOCS/Exploitation/Escalation/winEscalation/potatos/printspoofer.md"            $DOCS/privilege-escalation/windows/potatoes/
mv "$DOCS/Exploitation/Escalation/winEscalation/potatos/RoguePotato.md"             $DOCS/privilege-escalation/windows/potatoes/
mv "$DOCS/Exploitation/Escalation/winEscalation/potatos/SharpEfsPotato.md"          $DOCS/privilege-escalation/windows/potatoes/
mv "$DOCS/Exploitation/Escalation/winEscalation/potatos/SigmaPotato.md"             $DOCS/privilege-escalation/windows/potatoes/
mv "$DOCS/Exploitation/windows/winEscalation/Acl-FullControl.md"                    $DOCS/privilege-escalation/windows/Acl-FullControl-2.md
mv "$DOCS/Exploitation/windows/winEscalation/hashcat.md"                            $DOCS/privilege-escalation/windows/hashcat-2.md
mv "$DOCS/Exploitation/windows/winEscalation/john.md"                               $DOCS/privilege-escalation/windows/john-2.md
mv "$DOCS/Exploitation/windows/winEscalation/mimikatz.md"                           $DOCS/privilege-escalation/windows/mimikatz-2.md
mv "$DOCS/Exploitation/windows/winEscalation/samdump2.md"                           $DOCS/privilege-escalation/windows/samdump2-2.md
mv "$DOCS/Exploitation/windows/winEscalation/SAM.md"                                $DOCS/privilege-escalation/windows/SAM-2.md
mv "$DOCS/Exploitation/windows/winEscalation/winpeas.md"                            $DOCS/privilege-escalation/windows/winpeas-2.md

# ── ACTIVE DIRECTORY ────────────────────────────────────────
mv "$DOCS/Exploitation/Escalation/Active Directory/bloodhound.md"                   $DOCS/active-directory/enumeration/
mv "$DOCS/Exploitation/Escalation/Active Directory/PowerView.md"                    $DOCS/active-directory/enumeration/
mv "$DOCS/Exploitation/Escalation/Active Directory/kerbrute.md"                     $DOCS/active-directory/enumeration/
mv "$DOCS/Exploitation/Escalation/Active Directory/impacket-GetNPUser.md"           $DOCS/active-directory/enumeration/
mv "$DOCS/Exploitation/Escalation/Active Directory/winrs and WMI, WinRM.md"         $DOCS/active-directory/enumeration/
mv "$DOCS/Exploitation/windows/Active Directory/bloodhound.md"                      $DOCS/active-directory/enumeration/bloodhound-2.md
mv "$DOCS/Exploitation/windows/Active Directory/PowerView.md"                       $DOCS/active-directory/enumeration/PowerView-2.md
mv "$DOCS/Exploitation/Escalation/Active Directory/As-rep-roasting.md"              $DOCS/active-directory/attacks/
mv "$DOCS/Exploitation/Escalation/Active Directory/kerberoasting.md"                $DOCS/active-directory/attacks/
mv "$DOCS/Exploitation/Escalation/Active Directory/Pass the hash.md"                $DOCS/active-directory/attacks/
mv "$DOCS/Exploitation/Escalation/Active Directory/Rubeus.exe.md"                   $DOCS/active-directory/attacks/
mv "$DOCS/Exploitation/Escalation/Active Directory/Overpass the Hash.md"            $DOCS/active-directory/lateral-movement/
mv "$DOCS/Exploitation/Escalation/Active Directory/Pass the ticket.md"              $DOCS/active-directory/lateral-movement/
mv "$DOCS/Exploitation/Escalation/Active Directory/DCSync.md"                       $DOCS/active-directory/persistence/
mv "$DOCS/Exploitation/Escalation/Active Directory/Golden Ticket.md"                $DOCS/active-directory/persistence/
mv "$DOCS/Exploitation/Escalation/Active Directory/Silver Tickets.md"               $DOCS/active-directory/persistence/
mv "$DOCS/Exploitation/Escalation/Active Directory/Shadow Copies.md"                $DOCS/active-directory/persistence/
mv "$DOCS/Exploitation/Escalation/Active Directory/AD-DACL -- Discretionary Access Control List.md" $DOCS/active-directory/abuse/
mv "$DOCS/Exploitation/Escalation/Active Directory/gpo abuse.md"                    $DOCS/active-directory/abuse/
mv "$DOCS/Exploitation/Escalation/Active Directory/jenkins.md"                      $DOCS/active-directory/abuse/

# ── LINUX MISC ──────────────────────────────────────────────
mv "$DOCS/Linux - Miscellaneous/Background Jobs.md"                                 $DOCS/linux-misc/
mv "$DOCS/Linux - Miscellaneous/Basics about shell and others.md"                   $DOCS/linux-misc/
mv "$DOCS/Linux - Miscellaneous/Obsidian Commands.md"                               $DOCS/linux-misc/
mv "$DOCS/Linux - Miscellaneous/Kali Linux/Fix and Tweaks.md"                       $DOCS/linux-misc/kali/
mv "$DOCS/Linux - Miscellaneous/Kali Linux/Shared Folder Mount.md"                  $DOCS/linux-misc/kali/
mv "$DOCS/Exploitation/python/python http.server.md"                                $DOCS/linux-misc/
mv "$DOCS/Exploitation/python/python virtual environment.md"                        $DOCS/linux-misc/

# ── TOOLS ───────────────────────────────────────────────────
mv "$DOCS/myOwnTools/s4v/creating function in kali.md"                              $DOCS/tools/s4v/
mv "$DOCS/myOwnTools/s4v/extractPorts.md"                                           $DOCS/tools/s4v/
mv "$DOCS/myOwnTools/s4v/htbExplorer.md"                                            $DOCS/tools/s4v/
mv "$DOCS/myOwnTools/s4v/whichSystem.md"                                            $DOCS/tools/s4v/
mv "$DOCS/reconn & enum/Information Gathering Tools/Information Gathering Tools.md" $DOCS/tools/

echo ""
echo "Done. Run: find docs -type f -name '*.md' | sort"
echo "Then review and run: mkdocs build"
