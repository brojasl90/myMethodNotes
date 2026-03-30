
[[25.  Assembling the Pieces]]

## git dumper
https://github.com/arthaud/git-dumper

https://notes.benheater.com/books/web/page/git-dumper

```
┌──(kali㉿kali)-[/opt]
└─$ pipx install git-dumper
  installed package git-dumper 1.0.8, installed using Python 3.13.2
  These apps are now globally available
    - git-dumper
done! ✨ 🌟 ✨
```



## git status

Display the state of the Git working directory
```git
git status
```

Show the commit history
```git
git log
```

Example
```
root@websrv1:/srv/www/wordpress# git status
HEAD detached at 612ff57
nothing to commit, working tree clean

root@websrv1:/srv/www/wordpress# git log
commit 612ff5783cc5dbd1e0e008523dba83374a84aaf1 (HEAD -> master)
Author: root <root@websrv1>
Date:   Tue Sep 27 14:26:15 2022 +0000

    Removed staging script and internal network access

commit f82147bb0877fa6b5d8e80cf33da7b8f757d11dd
Author: root <root@websrv1>
Date:   Tue Sep 27 14:24:28 2022 +0000

    initial commit
```

Examining Git repo
```
# git show 612ff5783cc5dbd1e0e008523dba83374a84aaf1
commit 612ff5783cc5dbd1e0e008523dba83374a84aaf1 (HEAD, master)
Author: root <root@websrv1>
Date:   Tue Sep 27 14:26:15 2022 +0000

    Removed staging script and internal network access

diff --git a/fetch_current.sh b/fetch_current.sh
deleted file mode 100644
index 25667c7..0000000
--- a/fetch_current.sh
+++ /dev/null
@@ -1,6 +0,0 @@
-#!/bin/bash
-
-# Script to obtain the current state of the web app from the staging server
-
-sshpass -p "dqsTwTpZPn#nL" rsync john@192.168.50.245:/current_webapp/ /srv/www/wordpress/
-
```

We avoid to use git checkout.
We could switch back to a specific commit by using git checkout and a commit hash.
We use git show, shows differences between commits.

```
git show 612ff5783cc5dbd1e0e008523dba83374a84aaf1
```

Example
```
root@websrv1:/srv/www/wordpress# git show 612ff5783cc5dbd1e0e008523dba83374a84aaf1
commit 612ff5783cc5dbd1e0e008523dba83374a84aaf1 (HEAD, master)
Author: root <root@websrv1>
Date:   Tue Sep 27 14:26:15 2022 +0000

    Removed staging script and internal network access

diff --git a/fetch_current.sh b/fetch_current.sh
deleted file mode 100644
index 25667c7..0000000
--- a/fetch_current.sh
+++ /dev/null
@@ -1,6 +0,0 @@
-#!/bin/bash
-
-# Script to obtain the current state of the web app from the staging server
-
-sshpass -p "dqsTwTpZPn#nL" rsync john@192.168.50.245:/current_webapp/ /srv/www/wordpress/
-
```



# When copying a folder to my local machine


https://medium.com/stolabs/git-exposed-how-to-identify-and-exploit-62df3c165c37

wget : Is a free linux-native program that downloads data from the web.

mirror : Makes it download everything from git, recursive download.

-I : Creates a file with everything that was downloaded.

```
wget --mirror -I .git http://192.168.216.144/.git/
```

## Initiate the git project that was copied
- git init
- git remote -v
- git status
- git restore .
- git log 
https://es.stackoverflow.com/questions/385871/fatal-not-a-git-repository-or-any-of-the-parent-directories-git

```
┌──(kali㉿kali)-[~/OSCP-A/Crystal-144/.git]
└─$ git status   
fatal: not a git repository (or any of the parent directories): .git
                                                                                                                   
┌──(kali㉿kali)-[~/OSCP-A/Crystal-144/.git]
└─$ git init
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint: 
hint:   git config --global init.defaultBranch <name>
hint: 
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint: 
hint:   git branch -m <name>
Initialized empty Git repository in /home/kali/OSCP-A/Crystal-144/.git/.git/
                                                                                                                   
┌──(kali㉿kali)-[~/OSCP-A/Crystal-144/.git]
└─$ git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        COMMIT_EDITMSG
        HEAD
        README.md
        logs/

nothing added to commit but untracked files present (use "git add" to track)
```


Testing the other that I download 
```
┌──(kali㉿kali)-[~/OSCP-A/Crystal-144/192.168.216.144]
└─$ git remote -v
origin  https://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@github.com/PWK-Challenge-Lab/dev.git (fetch)
origin  https://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@github.com/PWK-Challenge-Lab/dev.git (push)
```

```
┌──(kali㉿kali)-[~/OSCP-A/Crystal-144/192.168.216.144]
└─$ git status                                       
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        deleted:    README.md
        deleted:    api/export.php
        deleted:    api/index.php
        deleted:    api/order.php
        deleted:    configuration/database.php
        deleted:    orders/search.php
        deleted:    robots.txt

no changes added to commit (use "git add" and/or "git commit -a")
                                                                                                                   
┌──(kali㉿kali)-[~/OSCP-A/Crystal-144/192.168.216.144]
└─$ git restore .
                                                                                                                   
┌──(kali㉿kali)-[~/OSCP-A/Crystal-144/192.168.216.144]
└─$ ls -lh 
total 20K
drwxrwxr-x 2 kali kali 4.0K Sep 28 13:51 api
drwxrwxr-x 2 kali kali 4.0K Sep 28 13:51 configuration
drwxrwxr-x 2 kali kali 4.0K Sep 28 13:51 orders
-rw-rw-r-- 1 kali kali   25 Sep 28 13:51 README.md
-rw-rw-r-- 1 kali kali   22 Sep 28 13:51 robots.txt
```