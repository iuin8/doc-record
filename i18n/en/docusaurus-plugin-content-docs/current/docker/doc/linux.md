# Linux command usage

## Linux Image

Installation of docker, one-click for software sources, etc.
[LinuxMirrors](https://github.com/SuperManito/LinuxMirrors)

## Install docker and configure accelator

```shell
yum - y install docker
```

## Change host name

```shell
hostnamectl set-hostname manager43
```

## Get ip addresses

```bash
$(hostname -I|cut-d" -f 1)
```

## Configuration hosts file (configured to not configured)

```shell
v/etc/hosts
```

```shell
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
:1 localhost localhost.localdomain localhost6 localhost6.localdomain6
 
192.168.31.43 manager43
192.168.31.188 node188
192.168.31 node139
```

## Copy to no with scp

```shell
scp /etc/hosts root@192.168.31.188:/etc/hosts
```

## View Firewall

```shell
`firewall-cmd --zone=public --list-ports` and `netstat -tlunp`
```

## Set firewall

```shell
systemctl disable firewall.service
systemctl stop firewalld.service
```

```shell
# Firewall configuration
# official document

# centos7 use fireall to configure firewall and default open interfaces. The scheme given in official documents is relatively botom. There we configure

# create file
vi /etc/firealld/services/docker.xmlml
# Add one of the following
<?xmlversion="1. " encoding="utf-8"?
      <service>
        <short>docker</short>
        <description>docker daemon for remote access</description>
        <port protocol="tcp" port="2375"/>
      </service>
# default zone
firewall-cmd --get-default-zone
# Add this service to zone
firewall-cmd --zone=public --add-service=docker -permanent
# Reload
firewall-cmd --reload
# Query Port
firewall-cmd -service=doc-get-get-ports --permanent
# Reference Link
http://my. schina.net/u/4560825/blog/4314288
```

## Add Dns

```shell
vi /etc/sysconfig/network-scripts/ifcfg-enp0s3
# DNS2=114.114.114
systemctl start network
vi /etc/resolv.conf # View results
```

## Configure yum mirror sources

```shell
# Backup your original image file so you can restore
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo. Backup
# Download new CentOS-Base.repo to /etc/yum.repos.d/
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliun.com/repo/Centos-7. epo
# Enter CentOS-Base.repo, modified the baseurl address in the file (omit this)
vi CentOS-Base. eto
# Clear existing yum cache
yum clean all
# Generate cache
yum makeache
# Check if configured yum repolist is normal
yum repolist
```

## Install docker

```shell
# Automatically install
# of installation orders following：

curl-fsSL https://get.docker. om | bash -s docker --mirror Aliyun
# You can also install command：

curl -sSL https://get.daocloud.io/docker | sh
```

```shell
# 安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的
yum install -y yum-utils device-mapper-persistent-data lvm2
# 配置镜像源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 通过命令把https://download-stage.docker.com替换为http://mirrors.aliyun.com/docker-ce
vi /etc/yum.repos.d/docker-ce.repo
# 命令如下：
:%s#https://download.docker.com#http://mirrors.aliyun.com/docker-ce#g
# 更新yum缓存
yum makecache fast
# 这时，可通过阿里镜像安装doker了
yum install docker-ce
```

## Monitor command

```shell
# 查看服务状态，一秒一次，启动之后可通过IP：端口访问界面
watch -n 1 docker stack services hadoop
```

## Print Information

```shell
# Do not print normal messages, print error messages (/dev/null for empty devices)
xargs docker rmi > /dev/null
# Normal and error messages don't print
xargs docker rmi &> dev/null
```

## Exclude files or folders when printing files or folders list

```shell
# Multiple files or folders
girls | grep -v 'a\|b'
```

## nodejs Installation

```shell
# curl -o - https://raw.githubusercontent.com/nvm/v0.39.0/install.sh | bash
# nvm install 14.16.
# npm install -g nrm
# nrm girlls
# nrm use taobao
# npm config girls
# rm -rf. node_modules
# npm install
# npm run build:test

```

## Docker access question

```shell
sudo groupadd docker          #添加docker用户组
sudo gpasswd -a $USER docker  #将当前用户添加至docker用户组
newgrp docker                 #更新docker用户组

```

## View port usage

```shell
# View 53 port usage
sudo netstat -anlp | grep -w LISTEN | grep 53
```

## Define Environment Variables

```shell
export DOCKER_HOST=tcp://localhost:2375
```

## crontab usage

```shell
# Form
minute four day month week command
# Add task
crontab -e
# View tasklist
crontab -l
# Delete task
crontab -r
# View executed task
tail -f /var/log/cron
```

## Set network time

```shell
# 查看当前时间
date "+%Y-%m-%d %H:%M:%S"
# 查看时区
date "+%Z"
# 使用cat /etc/sysconfig/clock查看当前时区
cat /etc/sysconfig/clock
# 设置时区
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 查看硬件时间
hwclock
# 同步硬件时间
hwclock -w
# 同步系统时间
clock -w

# ntpdate
# 即使是硬件时间也会和网络时间有差异，想要和网络时间完全一致，我们就需要获取网络时间更新本地时间。
# 安装工具： 
yum -y install ntp ntpdate
# 设置系统时间与网络时间同步：
ntpdate cn.pool.ntp.org
# 将系统时间写入硬件时间：
hwclock –systohc

# 同步时间服务器
ntpdate -u ntp.api.bz
# ntp常用服务器：
# 中国国家授时中心：210.72.145.44
# NTP服务器(上海) ：ntp.api.bz
# 美国： time.nist.gov
# 复旦： ntp.fudan.edu.cn
# 微软公司授时主机(美国) ：time.windows.com
# 北京邮电大学 : s1a.time.edu.cn
# 清华大学 : s1b.time.edu.cn
# 北京大学 : s1c.time.edu.cn
# 台警大授时中心(台湾)：asia.pool.ntp.org

# simple
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate -u ntp.api.bz
hwclock -w
```

## View linux system version

```shell
# Only for redhat is linux system
cat /etc/redhat-release
# Mode 2
rpm -q centos-release
```

## Linux file string placement commands

```shell
# perl命令替换
# -e 执行指定的脚本。
# -i 原地替换文件，并将旧文件用指定的扩展名备份。不指定扩展名则不备份。
# -n 自动循环，相当于 while(<>) { 脚本; }
# -p 自动循环+自动输出，相当于 while(<>) { 脚本; print; }

# 用法示例：
# 将所有C程序中的foo替换成bar，旧文件备份成.bak
perl -p -i.bak -e 's/\bfoo\b/bar/g' *.c
# 将当前文件夹下lishan.txt和lishan.txt.bak中的“shan”都替换为“hua”
perl -p -i -e "s/shan/hua/g" ./lishan.txt ./lishan.txt.bak

# ##################################################################

# sed命令替换
# -i 表示inplace edit，就地修改文件

# s表示替换，d表示删除
# 格式: sed -i "s/查找字段/替换字段/g" `grep 查找字段 -rl 路径` 文件名

# 示例：
# 把当前目录下lishan.txt里的shan都替换为hua
sed -i "s/shan/hua/g" lishan.txt
# 使用变量替换(使用双引号)
sed -e "s/$var1/$var2/g" filename
# 删除文本中空行和空格组成的行以及#号注释的行
grep -v ^# filename | sed /^[[:space:]]*$/d | sed /^$/d

```

## Copy command

- [参考文章](https://blog.csdn.net/qq_40880022/article/details/118937461)

```shell
# Copy directory -- Copy all content from [/temp/java/BOOT-INF/lib] to the [/temp/java/lib] directory in
cp -a /temp/java/BOOT-INF/lib /www/temp/java/lib
```

## Topcommand used

```shell
# Use `1` to show the use of each CPU
# to show the percentage progress bar
# using `t` to display the percentage of memory bar
```

## Time Related

- Related Articles
  - [[centos使用date命令同步网络时间]]
  - [[timedatectl命令怎么同步网络时间]]
  - [[timedatectl命令怎么同步网络时间]]

```shell
# View time
timatl
date
# Modification time
date -s "2024-01-19"
date -s "10:30:00"
timeattel set-time "YYY-MM-DD H:MM:S"

# Enable auto-sync time
timatl set-ntp true
# Manual sync net time
date -s (curl -s -head http:// www.. aidu.com | grep '^Date:' | cut-d' -f3-6) Z"

```

## View domain matching IP

```bash
ping -c 1 example.com
```
