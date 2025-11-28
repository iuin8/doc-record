# yum related documentation

## yum source - using Aliyum source

- [参考阿里开发者社区文章](https://developer.aliyun.com/mirror/centos)

```shell
# centos8
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget-O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliun.com/repo/Centos-vault-8.5.2111.repo
yum clearan all && yum makeecache

```

## What's the EEEL, why you often have to install the ebel-release package

- EPAL (Extra Packages for Enterprise Linux) is a Fedora-based project
- [参考阿里云开发者社区文章](https://developer.aliyun.com/mirror/epel)

```shell
yum - y install etel-release
 
yum polist
```

```shell
yum clean all
 
yum makecache
```

## centos7 Install etel-release rpm

```shell
Download the latest epel-release rpm from
http://dl.fedoraproject.org/pub/epel/7/, download rpm file

Install etel-release rpm:
# rpm -Uvh etel-release*rpm 
```

## edora19 installation requires some required packages to install

```
# 安装rpmfusion源

# Fedora 19的源：
sudo yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-19.noarch.rpm  http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-19.noarch.rpm

# 安装一下有用的一些软件包

sudo yum -y install yum-fastestmirror unrar thunderbird emacs ibus-table \
redhat-lsb gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer-ffmpeg \
compat-libstdc++-33 NetworkManager-devel python-gevent tracker-ui-tools qemu \
libpciaccess-devel xorg-x11-util-macros llvm-devel mtdev* mutt msmtp tftp \
tftp-server policycoreutils-gui mtd-utils mtd-utils-ubi vim ibus-pinyin \
gnome-tweak-tool ckermit stardict stardict-dic-zh_CN stardict-dic-en \
ibus-table-chinese-wubi-haifeng gnash smplayer vlc samba pidgin pidgin-sipe \
meld expect glibc-static ncurses-static genromfs cmake ccache p7zip nmap \
gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-libav

# 升级一下系统：

sudo yum -y update

# 参考文章
https://www.cnblogs.com/lizhi0755/p/3308936.html
```

## Add rpmfusionsource to edora

```
# 有的rpmfusion地址有版本问题，找到一个比较好用的摘录一下：


# 从http://download1.rpmfusion.org/的free和nofree库中fedora目录下载稳定版rpmfusion-free-release-stable.noarch.rpm和rpmfusion-nonfree-release-stable.noarch.rpm， 或者直接在线安装：
rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
rpm -Uvh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm
# [stable]为版本号，无法安装的话，改成适合的版本号，例如35
```

## RPM Fusion

- Because of copyright problems, many software is not available in Fedora. If we want to install, we need to add or install libraries. RPM Fusion is the best, and two RPM Fusion offers：free and non-free.
- We can install the following orders

```
dnf install --nogcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-24.noarch.rpm
dnf install --nogcheck http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-free-release-release-release-24.noarch.rpm
```

## Install WINE

- wine is not a simulator, it is an open source software, which allows users to run Microsoft programs in non-Microsoft Windows. I can install： by using the following orders

```
dnf install wine
```
