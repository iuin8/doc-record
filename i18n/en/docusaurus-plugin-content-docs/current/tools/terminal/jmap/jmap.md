# Use of jmap

- Mode 1

How to export [java hprof file](https://github.com/183461750/doc-record/blob/9ebb07355231f4ae916fdfec741c7e0d044c35ab/materiel/ai/java/java%E4%B8%ADhprof%E6%96%87%E4%BB%B6%E5%A6%82%E4%BD%95%E5%AF%BC%E5%87%BA.md)

```shell
# pid
ps -ef | grep xxxxl-job-admin

# [root-101-94 data]# jmap -dump:form=b,file=/data/templ/xl-job-admin. prof 24663
# 24663: Enable to open socket file: target process not responding or HotSpot VM not loaded
# The -F option can be used when the target process is not responding to

# Example (PS: if committed delivery provided by AI fails, Add-F parameter)
jmap -F -dump:format@@=b,file=/data/temp/xxl-job-admin. prof 24663
```

- Mode 2

Add parameters when the jar package starts

[参考文章](https://mp.weixin.qq.com/s/3xCxRxfrz_Y41z7PO-d82g)

```bash

-Xms128M -Xmx128M -XX: +HeapDumpOnOutOfMemoryErrr-XX:HeapDumPath=... xfg-dev-tech-dump/docs/dump

# HeapDumpPath completes the path for your project to reach the dump folder.
# Run method will see the resulting log in docs/dump.
```
