
## My Kali 
```
┌──(kali㉿kali)-[/mnt/hgfs/SharedKali]
└─$ pwd
/mnt/hgfs/SharedKali
```

https://systemweakness.com/how-to-add-a-shared-folder-to-kali-linux-in-vmware-in-windows-11-e4461010a4f2

## STEP 2 : Editing ‘/etc/fstab’

Even though simply adding the folder to the VM is enough for the folder contents to be accessed through a VM in Virtual-box (>>[Which is discussed in this article](https://hasanka-amarasinghe.medium.com/how-to-add-a-shared-folder-in-virtualbox-in-windows-11-66318387105)<<), we need to do some changes in the VMware VMs.

Open a terminal of your choice and go to `/mnt/hgfs`

cd /mnt/hgfs
If you don't see anything in the folder, there’s a good chance that you will need to follow the below steps :D
If the folder is missing, why not just create it with :

sudo mkdir /mnt/hgfs
![](https://miro.medium.com/v2/resize:fit:240/1*D3CgHRoyFPAF8fVhDD9WNg.png)

open and edit fstab with a editor of your choice (I prefer nano over vim for many reasons, and one of them being : !wq)

sudo nano /etc/fstab

enter the following at the end of the file, if you want this to work

vmhgfs-fuse /mnt/hgfs fuse defaults,allow_other 0 0

![](https://miro.medium.com/v2/resize:fit:648/1*DZOIOElTN8qPJvfouC58KA.png)

now save with CTRL + S and exit with CTRL + X
 
Reboot the VM now by just typing ‘reboot’

![](https://miro.medium.com/v2/resize:fit:220/1*fH3Hzg-3NU87Z7RkHPmsgA.png)

BAM! that’s it, once rebooted, it should display you the contents of the Shared folder, if you have any files already in it..

![](https://miro.medium.com/v2/resize:fit:700/1*ZfpKFPAsUYd4HTFl5kjIww.png)

I was a huge fan of Virtualbox like since 2010 since someone changed my opinion on VMware and so far it had been fast and effective, hope it will remain the same under load as well