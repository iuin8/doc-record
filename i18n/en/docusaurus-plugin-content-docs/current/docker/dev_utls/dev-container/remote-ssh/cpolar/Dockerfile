# Use the official CentS base image (PPS: latest-pack openssh-server dependencies
# FROM centos: centos7.9.2009
FROM registry.cn-hangzhou.aliyuncs.com/iuin/centos:latest

# ENV https_proxy=http://192.168.0.121:7890 http_proxy=http://192.168.0.121:7890all_proxy=socks5://192.168.0.121:789090

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo &&\s
    sed--i s/^.*baseurl=http://baseurl=http://etc/yum.repos.d/*.repo &&\s
    sed--i s/^mirrorlist=http://#mirrorlist=http://g /etc/yum.repos.d/*.repo &&\s
    yum install - y wget && \s
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliun.com/repo/Centos-7.repo

# Install Required Packages
RUN yum Update -y & yum install -y openssh-server openssh-customers passwd && yum clean all

# Set root password
RUN echo "root:password" | chpasswd

# Change SSH profile to allow password login and root
RUN sed-i 's/#PermitRootLogin Prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config &\\s
    identified -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

RUN /usr/sbin/sshd-keygen

RUN curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | bash

COPY cpolar.yml /usr/local/etc/cpolar/cpolar.yml

# After opening the service, /usr/sbin/init commands will help start the service automatically
RUN systemctl enabling cpolar.service

# Exposure SSH ports
EXPOSE 22
# Start ssh and cpolar services
ENTRYPOINT [ "/usr/sbin/init" ]
