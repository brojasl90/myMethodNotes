
wpscan --enumerate ap,u,t 
```
ap   All plugins
u    User IDs range. e.g: u1-5
                                                        Range separator to use: '-'
                                                        Value if no argument supplied: 1-10
t    Popular themes
```
wpscan --enumerate vp
```
vp   Vulnerable plugins
```

```
 hydden@hydden  ~  wpscan --url http://alvida-eatery.org/ --enumerate p
_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.25
                               
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[i] Updating the Database ...
[i] Update completed.

[+] URL: http://alvida-eatery.org/ [192.168.161.47]
[+] Started: Tue May 14 01:14:18 2024

Interesting Finding(s):

[+] Headers
 | Interesting Entries:
 |  - Server: Apache/2.4.52 (Ubuntu)
 |  - X-UA-Compatible: IE=edge
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://alvida-eatery.org/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

[+] WordPress readme found: http://alvida-eatery.org/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] Upload directory has listing enabled: http://alvida-eatery.org/wp-content/uploads/
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://alvida-eatery.org/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 6.0 identified (Insecure, released on 2022-05-24).
 | Found By: Rss Generator (Passive Detection)
 |  - http://alvida-eatery.org/?feed=rss2, <generator>https://wordpress.org/?v=6.0</generator>
 |  - http://alvida-eatery.org/?feed=comments-rss2, <generator>https://wordpress.org/?v=6.0</generator>

[+] WordPress theme in use: oceanwp
 | Location: http://alvida-eatery.org/wp-content/themes/oceanwp/
 | Last Updated: 2024-03-27T00:00:00.000Z
 | Readme: http://alvida-eatery.org/wp-content/themes/oceanwp/readme.txt
 | [!] The version is out of date, the latest version is 3.5.5
 | Style URL: http://alvida-eatery.org/wp-content/themes/oceanwp/style.css
 | Style Name: OceanWP
 | Style URI: https://oceanwp.org/
 | Description: OceanWP is the perfect theme for your project. Lightweight and highly extendable, it will enable you...
 | Author: OceanWP
 | Author URI: https://oceanwp.org/about-oceanwp/
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 3.3.2 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://alvida-eatery.org/wp-content/themes/oceanwp/style.css, Match: 'Version:            3.3.2'

[+] Enumerating Most Popular Plugins (via Passive Methods)
[+] Checking Plugin Versions (via Passive and Aggressive Methods)

[i] Plugin(s) Identified:

[+] elementor
 | Location: http://alvida-eatery.org/wp-content/plugins/elementor/
 | Last Updated: 2024-05-08T09:52:00.000Z
 | [!] The version is out of date, the latest version is 3.21.5
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 3.6.5 (100% confidence)
 | Found By: Query Parameter (Passive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/elementor/assets/js/frontend.min.js?ver=3.6.5
 | Confirmed By:
 |  Readme - Stable Tag (Aggressive Detection)
 |   - http://alvida-eatery.org/wp-content/plugins/elementor/readme.txt
 |  Readme - ChangeLog Section (Aggressive Detection)
 |   - http://alvida-eatery.org/wp-content/plugins/elementor/readme.txt

[+] ocean-extra
 | Location: http://alvida-eatery.org/wp-content/plugins/ocean-extra/
 | Last Updated: 2024-04-08T07:56:00.000Z
 | [!] The version is out of date, the latest version is 2.2.7
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 2.0.1 (80% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/ocean-extra/readme.txt

[+] ocean-social-sharing
 | Location: http://alvida-eatery.org/wp-content/plugins/ocean-social-sharing/
 | Last Updated: 2023-12-11T11:05:00.000Z
 | [!] The version is out of date, the latest version is 2.0.6
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 2.0.2 (100% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/ocean-social-sharing/readme.txt
 | Confirmed By: Readme - ChangeLog Section (Aggressive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/ocean-social-sharing/readme.txt

[+] ocean-stick-anything
 | Location: http://alvida-eatery.org/wp-content/plugins/ocean-stick-anything/
 | Last Updated: 2023-09-06T08:51:00.000Z
 | [!] The version is out of date, the latest version is 2.0.7
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 2.0.4 (80% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/ocean-stick-anything/readme.txt

[+] perfect-survey
 | Location: http://alvida-eatery.org/wp-content/plugins/perfect-survey/
 | Latest Version: 1.5.1 (up to date)
 | Last Updated: 2021-06-11T12:09:00.000Z
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 1.5.1 (100% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/perfect-survey/readme.txt
 | Confirmed By: Readme - ChangeLog Section (Aggressive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/perfect-survey/readme.txt

[+] wpforms-lite
 | Location: http://alvida-eatery.org/wp-content/plugins/wpforms-lite/
 | Last Updated: 2024-04-26T09:06:00.000Z
 | [!] The version is out of date, the latest version is 1.8.8.3
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 1.7.4.2 (100% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/wpforms-lite/readme.txt
 | Confirmed By: Readme - ChangeLog Section (Aggressive Detection)
 |  - http://alvida-eatery.org/wp-content/plugins/wpforms-lite/readme.txt

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

[+] Finished: Tue May 14 01:14:31 2024
[+] Requests Done: 58
[+] Cached Requests: 5
[+] Data Sent: 15.562 KB
[+] Data Received: 21.609 MB
[+] Memory used: 273.773 MB
[+] Elapsed time: 00:00:12
```


WPScan of the WordPress web page
```
kali@kali:~/beyond$ wpscan --url http://192.168.50.244 --enumerate p --plugins-detection aggressive -o websrv1/wpscan

kali@kali:~/beyond$ cat websrv1/wpscan
...

[i] Plugin(s) Identified:

[+] akismet
 | Location: http://192.168.50.244/wp-content/plugins/akismet/
 | Latest Version: 5.0
 | Last Updated: 2022-07-26T16:13:00.000Z
 |
 | Found By: Known Locations (Aggressive Detection)
 |  - http://192.168.50.244/wp-content/plugins/akismet/, status: 500
 |
 | The version could not be determined.

[+] classic-editor
 | Location: http://192.168.50.244/wp-content/plugins/classic-editor/
 | Latest Version: 1.6.2 
 | Last Updated: 2021-07-21T22:08:00.000Z
...

[+] contact-form-7
 | Location: http://192.168.50.244/wp-content/plugins/contact-form-7/
 | Latest Version: 5.6.3 (up to date)
 | Last Updated: 2022-09-01T08:48:00.000Z
...

[+] duplicator
 | Location: http://192.168.50.244/wp-content/plugins/duplicator/
 | Last Updated: 2022-09-24T17:57:00.000Z
 | Readme: http://192.168.50.244/wp-content/plugins/duplicator/readme.txt
 | [!] The version is out of date, the latest version is 1.5.1
 |
 | Found By: Known Locations (Aggressive Detection)
 |  - http://192.168.50.244/wp-content/plugins/duplicator/, status: 403
 |
 | Version: 1.3.26 (80% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://192.168.50.244/wp-content/plugins/duplicator/readme.txt

[+] elementor
 | Location: http://192.168.50.244/wp-content/plugins/elementor/
 | Latest Version: 3.7.7 (up to date)
 | Last Updated: 2022-09-20T14:51:00.000Z
...

[+] wordpress-seo
 | Location: http://192.168.50.244/wp-content/plugins/wordpress-seo/
 | Latest Version: 19.7.1 (up to date)
 | Last Updated: 2022-09-20T14:10:00.000Z
...
```



