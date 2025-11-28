# git related age

## git Upgrade

- [相关链接](https://packages.endpointdev.com/)
- [相关链接](https://www.endpointdev.com/blog/2021/12/installing-git-2-on-centos-7/#:~:text=lks%20you%20step%20b)

```bash
# Check git version
git --version
# git version 1.8.3.

# View git installation position
which git
# /usr/bin/git

# Ensure it is installed with yum from RPM
rpm -qi git
# # Name : git
# Version: 1. 3.3.1
# Release : 23. l7_8
# Source RPM : git-1.8.3.1-23.el7_8.src. pm
# Build Date : Thu 28 May 2020 08:37:56 PM UTC
# Build Post : x86-02.bsys.centos. rg
# Packager: CentOS BuildSystem <http://bugs.centos.org>
# Vendor: CentOS

# Add End Point Yum repository
sudo yum install -y https://packages. ndpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64. pm

# Installing or upgrading it
sudo yum install - y git

# If you don't see new git versions available, You may need to clear Yum cache：
sudo yum clean all


## Question
# If uninstalled unsuccessfully, uninstalling git (and propely not you'd install, needs to be uninstalled otherwise)
sudo yum remove git
sudo yum remove git-*

```
