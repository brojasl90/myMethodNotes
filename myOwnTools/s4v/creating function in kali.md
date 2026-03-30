
# extractPorts

To make this function a permanent part of your Kali Linux toolkit, you need to add it to your shell’s configuration file. Since Kali switched its default shell a few years ago, we first need to check which one you are using.
## Step 1: Identify Your Shell

Open your terminal and run:
Bash

echo $SHELL

    If it says /usr/bin/zsh (the Kali default), you will edit .zshrc.

    If it says /bin/bash, you will edit .bashrc.



```
┌──(kali㉿kali)-[~/HTB/Calamity/lxd-alpine-builder]
└─$ echo $SHELL
/usr/bin/zsh
```

## Step 2: Add the Function

We will use nano to append the code to the end of your configuration file.

1. Open the file (replace .zshrc with .bashrc if necessary):
```bash
nano ~/.zshrc
```

2. Scroll to the very bottom of the file.
3.  Paste the optimized script:

Bash

```
# Custom Nmap Port Extractor
function extractPorts(){
    if [ -z "$1" ]; then
        echo -e "\n[!] Usage: extractPorts <nmap_grepable_file>\n"
        return 1
    fi

    ports=$(grep -oP '\d{1,5}/open' "$1" | awk '{print $1}' FS='/' | xargs | tr ' ' ',')
    ip_address=$(grep -oP '\d{1,3}(\.\d{1,3}){3}' "$1" | sort -u | head -n 1)

    if [ ! -z "$ports" ]; then
        echo -e "\n[*] Extracting information..."
        echo -e "\t[*] IP Address: $ip_address"
        echo -e "\t[*] Open ports: $ports\n"

        echo -n "$ports" | xclip -sel clip
        echo -e "[*] Ports copied to clipboard!\n"
    else
        echo -e "\n[!] No open ports found in $1\n"
    fi
}
```

4. Press Ctrl + O, then Enter to save.

5. Press Ctrl + X to exit.

## Step 3: Refresh Your Terminal

For the changes to take effect immediately without restarting the terminal, "source" the file:

```bash
source ~/.zshrc  # or source ~/.bashrc
```

How it works now

The shell configuration files (.zshrc or .bashrc) act as a script that runs every time you open a new terminal window. By adding the function there, the extractPorts command becomes a native part of your environment.

Quick Tip: Make sure you have xclip installed (it usually is on Kali), otherwise the clipboard part will fail. You can grab it with sudo apt install xclip -y.