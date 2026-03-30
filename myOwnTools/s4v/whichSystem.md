Detect OS via TTL range

we can inlcude this in /usr/bin/

```python
#!/usr/bin/python3
import re, sys, subprocess

# Usage: whichSystem 10.10.10.188

def get_ttl(ip_address):
    try:
        # Run ping and capture output
        proc = subprocess.Popen(["ping", "-c", "1", ip_address], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = proc.communicate()
        
        if proc.returncode != 0:
            return None

        # Search specifically for the 'ttl=NUMBER' pattern
        content = out.decode('utf-8')
        ttl_match = re.search(r"ttl=(\d+)", content)
        
        if ttl_match:
            return ttl_match.group(1)
        return None
    except Exception:
        return None

def get_os(ttl):
    ttl = int(ttl)
    if ttl >= 0 and ttl <= 64:
        return "Linux"
    elif ttl >= 65 and ttl <= 128:
        return "Windows"
    else:
        return "Unknown OS / Possible Firewall"

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f"\n[!] Usage: {sys.argv[0]} <ip-address>\n")
        sys.exit(1)

    ip = sys.argv[1]
    ttl = get_ttl(ip)

    if ttl:
        os_name = get_os(ttl)
        print(f"\n{ip} (ttl -> {ttl}): {os_name}\n")
    else:
        print(f"\n[!] Could not reach {ip} or extract TTL.\n")
```