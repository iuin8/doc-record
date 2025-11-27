# Use the official CentS base image (PPS: latest-pack openssh-server dependencies
# FROM rockylinux:latest
# FROM rockylinux:9.3
FROM ubuntu:noble
# FROM almalinux:10-kitten-minimal
# FROM almalinux:10-kitten
# FROM registry.cn-hangzhou.aliyuncs.com/iuin/rockylinux:latest

# ENV https_proxy=http://192.168.0.121:7890 http_proxy=http://192.168.0.121:7890all_proxy=socks5://192.168.0.121:789090

# RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo &&\s
# sed-i s/^#.*baseurl=http://baseurl=http://etc/yum.repos.d/*.repo &&\s
# sed-i s/^mirrorlist=http://#mirrorlist=http://g /etc/yum.repos.d/*.repo &&\s
# yum install -y wget && \s
# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliun.com/repo/Centos-7.repo

WORKDIR /www

# Install Required Packages
RUN apt-get Update &\s
    apt-get install - y openssh-server openssh-customer passwd curl wget &\s
    apt-get clean && \s
    rm -rf /var/lib/apt/lists/*


# Configure SSH (optional)
RUN mkdir /var/run/sshd && \s
    echo 'root:password' | chpasswd && \s
    sed-i 's/#PermitRootLogin Prohibit-password/PermitRoot Login yes/'/etc/ssh/sshd_config &&&\s
    identified -i 's/#PasswordAuthentication no/PasswordAuthentication yes/'/etc/ssh/sshd_config


# RUN wget -O ./frp_0.62.1_linux_amd64.tar.gz https://github.com/fatdier/frp/releases/download/v0.62.1/frp_0.l_linux_amd64.tar.gz &&\s
# mkdir -p /www/frp && \s
# tar -xzf ./frp_0.62.1_linux_amd64.tar.gz &\s
# mv frp_0.62.1_linux_amd64 frp

COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz
RUN tar -xzf ./frp_0.62.1_linux_amd64.tar.gz &\s
    mv frp_0.62.1_linux_amd64 frp

# Create packing service
RUN tee /www/frp/frpc.toml <<-'EOF'
serverAddr = ${serverAddr}
serverPort = ${serverPort}

[[proxies]]
name = ${client_name}
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = ${ssh_remotePort}
EOF


# Create packing service
RUN tee/etc/systemd/frpc.service <-'EOF'
[Unit]
# names, customizable
Description = frp customer
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
# Command to launch frpc, change the installation path to your frpc
Execart = /www/frp/frpc-c /www/frp/frpc.toml

[Install]
WantedBy = multi-user.target
EOF

# Enable wrapping services
RUN systemctl enable frpc.service


# Exposure SSH ports
EXPOSE 22
# Start ssh and cpolar services
# ENTRYPOINT [ "/usr/sbin/init" ]


# Create initialization script
RUN tee /usr/local/bin/init-container.sh <-'EOF'
#!/bin/bash
# Replace environment variable values
sed -i "s/\${serverAddr}/${serverAddr}/g" /www/frp/frpc.toml
sed -i "s/\${serverPort}/${serverPort}/g" /www/frp/frpc.toml
sed -i "s/\${client_name}/${client_name}/g" /www/frp/frpc.toml
sed -i "s/\${ssh_remotePort}/${ssh_remotePort}/g" /www/frp/frpc.toml
# Start init
exec /usr/sbin/init
EOF

RUN chmod +x /usr/local/bin/init-container.sh

# Use initialized script as entry point
ENTRYPOINT ["/usr/local/bin/init-container.sh"]
