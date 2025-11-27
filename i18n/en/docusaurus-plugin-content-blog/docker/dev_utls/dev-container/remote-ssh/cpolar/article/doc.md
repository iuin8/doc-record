# Can you access the entire Intranet (free version) with a container? Use Container to connect restricted networks: cpolar+ssh portfolio images, and sshuttley to open the network

> Use Container for Restricted Networks: cpolar+ssh Portfolios and sshuttle to enable all inner network services (including k8s) in any environment (webpages and terminal access)

## Preface

There is always a need for access to other company intranets during the development process, usually through vpn from other companies, or jumpserver connections.

A few pain points are usually encountered at this time:
\- want to access the container services in k8s, k8s internal domain cannot use
\- to install many bad vpn software, vpn may be different from one company to another, some vpn may even be like rogue software, there are various restrictions
\- some companies do not offer vpn or jumpserverer, can only go on site
\- problems with which the network is not interoperable with the company network (some services in which the company wishes to visit home, or some of the company's services at home, etc.)

However, what are the benefits of being connected to the network?
\- Your own local computer does not need to accommodate too many vpn software for
\- every inner server that can be touched, becomes a tool for you when and where you can access or act as a springboard
\- the inner web to open the page,
\- Web system app can open
\- Nacos with browser on server
\- Intranet access
\- Database is connected via idea or DBeaver.

> This means that you have access to the network and ssh access where ssh can arrive, you can pull your own local computer into the same network for interoperability

## Prerequisite

需要有机会把容器起起来, 一般有以下几种方式, 选一个方便去操作的就行, 当容器起来之后, 网络就打通了, 虚拟机等过渡工具就可以删掉了, 不需要了
\- 通过jumpserver页面登录
\- 自己本身就安转了vpn
\- 找安装了vpn的同事
\- 专门找台机用于安装各种乱七八糟的vpn也行
\- 当然起个虚拟机去安转也行

## Step 1: Writing Dockerfile, used to make image

I'll find a Linux system, or your own computer (troubleshoots, possible mirrors, need to specify a platform, etc.). Here I choose to use the x86 architectural centos system, and then find a suitable directory such as: `/container/cpolar-ssh`

- Create a `Dockerfile` file

```bash
# vim Dockerfile
# 使用官方 CentOS 基础镜像(PS: latest版拉取openssh-server依赖报错)
# FROM centos:centos7.9.2009
FROM registry.cn-hangzhou.aliyuncs.com/iuin/centos:latest

# ENV https_proxy=http://192.168.0.121:7890 http_proxy=http://192.168.0.121:7890 all_proxy=socks5://192.168.0.121:7890

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo && \
    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo && \
    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo && \
    yum install -y wget && \
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

# 安装必要的软件包
RUN yum update -y && yum install -y openssh-server openssh-clients passwd && yum clean all

# 设置 root 密码, 修改 SSH 配置文件允许密码登录和 root 登录
RUN echo "root:password" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config && \
    /usr/sbin/sshd-keygen

RUN curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | bash

COPY cpolar.yml /usr/local/etc/cpolar/cpolar.yml

# 开启服务后, /usr/sbin/init命令会自动帮忙启动服务
RUN systemctl enable cpolar.service


# 创建启动脚本
RUN tee /usr/local/bin/start-cpolar.sh <<-'EOF'
#!/bin/bash
cpolar authtoken ${CPOLAR_AUTH_TOKEN}
EOF

RUN chmod +x /usr/local/bin/start-cpolar.sh

# 创建包装服务
RUN tee /etc/systemd/system/cpolar-wrapper.service <<-'EOF'
[Unit]
Description=Cpolar Wrapper Service
# After=network.target
After=cpolar.service

[Service]
Type=simple
ExecStart=/usr/local/bin/start-cpolar.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 启用包装服务
RUN systemctl enable cpolar-wrapper.service


# 暴露 SSH 端口
EXPOSE 22
# 启动ssh和cpolar服务
# ENTRYPOINT [ "/usr/sbin/init" ]


# 创建初始化脚本
RUN tee /usr/local/bin/init-container.sh <<-'EOF'
#!/bin/bash
# 替换环境变量的值
sed -i "s/\${CPOLAR_AUTH_TOKEN}/$CPOLAR_AUTH_TOKEN/g" /usr/local/bin/start-cpolar.sh
sed -i "s/\${CPOLAR_CONTANER_SSH_NAME}/${CPOLAR_CONTANER_SSH_NAME:-contaner_ssh}/g" /usr/local/etc/cpolar/cpolar.yml
# 启动 init
exec /usr/sbin/init
EOF

RUN chmod +x /usr/local/bin/init-container.sh

# 使用初始化脚本作为入口点
ENTRYPOINT ["/usr/local/bin/init-container.sh"]

```

## Step 2: Write docker-compose.yml, easy to build and run containers

```bash
vim docker-compose.yml

services:
  cpolar-ssh:
    build:
      context:
      dockerfile: Dockerfile
    environment:
      - TZ="Asia/Shanghai"
      - CPOLAR_AUTH_TOKEN=xx
      - CPOLAR_CONTANER_SSH_NAME=coner_ssh_1
    restore: unless-stopped
    primited: true 
    volumes:
      - cpolar.yml:/usr/local/etc/cpolar/cpolar.yml

```

- Write a cpolar profile to mount
  - This can also be considered to write to Dockerfile, update the variable by way of the environment variable
  - More tunnels need to be configured, then mount them out, thus simplifying the base process

```bash
vim cpolar.yml

tunnels:
  ${CPOLAR_CONTANER_SSH_NAME}:
    proto: tcp
    addr: "22"
    bind_tls: both
    start_type: enable

```

## Step 3: Start docker-compose, test container, and upload

Adjust the environment variable in the last step, mainly `CPOLAR_AUTH_TOKEN`, needs to register a free account in the polar to get token.

- [cpolar官网地址](https://www.cpolar.com/)

```bash
# Build mirrors and start container
docker-compose up -d
```

- Try the effect using the ssh remote connection

```bash
# vim ~/.ssh/config
Host polar.internet.company
  HostName xxx.tcp.cpolar.top
  User root
  Port 11111
  IdentitFile ~/.ssh/id_ed25519
```

```bash
# Upload public key, enable decrypted login by passing through the Intranet to check if you can normally pass through the container to
ssh-copy-id cpolar.internet.company -i ~/.ssh/id_ed25519
# and then log in
ssh cpolar.internet.company
```

> This is almost complete anywhere to connect, followed by simplified configuration, and advanced applications

## Upload a mirror to Aliyun to simplify the configuration of the launch container

```bash
# Login to
docker logo --username=xxx@qq.com registry.cn-hangzhou.aliyuncs.com
## Marks local mirrors and points to target repository (ip:port/image_name:tag, this format is the notation number)
docker tag cpolar-ssh registry.cn-hangzhou.aliyuncs.com/xxx/cpolar-ssh:latest
## Push image to repository
docker push registry.cn-hangzhou.aliyuncs.com/xx/polar-ssh:latest
```

## Simplified docker-compose configuration

Simplified will only require docker-compose. Of course, if the cpolar configuration is not integrated into Dockerfile, it will still need to mount the configuration

```bash
services:
  cpolar-ssh:
    image: registry.cn-hangzhou.aliyuncs.com/xxx/cpolar-ssh:latest
    environment:
      - TZ="Asia/Shanghai"
      - CPOLAR_AUTH_TOKEN=${CPOLAR_AUTH_TOKEN}
      - CPOLAR_CONTANER_SSH_NAME=contaner_ssh_1
    restart: unless-stopped
    privileged: true 
```

## Use with sshuttle tool to facilitate access to web pages

Here we use the sshuttle tool to forward traffic proxies to containers via ssh, so that we want to access the corresponding web page on the container side of the local area network

- [sshuttle的github地址](https://github.com/sshuttle/sshuttle)

```bash
# Installation (macos)
brew install sshuttle
# proxy traffic
sshuttle --sudoers-user fa --dns --method auto-hosts --auto-not-D -r cpolar.internet.company 10.0.0/24
```

## Last applicable

By this time we have largely completed our initial objectives, have the same access as in a local area network, access pages and connect to databases, etc.

- Finally, there are still some problems with existing programmes
  - Password connection is relatively less secure
  - `privileged: true` is used in the `systemd` tool, i.e. \`docker-compose', the container is too high
  - The third party server (cpolar) is used to transit traffic through another person's server

- Next objective
  - ssh login using key mode and disable password login
  - Container Service Management tool does not use `systemd`, but instead has a lighter multiservice management tool `tini`.
    - This docker container is not required to configure `privileged: true`.
  - The Intranet penetrates into an open source `frp`, of course, it needs to have its own public server to deploy the server

- Related links
  - [这篇文章对应的博客文档](https://183461750.github.io/doc-record/docker/dev_utls/dev-container/remote-ssh/cpolar/article/doc)
  - [对应的GitHub仓库](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/cpolar/v3/simple/docker-compose.yml), all relevant config codes can be found here

> I think it is time to say a little bit about it, see it next time: waving_hand:
