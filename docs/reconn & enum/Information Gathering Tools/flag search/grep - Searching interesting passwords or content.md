Now that we have all these files I can try out a useful grep command given to me by [Krishna Tiwadi](https://medium.com/@krishnatiwadi/i-have-a-one-liner-grep-rine-ad111d8a7ff9). This will expose any embedded credentials in a large amounts of files.

```
grep -rinE '(password|username|user|pass|key|token|secret|admin|login|credentials)'
```

