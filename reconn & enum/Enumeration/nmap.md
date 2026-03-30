
Good trick
Use the standard nmap first for regular known ports
```
nmap -vv -sC -sV -oA nmap/MachineName 192.168.100.1
```

Instruct to wait for 5 minutes (sleep 300), then run for all ports -p- :
```
sleep 300; nmap -p- --open -T4 --min-rate=5000 -oA nmap/MachineName-allports -vv -n 192.168.100.1
```

```
sleep 300; sudo nmap --min-rate=5000 -p- -oN nmap/MS01-allports -vv -T4 -n 192.168.162.153
```

## UDP
```
sudo nmap -sU -Pn 192.168.224.149
```
UDP 1000 ports
```
sudo nmap -sU -T4 --open -vvv --top-ports 1000 192.168.224.149
```

### SNMP 161
```
sudo nmap -sU -Pn -p 161 -A -sC -vvv 192.168.224.149
```
#### SNMP Servers Community Strings
```
sudo nmap -sU -p 161 --script snmp-brute -vvv 192.168.224.149

┌──(kali㉿kali)-[~]
└─$ sudo nmap -sU -p 161 --script snmp-brute -vvv 192.168.224.149
PORT    STATE SERVICE REASON
161/udp open  snmp    udp-response ttl 61
| snmp-brute: 
|_  public - Valid credentials

NSE: Script Post-scanning.
NSE: Starting runlevel 1 (of 1) scan.
Initiating NSE at 17:34
Completed NSE at 17:34, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 3.46 seconds
           Raw packets sent: 6 (319B) | Rcvd: 2 (115B)
```

Bruteforcing community strings with custom wordlist:
```
sudo nmap -sU -p 161 --script snmp-brute --script-args snmp-brute.communitiesdb=/usr/share/seclists/Discovery/SNMP/common-snmp-community-strings.txt 192.168.224.149

┌──(kali㉿kali)-[~]
└─$ sudo nmap -sU -p 161 --script snmp-brute --script-args snmp-brute.communitiesdb=/usr/share/seclists/Discovery/SNMP/common-snmp-community-strings.txt 192.168.224.149
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-10-02 17:36 EDT
Nmap scan report for kiero.oscp.exam (192.168.224.149)
Host is up (0.11s latency).

PORT    STATE SERVICE
161/udp open  snmp
| snmp-brute: 
|_  public - Valid credentials

Nmap done: 1 IP address (1 host up) scanned in 8.89 seconds
```

Using SNMPWALK
[[masterDoc/myMethodology/reconn & enum/Information Gathering Tools/Active/SNMP Enumeration/snmpwalk]]

Use **-sV** to enable service and version detection as well as **-sC** to use Nmap's default scripts. In addition, we'll enter **-oN** to create an output file containing the scan results.
```
kali@kali:~/beyond$ sudo nmap -sC -sV -oN mailsrv1/nmap 192.168.50.242
Starting Nmap 7.92 ( https://nmap.org ) at 2022-09-29 08:53 EDT
Nmap scan report for 192.168.50.242
Host is up (0.11s latency).
Not shown: 992 closed tcp ports (reset)
PORT    STATE SERVICE       VERSION
25/tcp  open  smtp          hMailServer smtpd
| smtp-commands: MAILSRV1, SIZE 20480000, AUTH LOGIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
80/tcp  open  http          Microsoft IIS httpd 10.0
|_http-title: IIS Windows Server
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
110/tcp open  pop3          hMailServer pop3d
|_pop3-capabilities: UIDL USER TOP
135/tcp open  msrpc         Microsoft Windows RPC
139/tcp open  netbios-ssn   Microsoft Windows netbios-ssn
143/tcp open  imap          hMailServer imapd
|_imap-capabilities: IMAP4 CHILDREN OK ACL IMAP4rev1 completed CAPABILITY NAMESPACE IDLE RIGHTS=texkA0001 SORT QUOTA
445/tcp open  microsoft-ds?
587/tcp open  smtp          hMailServer smtpd
| smtp-commands: MAILSRV1, SIZE 20480000, AUTH LOGIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
Service Info: Host: MAILSRV1; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2022-09-29T12:54:00
|_  start_date: N/A
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
|_clock-skew: 21s

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 37.95 seconds
```

