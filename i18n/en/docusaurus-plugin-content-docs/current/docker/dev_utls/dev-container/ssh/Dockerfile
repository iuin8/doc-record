# Use the official CentS base image (PPS: -pack openssh-server dependencies
# FROM centos: centos7.9.2009
FROM registry.cn-hangzhou.aliyuncs.com/iuin/centos:latest

# ENV https_proxy=http://192.168.0.121:7890 http_proxy=http://192.168.0.121:7890all_proxy=socks5://192.168.0.121:789090

# Update Mirror
# RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo &\s
# sed-i s/^.*baseurl=http://baseurl=http://etc/yum.repos.d/*.repo &\s
# sed-i s/^mirrorlist=http://#mirrorlist=http:///g /etc/yum.repos.d/*.repo &\s
# yum install -y wget && \s
# cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak &\s
# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliun.com/repo/Centos-7.repo &&\s
# yum-config-manager --save --seopt=base.skip_if_unviable=true &`
# yum-config-manager --save --set=extras.skip_if_unviable=true &\s
# yum-config-manager --save --setopt=updates.skip_if_unviable=true &&\s
# yum makecache

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo &\s
    sed-i s/^.baseurl=http://baseurl=http://etc/yum.repos.d/*.repo &&\s
    sed--i s/^mirrorlist=http://#mirrorlist=http:///g /etc/yum.repos.d/*.repo &\s
    yum install - y wget && \s
    cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak &\s
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliun.com/repo/Centos-7.repo

# Installing Packages
RUN yum Update -y & yum install -y openssh-server openssh-customers passwd && yum clearan all

# Set root password
RUN echo "root:password" | chpasswd

# Change SSH profile to allow password login and root
RUN sed-i 's/#PermitRootLogin Prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config &\s
    Identified -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

RUN /usr/sbin/sshd-keygen
# Exposure SSH ports
EXPOSE 22
# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
