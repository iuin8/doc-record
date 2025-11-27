# Linux system documentation

```bash
# 获取系统IP
hostname -I | cut -f1 -d' '
# 关机
# sshpass -p root ssh -o "StrictHostKeyChecking=no" root@$(hostname -I | cut -f1 -d' ') "sudo poweroff"
sshpass -p root ssh -o StrictHostKeyChecking=no root@10.0.16.16 sudo poweroff
```

## yum command

- Toggle youm source

[参考](https://developer.aliyun.com/article/675241)

```bash
# The old source
mv CentOS-Base.repo CentOS-Base.repo.v2.bak
# Add new source (Ai mirror source)
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliun.com/repo/Centos-7.repo

```
