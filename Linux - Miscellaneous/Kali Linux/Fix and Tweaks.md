
# Fixing crackmapexec - nxc

https://forum.yunohost.org/t/modulenotfounderror-no-module-named-openssl/29598/6

```bash
sudo apt install python3-openssl --reinstall
```

https://www.kali.org/docs/virtualization/install-vmware-guest-tools/

# Fix 2 monitors - Reinstall-VM-Tools

](https://www.kali.org/docs/virtualization/install-vmware-guest-tools/#open-vm-tools)

Should you decide to [create your own VMware installation of Kali Linux](https://www.kali.org/docs/virtualization/install-vmware-guest-vm/) _(rather than using our [pre-made VMware images](https://www.kali.org/get-kali/#kali-virtual-machines))_, and you want to force a manual reinstall of `open-vm-tools` (as something has gone wrong), first make sure you are [fully updated](https://www.kali.org/docs/general-use/updating-kali/), then enter the following:

```console
kali@kali:~$ sudo apt update
[...]
kali@kali:~$
kali@kali:~$ sudo apt install -y --reinstall open-vm-tools-desktop fuse
[...]
kali@kali:~$
kali@kali:~$ sudo reboot -f
```