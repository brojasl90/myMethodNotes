
https://docs.python.org/3/library/venv.html
https://stackoverflow.com/questions/75608323/how-do-i-solve-error-externally-managed-environment-every-time-i-use-pip-3

Creating the virtual env using **venv**
```
┌──(tutorial-venv)─(kali㉿kali)-[~/Documents/PG/Twiggy/CVE-2020-11651-poc]
└─$ python -m venv my-venv
```

Sometimes it requires to be activated
```
┌──(tutorial-venv)─(kali㉿kali)-[~/Documents/PG/Twiggy/CVE-2020-11651-poc]
└─$ source my-venv/bin/activate
```

Now using to install packages as example, Installing **salt** within environment
```
┌──(tutorial-venv)─(kali㉿kali)-[~/Documents/PG/Twiggy/CVE-2020-11651-poc]
└─$ my-venv/bin/pip install salt
Collecting salt
  Downloading salt-3007.1.tar.gz (19.4 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 19.4/19.4 MB 6.0 MB/s eta 0:00:00
```

Now using python environment
```
┌──(tutorial-venv)─(kali㉿kali)-[~/Documents/PG/Twiggy/CVE-2020-11651-poc]
└─$ my-venv/bin/python exploit.py -h
usage: exploit.py [-h] [--master MASTER_IP] [--port MASTER_PORT] [--force] [--debug] [--run-checks]
                  [--read READ_FILE] [--upload-src UPLOAD_SRC] [--upload-dest UPLOAD_DEST] [--exec EXEC]
                  [--exec-all EXEC_ALL]

Saltstack exploit for CVE-2020-11651 and CVE-2020-11652

options:
  -h, --help            show this help message and exit
  --master MASTER_IP, -m MASTER_IP
  --port MASTER_PORT, -p MASTER_PORT
```