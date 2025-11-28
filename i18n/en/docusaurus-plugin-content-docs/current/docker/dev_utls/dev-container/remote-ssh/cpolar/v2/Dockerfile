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

# Set root password, change SSH configuration to allow password login and root
RUN echo "root:password" | chpasswd &\s
    sed-i 's/#PermitRootLogin Prohibit-password/PermitRoot Login yes/g' /etc/ssh/sshd_config &&&\s
    sed-i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config &&&\s
    /usr/sbin/sshd-keygen

RUN curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | bash

COPY cpolar.yml /usr/local/etc/cpolar/cpolar.yml

# After opening the service, /usr/sbin/init commands will help start the service automatically
RUN systemctl enabling cpolar.service


# Create Startup Script
RUN tee /usr/local/bin/start-cpolar.sh <-'EOF'
#!/bin/bash

# Checks if environment variable exists
if [ -z "$CPOLAR_AUTH_TOKEN" ]; then
    echo "Error: CPOLAR_AUTH_TOKEN is not set"
    exit 1
Li

# Checks if config file exists
if [ ! -f "/usr/local/etc/cpolar/cpolar.yml" ]; then
    echo "Error: cpolar.yml not found"
    exit 1
Li

# sed -i "s/\${CPOLAR_AUTH_TOKEN}/$CPOLAR_AUTH_TOKEN/g" /usr/local/etc/cpolar/cpolar.yml
cpolar authtoken ${CPOLAR_AUTH_TOKEN}
EOF

RUN chmod +x /usr/local/bin/start-cpolar.sh

# Create Environment Variable File
RUN tee/etc/cpolar.env <-'EOF'
CPOLAR_AUTH_TOKEN=${CPOLAR_AUTH_TOKEN}
EOF

# Create packing service
RUN tee/etc/systemd/system/cpolar-wrapper.service <-'EOF'
[Unit]
Description=Cpolar Wrapper Service
# After=network.target
After=cpolar.service

[Service]
Type=Simple
# Environment=CPOLAR_AUTH_TOKEN=${CPOLAR_AUTH_TOKEN}
EnvironmentFile=/etc/cpolar.env
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
# Start ssh and cpolar services
# ENTRYPOINT [ "/usr/sbin/init" ]


# Create initialization script
RUN tee /usr/local/bin/init-container.sh <-'EOF'
#!/bin/bash
# Replace value in environment variable file
sed -i "s/\${CPOLAR_AUTH_TOKEN}/$CPOLAR_AUTH_TOKEN/g" /etc/cpolar.env
# Start init
exec /usr/sbin/init
EOF

RUN chmod +x /usr/local/bin/init-container.sh

# Use initialized script as entry point
ENTRYPOINT ["/usr/local/bin/init-container.sh"]
