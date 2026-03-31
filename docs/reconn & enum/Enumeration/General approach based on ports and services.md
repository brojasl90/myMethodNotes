
https://ippsec.rocks/

# port 445 SMB

Run anonymous smb enum
```
smbclient -L 192.168.1.1
```

# port 53 DNS

DNS look for hostname of server or host
```
nslookup 
127.0.0.1
127.0.0.2
192.168.1.1
```

# port 636 3269 ldapsearch

```
ldapsearch -h 192.168.1.1
```

Basic authentication
```
ldapsearch -h 192.168.1.1 -x
```
Naming context
```
ldapsearch -h 192.168.1.1 -x -s base namingcontexts
```
![[Pasted image 20240918193100.png]]

```
ldapsearch -h 192.168.1.1 -x -b "DC=htb,DC=local" > ldap-anonymous.out
```

Search based on object type user
```
ldapsearch -h 192.168.1.1 -x -b "DC=htb,DC=local" '(objectClass=Person)'
```

Search based on object type user and filter by a name, in this case sAMAccountName
```
ldapsearch -h 192.168.1.1 -x -b "DC=htb,DC=local" '(objectClass=Person)' sAMAccountName
```

Search based on object type user and filter by a name, in this case sAMAccountName then getting the emails to perform password spray
```
ldapsearch -h 192.168.1.1 -x -b "DC=htb,DC=local" '(objectClass=User)' sAMAccountName | grep sAMAccountName | awk '{print $2}' > userList.ldap
```
it requires a manual a clean up


Creating our own custom wordlist to crack
- Include months
- Common passwords
- Common name on the company context
- Seasons

pwlist.txt
```
January
Februeary
.
.
.
Password
P@ssw0rd
Forest
htb
Secret
Autum
Fall
Spring
Winter
```

Randomized it
```
for i in $(cat pwlist.txt);do echo $i; echo ${i}2019; echo ${i}2020; done > t
mv t pwlist.txt
cat t
```

# Cracking hashes
```
hashcat --force --stdout pwlist.txt /usr/share/hashcat/rules/best64.rule
```


Adding exclamation points to our list of passwords
```
hashcat --force --stdout pwlist.txt /usr/share/hashcat/rules/best64.rule | grep '\!'
```

```
for i in $(cat pwlist.txt);do echo $i; echo ${i}\!; echo ${i}2020; done > t
mv t pwlist.txt
```

```
hashcat --force --stdout pwlist.txt -r /usr/share/hashcat/rules/best64.rule|wc -l
10104
```

```
hashcat --force --stdout pwlist.txt -r /usr/share/hashcat/rules/best64.rule -r /usr/share/hashcat/rules/toggles1.rule | sort -u |wc -l
52077
```

```
hashcat --force --stdout pwlist.txt -r /usr/share/hashcat/rules/best64.rule -r /usr/share/hashcat/rules/toggles1.rule | sort -u | awk 'length($0) > 7'| wc -l
52077
```

```
hashcat --force --stdout pwlist.txt -r /usr/share/hashcat/rules/best64.rule -r /usr/share/hashcat/rules/toggles1.rule | sort -u | awk 'length($0) > 7' > t
cp t pwlist.txt
```

