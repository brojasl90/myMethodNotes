[[obsidian/OSCP/Information Gathering Tools/Active/Port Scanning with Nmap/nmap]]

[[smbclient]]

## smbclient
Anonymously log in. This is also called “**Null SESSION ATTACK**”
```
smbclient -L 192.168.125.180
```

Connecting to a share
```
smbclient \\\\192.168.125.180\Workshares
```

Connecting to a share withpassword
```
smbclient \\\\10.10.198.140\\Users -U celia.almeda%password
```

Connecting to a share with hash
```
smbclient \\\\10.10.198.140\\Users -U celia.almeda --pw-nt-hash e728ecbadfb02f51ce8eed753f3ff3fd
```

https://medium.com/analytics-vidhya/interacting-with-a-windows-share-from-linux-dc147e209c5b

Connecting to a share with withpassword and domain, domain: -U 'example.com/username' and the password will be asked
```
smbclient \\\\192.168.166.147\\setup -U 'oscp.exam/WEB_SVC'
```

Recursively download a folder
```shell
┌──(kali㉿kali)-[~/HTB/Active]
└─$ smbclient \\\\10.10.10.100\\Replication
Password for [WORKGROUP\kali]:
Anonymous login successful
Try "help" to get a list of possible commands.
smb: \> dir
  .                                   D        0  Sat Jul 21 04:37:44 2018
  ..                                  D        0  Sat Jul 21 04:37:44 2018
  active.htb                          D        0  Sat Jul 21 04:37:44 2018

                5217023 blocks of size 4096. 277855 blocks available
smb: \> recurse ON
smb: \> mget *
Get directory active.htb? yes
Get directory DfsrPrivate? yes
Get directory Policies? yes
Get directory scripts? yes
Get directory ConflictAndDeleted? yes
Get directory Deleted? yes 
Get directory Installing? yes
```
## nmap

smb-os-discovery
```
nmap -v -p 139,445 --script smb-os-discovery 10.10.10.100
```

Listing 41 - Using nmap to scan for the NetBIOS service
```
kali@kali:~$ nmap -v -p 139,445 -oG smb.txt 192.168.50.1-254

kali@kali:~$ cat smb.txt
# Nmap 7.92 scan initiated Thu Mar 17 06:03:12 2022 as: nmap -v -p 139,445 -oG smb.txt 192.168.50.1-254
# Ports scanned: TCP(2;139,445) UDP(0;) SCTP(0;) PROTOCOLS(0;)
Host: 192.168.50.1 ()	Status: Down
...
Host: 192.168.50.21 ()	Status: Up
Host: 192.168.50.21 ()	Ports: 139/closed/tcp//netbios-ssn///, 445/closed/tcp//microsoft-ds///
...
Host: 192.168.50.217 ()	Status: Up
Host: 192.168.50.217 ()	Ports: 139/closed/tcp//netbios-ssn///, 445/closed/tcp//microsoft-ds///
# Nmap done at Thu Mar 17 06:03:18 2022 -- 254 IP addresses (15 hosts up) scanned in 6.17 seconds
```

Listing 43 - Finding various nmap SMB NSE scripts
```
kali@kali:~$ ls -1 /usr/share/nmap/scripts/smb*
/usr/share/nmap/scripts/smb2-capabilities.nse
/usr/share/nmap/scripts/smb2-security-mode.nse
/usr/share/nmap/scripts/smb2-time.nse
/usr/share/nmap/scripts/smb2-vuln-uptime.nse
/usr/share/nmap/scripts/smb-brute.nse
/usr/share/nmap/scripts/smb-double-pulsar-backdoor.nse
/usr/share/nmap/scripts/smb-enum-domains.nse
/usr/share/nmap/scripts/smb-enum-groups.nse
/usr/share/nmap/scripts/smb-enum-processes.nse
/usr/share/nmap/scripts/smb-enum-sessions.nse
/usr/share/nmap/scripts/smb-enum-shares.nse
/usr/share/nmap/scripts/smb-enum-users.nse
/usr/share/nmap/scripts/smb-os-discovery.nse
...
```

The SMB discovery script works only if SMBv1 is enabled on the target, which is not the default case on modern versions of Windows. However, plenty of legacy systems are still running SMBv1, and we have enabled this specific version on the Windows host to simulate such a scenario.

Let's try the _smb-os-discovery_ module on the Windows 11 client.

Listing 44 - Using the nmap scripting engine to perform OS discovery
```
kali@kali:~$ nmap -v -p 139,445 --script smb-os-discovery 192.168.50.152
...
PORT    STATE SERVICE      REASON
139/tcp open  netbios-ssn  syn-ack
445/tcp open  microsoft-ds syn-ack

Host script results:
| smb-os-discovery:
|   OS: Windows 10 Pro 22000 (Windows 10 Pro 6.3)
|   OS CPE: cpe:/o:microsoft:windows_10::-
|   Computer name: client01
|   NetBIOS computer name: CLIENT01\x00
|   Domain name: megacorptwo.com
|   Forest name: megacorptwo.com
|   FQDN: client01.megacorptwo.com
|_  System time: 2022-03-17T11:54:20-07:00
...
```

## nbtscan
Listing 42 - Using nbtscan to collect additional NetBIOS information
```
kali@kali:~$ sudo nbtscan -r 192.168.50.0/24
Doing NBT name scan for addresses from 192.168.50.0/24

IP address       NetBIOS Name     Server    User             MAC address
------------------------------------------------------------------------------
192.168.50.124   SAMBA            <server>  SAMBA            00:00:00:00:00:00
192.168.50.134   SAMBAWEB         <server>  SAMBAWEB         00:00:00:00:00:00
...
```

## net view
Listing 45 - Running 'net view' to list remote shares
```
C:\Users\student>net view \\dc01 /all
Shared resources at \\dc01

Share name  Type  Used as  Comment

-------------------------------------------------------------------------------
ADMIN$      Disk           Remote Admin
C$          Disk           Default share
IPC$        IPC            Remote IPC
NETLOGON    Disk           Logon server share
SYSVOL      Disk           Logon server share
The command completed successfully.
```
