# Use the official CentS base image (PPS: -pack openssh-server dependencies
# FROM centos: centos7.9.2009
FROM registry.cn-hangzhou.aliyuncs.com/iuin/centos:latest

# ENV https_proxy=http://192.168.0.121:7890 http_proxy=http://192.168.0.121:7890all_proxy=socks5://192.168.0.121:789090

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo &\s
    sed-i s/^.baseurl=http://baseurl=http://etc/yum.repos.d/*.repo &&\s
    sed--i s/^mirrorlist=http://#mirrorlist=http:///g /etc/yum.repos.d/*.repo &\s
    yum install - y wget && \s
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliun.com/repo/Centos-7.repo

# Installing Packages
RUN yum Update -y & yum install -y openssh-server openssh-customers passwd && yum clearan all

# Set root password, change SSH configuration to allow password login and root
RUN echo "root:password" | chpasswd &\s
    sed-i 's/#PermitRootLogin Prohibit-password/PermitRoot Login yes/g' /etc/ssh/sshd_config &&&&\s
    sed-i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config &&&&\s
    /usr/sbin/sshd-keygen

RUN curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | bash

COPY cpolar.yml /usr/local/etc/cpolar/cpolar.yml

# After opening the service, /usr/sbin/init orders will help start the service automatically
RUN systemctl enabling cpolar.service


# Create Startup Script
RUN tee /usr/local/bin/start-cpolar.sh <-'EOF'
#!/bin/bash
cpolar authtoken ${CPOLAR_AUTH_TOKEN}
EOF

RUN chmod +x /usr/local/bin/start-cpolar.sh

# Create Packing Service
RUN tee/etc/systemd/system/cpolar-wrapper.service <-'EOF'
[Unit]
Description=Cpolar Wrapper Service
# After=network.target
After=cpolar.service

[Service]
Type=Simple
ExecStart=/usr/local/bin/start-cpolar.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable wrapping services
RUN systemctl enable cpolar-wrapper.service


# Exposure SSH ports
EXPOSE 22
# Start ssh and polar services
# ENTRYPOINT [ "/usr/sbin/init" ]


# Create initiative script
RUN tee /usr/local/bin/init-container.sh <-'EOF'
#!/bin/bash
# Replace environment variable values
sed -i "s/\${CPOLAR_AUTH_TOKEN}/$CPOLAR_AUTH_TOKEN/g" /usr/local/bin/start-cpolar.sh
sed -i "s/\${CPOLAR_CONTANER_SSH_NAME}/${CPOLAR_CONTANER_SSH_NAME:-contaner_ssh}/g" /usr/local/etc/cpolar/cpolar.yml
# Start Init
exec /usr/sbin/init
EOF

RUN chmod +x /usr/local/bin/init-container.sh

# Use initialized scripts as entry point
ENTRYPOINT ["/usr/local/bin/init-container.sh"]
