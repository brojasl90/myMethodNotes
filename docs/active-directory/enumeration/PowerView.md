https://powersploit.readthedocs.io/en/latest/Recon/

https://book.hacktricks.xyz/windows-hardening/basic-powershell-for-pentesters/powerview

https://github.com/PowerShellMafia/PowerSploit/blob/dev/Recon/PowerView.ps1

Invoke it, and run Invoke-Kerberoast
```
PS C:\temp> . .\PowerView.ps1
PS C:\temp> Invoke-Kerberoast
```

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

![[Pasted image 20241029222519.png]]


