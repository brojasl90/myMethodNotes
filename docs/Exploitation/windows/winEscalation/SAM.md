
As it looks like a backup of the system we should see if the SAM and SYSTEM files have been backed up. Normally these files are locked when the system is running but if backed up hopefully we will be able to download them.

First we need to go the directory `Windows\System32\Config` and then use the `get` command to download the files.

![[masterDoc/offsec/OSCP/Pictures/Pasted image 20240719005811.png]]

Another way is to 

Kali Linux comes pre-installed with a tool called `samdump2`. We can combine the SYSTEM and SAM file with this tool to extract local user accounts and hashes.

```
samdump2 SYSTEM SAM -o /home/kali/SAMhashes.txt
```

Once completed we can `cat` the file to confirm if we have extracted account hashes.

![[masterDoc/offsec/OSCP/Pictures/Pasted image 20240719005847.png]]