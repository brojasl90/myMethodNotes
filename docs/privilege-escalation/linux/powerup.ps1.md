
https://powersploit.readthedocs.io/en/latest/

https://rootrecipe.medium.com/advanced-powerup-ps1-usage-ad0f6d713a9f

by typing in the following into a PowerShell console:

```
PS C:\> powershell -ep bypass
```

Running PowerUp.ps1

Now comes the fun part. We have disabled different protections so now we should be able to run our script with no problems. Before we can just run the program, we need to import the program into the current session. We do this by running one of the following commands:

```
PS C:\> Import-Module PowerUp.ps1PS C:\> . .\PowerUp.ps1
```

The one we are most interested in is `Invoke-AllChecks` because it runs all the checks included in the module. To run it, we simply run that command as shown below:

There is some interesting output here. PowerUp.ps1 will run all the required checks and spit out a lot of stuff. Let’s take a look at part of the output. If you notice the section that reads [*] Checking service permissions… We see a service that comes back as potentially vulnerable. Here’s a breakdown of some of the output.

- ServiceName: This is the name of the service
- Path: This is where the program is located or run from
- ModifiableFile: If we can abuse this service, this is the file that will be modified
- StartName: This is who the service runs as. It is important that this user has higher privileges than our current privileges, otherwise it will be pointless in exploiting it. Generally we would like if it is running with LocalSystem, or Administrator privileges.
- CanRestart: It is important this is True. We must have the ability to restart the service otherwise the changes can’t take place to escalate our privileges. If you have access to restart the machine that’s an option, but we generally want to avoid restarting machines if possible.
- AbuseFunction: If we type in this command as-is, PowerUp.ps1 will exploit the service automatically and add a user named john with a password of Password123! to the administrator’s group. (This can be changed of course but this is the default configuration.)

Now that we have taken a look at this service and determined we can restart it and it is running as Local Administrator privileges, let’s go ahead and run the AbuseFunction command that is given. In our example above this will be Install-ServiceAbuse -Name ‘AbyssWebServer’.


After we run the command, we will notice the output provides the command that PowerUp.ps1 executed. It looks like it added the user john with a password of Password123! then it added that user to the administrator’s group. Let’s confirm that this worked by typing in net user:

We notice the user john is now added to the computer. If we login as john we should have full administrative privileges on the computer.

## Customizing the Exploit

What if we don’t want to add a user john to the computer and instead want to do something else? PowerUp.ps1 provides us a way to customize the command to be run with LocalSystem privileges. Below are a few examples:

### Adding a new user with password with -User and -Password options
```
Invoke-ServiceAbuse -Name 'AbyssWebServer' -User hacker -Password Password1337
```

### Running a custom command (Disable Windows Defender)
```
Invoke-ServiceAbuse -Name 'GPGOrchestrator' -Command "reg add \"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\" /v fDenyTSConnections /t REG_DWORD /d 0 /f"
```

### Running a custom command (Enable RDP services)
```
Invoke-ServiceAbuse -Name 'GPGOrchestrator' -Command "Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0"
```