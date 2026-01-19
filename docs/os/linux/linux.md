
# Linux系统文档

```bash
# 获取系统IP
hostname -I | cut -f1 -d' '
# 关机
# sshpass -p root ssh -o "StrictHostKeyChecking=no" root@$(hostname -I | cut -f1 -d' ') "sudo poweroff"
sshpass -p root ssh -o StrictHostKeyChecking=no root@10.0.16.16 sudo poweroff
```

## yum命令

- 切换yum源

[参考](https://developer.aliyun.com/article/675241)

```bash
# 备份旧源
mv CentOS-Base.repo CentOS-Base.repo.v2.bak
# 添加新源(阿里镜像源)
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

```

## locale 配置

```bash
# -bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8): No such file or directory
# 中文乱码, 缺少中文字体
apt install ttf-wqy-microhei
# 安装 locale 相关工具
# sudo yum install glibc-langpack-en

```
