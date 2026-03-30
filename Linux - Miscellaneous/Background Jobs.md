Search background jobs
```
ps -eo pid,pgid,tpgid,args | awk 'NR == 1 || ($3 != -1 && $2 != $3)'
```

Example
```
┌──(kali㉿kali)-[~/Medtech-Challenge1/Medtech121]
└─$ ps -eo pid,pgid,tpgid,args | awk 'NR == 1 || ($3 != -1 && $2 != $3)'
    PID    PGID   TPGID COMMAND
   1759    1759   38304 /usr/bin/zsh
   1768    1768   39922 /usr/bin/zsh
  39939   39939   39940 sudo openvpn universal.ovpn
  98840   98840  173093 /usr/bin/zsh
  98860   98860  148584 /usr/bin/zsh
 125845  125845  173093 nc -vlp 4444
```