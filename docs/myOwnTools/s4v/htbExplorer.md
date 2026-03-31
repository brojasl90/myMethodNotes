## THIS IS NOT WORKING
It looks htb changes the API and auth 

token htb:
eyJ0eXAiOiJKV...

https://github.com/s4vitar/htbExplorer?tab=readme-ov-file

Quick Reference Guide

Since you have a lot of options, here is a "Cheat Sheet" for your most common tasks:

| **Goal**             | **Command**                            |
| -------------------- | -------------------------------------- |
| List Active Machines | htbExplorer -e active_machines         |
| Search by NameS      | htbExplorer -m "MachineName"           |
| Search by IP         | htbExplorer -i 10.10.10.121            |
| Download VPN File    | htbExplorer -v MyVPNName               |
| Submit a Flag        | htbExplorer -f "MachineName=FlagValue" |
| Reset a Machine      | htbExplorer -r "MachineName"           |

```
curl -s -L -X GET "https://www.hackthebox.com/api/v4/user/info" \
     -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiNmMyNDNkNWIyZjc5ZTdkMTY2ZTc5ZDc0NmMwZWIwZjliYWFkMWZlOTQyZTRkNjU2NGNlZjVlMWE2YmQ4Y2I2MjFkYzM2OTc2N2IwYzFkNmIiLCJpYXQiOjE3NzIxNzY3NjQuNzUyMzU5LCJuYmYiOjE3NzIxNzY3NjQuNzUyMzYxLCJleHAiOjE4MDM3MTI3NjQuNzM2NTIsInN1YiI6IjI0NTI4OSIsInNjb3BlcyI6W119.HtwNTlnyCwjIpvhP4iF2AKd5E3_C0lip2FkOc0ZlzcVtLtrtYJWgDA10N4zRtqAurHu8WKecGuDV_ZoHzgOqc_Lb5QAqsSt_nG9mgWYIoeBaAUmYqFfy8Em88RU3Q7Vgh8vC1tFVexJ3wfxuU1ADaf1KHzwtqa2Q7_vQF_vg47uvppCuNIeZROjTuvWaboswiIAuv8b2_1pGMnWHMw2iJgbCTr6jYw4arwUyfPd8hx57w2sHa4GgUszp14aGKT94XfbC6PtGfMXP5faCdKl_npN9hJ3RD_a20nvKjm-z8Kr5__FWjZJVGDkZZ0mmTF42rcWcSRCf778u36MXpWW1mbcJnSHku-wjQAVIYt5a_DNbJBgLAA4fVljh4qlhZ60C7YpssqFkTCli7GYh7t1qOGazWXvIU8vXstekdB_OXC_kDnFGEeA1K96I82ThGmW2tFTj1Gb6zMSNSDvvU5dJ1adzpxWOYvs-BvCYHLAW9zOYhqJspCWoJuS2PMrMsYzjjZX0uIoaP2RYDa4jQYKKsWjRj5lTUsTr8CkMJt7S4aqhLt12uKjkUssMERrNb4JwLE-eadf_C8eLio4eo_hvcz-TuDFUiFkCv5VsxvXSfzDvA7CHIoJUG9lDYYpnxlWB6i9HNZwdDTtoEIq7ZJhwcUcjUVOAKs3x76wZrnIB0Ks" \
     -H "User-Agent: Mozilla/5.0" \
     -H "Accept: application/json"
```


