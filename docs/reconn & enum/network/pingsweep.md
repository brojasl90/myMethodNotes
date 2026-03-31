2 Nets: 172.16.x.x
```
for i in {0..255}; do for j in {1..254}; do (ping -c 1 172.16.$i.$j | grep "bytes from" &) done; done; wait
```

1 Net: 172.16.1.X
```
for ip in {0..255}; do 
ping -c 1 172.16.1.$ip | grep "bytes from" &) done; done; wait
```

Cloude
```
#!/bin/bash

# Pingsweep - Discover live hosts on a /24 subnet
# Usage: ./pingsweep.sh <first three octets>
# Example: ./pingsweep.sh 172.16.1

if [ "$1" == "" ]
then
    echo "==============================="
    echo "  Pingsweep - Host Discovery"
    echo "==============================="
    echo "Usage:   ./pingsweep.sh <subnet>"
    echo "Example: ./pingsweep.sh 172.16.1"
    echo ""
    echo "Output will be saved to: livehosts.txt"
else
    OUTPUT="livehosts.txt"
    > "$OUTPUT"  # Clear output file

    echo "[*] Scanning $1.1 - $1.254 ..."
    echo "[*] Live hosts will be saved to $OUTPUT"
    echo ""

    for ip in $(seq 1 254); do
        ping -c 1 -W 1 $1.$ip &> /dev/null && echo "[+] Host up: $1.$ip" | tee -a "$OUTPUT" &
    done

    wait  # Wait for all background jobs to finish

    echo ""
    echo "[*] Scan complete."
    echo "[*] $(wc -l < $OUTPUT) host(s) found. Results saved to $OUTPUT"
fi
```