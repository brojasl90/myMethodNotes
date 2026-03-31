
```
1..254 | % {echo "172.16.6.$_"; ping -n 1 -w 100 172.16.6.$_} | Select-String ttl
```