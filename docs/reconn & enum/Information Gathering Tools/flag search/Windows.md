```
PS C:\Windows\system32> $filename = '*flag*.*'           
$filename = '*flag*.*'
PS C:\Windows\system32> $searchinfolder = 'C:\inetpub*'                                                                                                    
$searchinfolder = 'C:\inetpub*'
PS C:\Windows\system32> Get-ChildItem -Path $searchinfolder -Filter $filename -Recurse | %{$_.FullName}
Get-ChildItem -Path $searchinfolder -Filter $filename -Recurse | %{$_.FullName}
Get-ChildItem : Access to the path 'C:\inetpub\history' is denied.
At line:1 char:1
+ Get-ChildItem -Path $searchinfolder -Filter $filename -Recurse | %{$_ ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : PermissionDenied: (C:\inetpub\history:String) [Get-ChildItem], UnauthorizedAccessExcepti 
   on
    + FullyQualifiedErrorId : DirUnauthorizedAccessError,Microsoft.PowerShell.Commands.GetChildItemCommand
 
Get-ChildItem : Access to the path 'C:\inetpub\logs' is denied.
At line:1 char:1
+ Get-ChildItem -Path $searchinfolder -Filter $filename -Recurse | %{$_ ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : PermissionDenied: (C:\inetpub\logs:String) [Get-ChildItem], UnauthorizedAccessException
    + FullyQualifiedErrorId : DirUnauthorizedAccessError,Microsoft.PowerShell.Commands.GetChildItemCommand
 
Get-ChildItem : Access to the path 'C:\inetpub\temp\appPools' is denied.
At line:1 char:1
+ Get-ChildItem -Path $searchinfolder -Filter $filename -Recurse | %{$_ ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : PermissionDenied: (C:\inetpub\temp\appPools:String) [Get-ChildItem], UnauthorizedAccessE 
   xception
    + FullyQualifiedErrorId : DirUnauthorizedAccessError,Microsoft.PowerShell.Commands.GetChildItemCommand
 
Get-ChildItem : Access to the path 'C:\inetpub\temp\IIS Temporary Compressed Files' is denied.
At line:1 char:1
+ Get-ChildItem -Path $searchinfolder -Filter $filename -Recurse | %{$_ ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : PermissionDenied: (C:\inetpub\temp...ompressed Files:String) [Get-ChildItem], Unauthoriz 
   edAccessException
    + FullyQualifiedErrorId : DirUnauthorizedAccessError,Microsoft.PowerShell.Commands.GetChildItemCommand
 
C:\inetpub\wwwroot\flag.txt
```


Searching files with command prompt

https://www.howtogeek.com/674537/how-to-find-and-open-files-using-command-prompt/

```
C:\>dir "flag*" /s
dir "flag*" /s
 Volume in drive C has no label.
 Volume Serial Number is 0CB0-F9D1

 Directory of C:\inetpub\wwwroot

05/30/2024  02:26 PM                78 flag.txt
               1 File(s)             78 bytes

     Total Files Listed:
               1 File(s)             78 bytes
               0 Dir(s)  13,193,322,496 bytes free
```

```
dir "\example file*" /s
```


[[Keepass]]

Keepass search Powershell
```
PS C:\Users\dave> Get-ChildItem -Path C:\ -Include *.kdbx -File -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path C:\ -Include *.kdbx -File -Recurse -ErrorAction SilentlyContinue
```

> Listing 17 - Searching for password manager databases on the C:\ drive

Search for proof and local txt within `C:\Users\`
local.txt 
```
Get-ChildItem -Path C:\Users\ -Include local.txt -File -Recurse -ErrorAction SilentlyContinue
```
proof.txt
```
Get-ChildItem -Path C:\Users\ -Include proof.txt -File -Recurse -ErrorAction SilentlyContinue
```

Search for proof and local txt within `C:\`
local.txt 
```
Get-ChildItem -Path C:\ -Include local.txt -File -Recurse -ErrorAction SilentlyContinue
```
proof.txt
```
Get-ChildItem -Path C:\ -Include proof.txt -File -Recurse -ErrorAction SilentlyContinue
```