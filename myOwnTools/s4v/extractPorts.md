Parse nmap grepable output → clipboard

```bash
# Used: 
# nmap -p- --open -T5 -v -n ip -oG allPorts

# Extract nmap information
# Run as: 
# extractPorts allPorts
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}
```

Improve by AI
```shell
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
