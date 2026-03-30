Gobuster supports different enumeration modes, including fuzzing and dns, but for now, we'll only rely on the **dir** mode, which enumerates files and directories. We need to specify the target IP using the **-u** parameter and a wordlist with **-w**. The default running threads are 10; we can reduce the amount of traffic by setting a lower number via the **-t** parameter.

# Important Gobuster does not offer recursive, it is faster ffuz

```
-u [http://url:port/path](http://url:port/path)
```

```
kali@kali:~$ gobuster dir -u 192.168.50.20 -w /usr/share/wordlists/dirb/common.txt -t 5
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://192.168.50.20
[+] Method:                  GET
[+] Threads:                 5
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/03/30 05:16:21 Starting gobuster in directory enumeration mode
===============================================================
/.hta                 (Status: 403) [Size: 278]
/.htaccess            (Status: 403) [Size: 278]
/.htpasswd            (Status: 403) [Size: 278]
/css                  (Status: 301) [Size: 312] [--> http://192.168.50.20/css/]
/db                   (Status: 301) [Size: 311] [--> http://192.168.50.20/db/]
/images               (Status: 301) [Size: 315] [--> http://192.168.50.20/images/]
/index.php            (Status: 302) [Size: 0] [--> ./login.php]
/js                   (Status: 301) [Size: 311] [--> http://192.168.50.20/js/]
/server-status        (Status: 403) [Size: 278]
/uploads              (Status: 301) [Size: 316] [--> http://192.168.50.20/uploads/]

===============================================================
2022/03/30 05:18:08 Finished
===============================================================
```

> Listing 3 - Running Gobuster


Searching for files specific using -x flag
`gobuster dir -u 192.168.161.197 -w /usr/share/wordlists/wfuzz/general/big.txt -x pdf`

```
 hydden@hydden  ~/Downloads  gobuster dir -u 192.168.161.197 -w /usr/share/wordlists/wfuzz/general/big.txt -x pdf 
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://192.168.161.197
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/wfuzz/general/big.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.6
[+] Extensions:              pdf
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/info.pdf             (Status: 200) [Size: 309737]
/old.pdf              (Status: 200) [Size: 462554]
Progress: 6048 / 6050 (99.97%)
===============================================================
Finished
===============================================================
```

`gobuster dir -u 192.168.161.197 -w /usr/share/wordlists/wfuzz/general/big.txt -x pdf`

```
gobuster dir -u 10.10.171.247:80 -w /usr/share/wordlists/dirb/common.txt -x jpg,png,jpeg
```


Version 3

`gobuster dir -u 'http://192.168.205.202:8000' -w /usr/share/wordlists/dirb/common.txt -t 5`

`gobuster dir -u 'http://192.168.205.202:8000' -w /usr/share/wordlists/wfuzz/general/big.txt -x pdf`


Using megabeast.txt list
https://github.com/xmendez/wfuzz/blob/master/wordlist/general/megabeast.txt


## Using gobuster to identify pages and files on

```
kali@kali:~/beyond$ gobuster dir -u http://192.168.50.242 -w /usr/share/wordlists/dirb/common.txt -o mailsrv1/gobuster -x txt,pdf,config 
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://192.168.50.242
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Extensions:              txt,pdf,config
[+] Timeout:                 10s
===============================================================
2022/09/29 11:12:27 Starting gobuster in directory enumeration mode
===============================================================

                                
===============================================================
2022/09/29 11:16:00 Finished
===============================================================
```



```
gobuster dir -u http://192.168.50.242 -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-small.txt -o web/gobuster -x txt,pdf,config 
```
# adding codes that are causing errrors
```
sudo gobuster dir -w '/usr/share/wordlists/dirb/common.txt' -u http://192.168.238.103:8080 -t 42 -b 400,401,403,404 --no-error
```

## skip TLS / SSL validation
--no-tls-validation

```
gobuster dir -u https://192.168.241.140:443 -w /usr/share/wordlists/dirb/common.txt -o web/gobuster -x txt,pdf,config --no-tls-validation
```
# remember to always use ffuz as well
[[obsidian_09112024/OSCP/Scanning & Reconn/Enumeration/Web/ffuf]]
```
ffuf -u http://192.168.238.103:8080/FUZZ/ -w /usr/share/seclists/Discovery/Web-Content/common.txt
```