
## Get local users
```
Get-LocalUser
```
## Get local groups
```
Get-LocalGroup
```
## Lists local groups
```
net localgroup
```
## Lists members of a specific group
```
Get-LocalGroupMember -GroupName [GroupName]
```

```
*Evil-WinRM* PS C:\temp> Get-LocalGroupMember Administrators

ObjectClass Name               PrincipalSource
----------- ----               ---------------
User        MS01\Administrator Local
Group       OSCP\Domain Admins ActiveDirectory
```

# Apps info

## Lists installed 32-bit applications.
```
 Get-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object -Property DisplayName
```
## Lists installed 64-bit applications.
```
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object -Property DisplayName
```
## Lists all running processes.
```
Get-Process | Select-Object -Property ProcessName, Path
```

## List of services with binary path
```
Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'}
```

```
PS C:\Users\dave> Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'}

Name                      State   PathName
----                      -----   --------
Apache2.4                 Running "C:\xampp\apache\bin\httpd.exe" -k runservice
Appinfo                   Running C:\Windows\system32\svchost.exe -k netsvcs -p
AppXSvc                   Running C:\Windows\system32\svchost.exe -k wsappx -p
AudioEndpointBuilder      Running C:\Windows\System32\svchost.exe -k LocalSystemNetworkRestricted -p
Audiosrv                  Running C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
BFE                       Running C:\Windows\system32\svchost.exe -k LocalServiceNoNetworkFirewall -p
BITS                      Running C:\Windows\System32\svchost.exe -k netsvcs -p
BrokerInfrastructure      Running C:\Windows\system32\svchost.exe -k DcomLaunch -p
...
mysql                     Running C:\xampp\mysql\bin\mysqld.exe --defaults-file=c:\xampp\mysql\bin\my.ini mysql
```

## Evaluate if we can stop/restart service
```
Get-CimInstance -ClassName win32_service | Select Name, StartMode | Where-Object {$_.Name -like 'mysql'}
```

## Validate if we can restart the machine with SeShutdownPrivilege
```
PS C:\temp> whoami /priv
whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                          State   
============================= ==================================== ========
SeShutdownPrivilege           Shut down the system                 Disabled
SeChangeNotifyPrivilege       Bypass traverse checking             Enabled 
SeUndockPrivilege             Remove computer from docking station Disabled
SeIncreaseWorkingSetPrivilege Increase a process working set       Disabled
SeTimeZonePrivilege           Change the time zone                 Disabled
```

## Stop and start service

```
Start-Service GPGOrchestrator
```

```
Stop-Service GPGOrchestrator
```

## Validate if app is still running
```
Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.Name -like 'GPGOrchestrator'}
```

Example of a stopped app
```
Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.Name -like 'GPGOrchestrator'}

Name            State   PathName                                   
----            -----   --------                                   
GPGOrchestrator Stopped "C:\Program Files\MilleGPG5\GPGService.exe"
```