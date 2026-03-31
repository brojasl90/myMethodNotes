
https://www.airdroid.com/quick-guides/powershell-enable-rdp/
## Enable RDP. 

```
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
```

```
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```

Testing
```
xfreerdp /cert-ignore /compression /auto-reconnect /u:dave /p:Password123 /v:192.168.156.141 /w:1600 /h:800
```

## Verify NLT

https://lazywinadmin.com/2014/04/powershell-getset-network-level.html
NLA config

```
$ComputerName = hostname
```

```
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -ComputerName $ComputerName -Filter "TerminalName='RDP-tcp'").UserAuthenticationRequired
```

Enable/disable
```
# Setting the NLA information to Disabled
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -ComputerName $ComputerName -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)

# Setting the NLA information to Enabled
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -ComputerName $ComputerName -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(1
```