Kali Linux comes pre-installed with a tool called `samdump2`. We can combine the SYSTEM and SAM file with this tool to extract local user accounts and hashes.

```
samdump2 SYSTEM SAM -o /home/kali/SAMhashes.txt
```

Once completed we can `cat` the file to confirm if we have extracted account hashes.

![[masterDoc/offsec/OSCP/Pictures/Pasted image 20240719010119.png]]