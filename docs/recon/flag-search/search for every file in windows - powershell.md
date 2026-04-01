
```
Get-ChildItem -Path C:\Users\ -Include *.* -File -Recurse -ErrorAction SilentlyContinue
```

```
Get-ChildItem -Path C:\Users\ -Hidden -Include *.* -File -Recurse -ErrorAction SilentlyContinue
```

Include hidden folders using **-Hidden**

https://www.tutorialspoint.com/how-to-get-hidden-files-and-folders-using-powershell

To get hidden files and folders using PowerShell, we need to use the Get-ChildItem command with the - Hidden or -Force parameter.

```
Get-ChildItem -Path C:\Users\ -Hidden -Include *.* -File -Recurse -ErrorAction SilentlyContinue
```

Searching for PDFs
```
Get-ChildItem -Path C:\Users\ -Include *.pdf* -File -Recurse -ErrorAction SilentlyContinue
```

Searching for PDFs including hidden folders
```
Get-ChildItem -Path C:\Users\ -Hidden -Include *.pdf* -File -Recurse -ErrorAction SilentlyContinue
```

Searching for Git files including hidden folders

```
Get-ChildItem -Path C:\staging -Hidden -Recurse -ErrorAction SilentlyContinue -Include *.git*
```
