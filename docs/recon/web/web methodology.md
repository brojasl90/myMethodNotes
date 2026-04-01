
Web Application fingerprinting
1) Meta files => Robots.txt and sitemap.xml, CHANGELOG, .git, README
2) Web app stack and technology =>  Wappalyzer (addon), builtwith (addon), whatweb
HTTP headers
CMS pentesting => Plugin, Users, themes
Cloning open source CMS from github
3) Source code => Loaded files + comments
4) Virtual Hosting
5) Dirbusting:
gobuster dir -u $url -w /usr/share/wordlists/dirb/common.txt -t 5 -b 301 --no-error -x html,txt -o dir80.txt -r -x .xml,.php,.txt

When this error happens
```
Error: the server returns a status code that matches the provided options for non existing urls. http://192.168.224.150:8080/161187fb-1dce-4504-8ee1-09ee4f46d329 => 404 (Length: 157). To continue please exclude the status code or the length
```
Use the exclude those codes, use the (-b) flag.
```
gobuster dir -u http://192.168.224.150:8080/ -w /usr/share/wordlists/dirb/common.txt -t 5 -b 404,403,301 --no-error -x html,txt -o dir80.txt -r -x .xml,.php,.txt
```

5) Vulnerability scanners => Nikto, Nuclei and etc
6) Web application functionality
7) Fuzzing and manual testing
Suggestive parameters

Manual approach: You could see the cookies or http request headers containng wordpress or wp keywords.
Automated approach: Using tools such as whatweb or wapalyzer would tell you.


