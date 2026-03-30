
https://github.com/ffuf/ffuf
https://www.thehacker.recipes/web/recon/directory-fuzzing

ffuf -H "User-Agent: PENTEST" -c -w "/path/to/wordlist.txt" -maxtime-job 60 -recursion -recursion-depth 2 -u $URL/FUZZ

`ffuf -w "/usr/share/wordlists/dirb/common.txt" -recursion -recursion-depth 2 -u http://192.168.162.46/FUZZ `


Recursive search
```
 hydden@hydden  ~  ffuf -w "/usr/share/wordlists/dirbuster/directory-list-2.3-small.txt" -recursion -recursion-depth 2 -u http://192.168.162.46/FUZZ
```

# Regular web search
```
ffuf -u http://192.168.238.103:8080/FUZZ/ -w /usr/share/seclists/Discovery/Web-Content/common.txt
```

For files:
```
ffuf -u http://192.168.238.103:8080/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt
```

For directories:
```
ffuf -u http://192.168.238.103:8080/FUZZ/ -w /usr/share/seclists/Discovery/Web-Content/common.txt
```