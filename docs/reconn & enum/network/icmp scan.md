
```
for i in {0..255}; do for j in {1..254}; do (ping -c 1 172.16.$i.$j | grep "bytes from" &) done; done; wait
```