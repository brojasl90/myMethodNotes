## Customizing the Kali Linux with Hyperland

https://www.youtube.com/watch?v=NtpRtSBjz3I&t=338s

https://github.com/JaKooLit/Debian-Hyprland/

The shell was modified from bash to zsh

Other zsh themes available: 
https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

## How to change the shell
Validate current shell:
`which $SHELL`
Change from bash to zsh
`chsh -s $(which zsh)`
Restart
Change from zsh to bash
`chsh -s $(which bash)`
Restart
## Modified zsh to add a $PATH variable
https://www.geeksforgeeks.org/add-a-directory-to-path-in-zsh/
`nano ~/.zshrc`
Adding at the end of line
`export PATH=$PATH:/path/to/your/directory`
Save and exit
Applying change immediately run: 
`source ~/.zshrc`


WARNING: The script flask-unsign is installed in '/home/hydden/.local/bin' which is not on PATH.                                                          
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location. 

