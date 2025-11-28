# (frps selfhost, version) Can you access the entire network with a container? Use the container to connect to restricted networks: frp+ssh portfolio images, and sshutley to open the network

> Use Container for Restricted Networks: frp+ssh Portfolio Imaging, and scuttle to enable all inner network services (including k8s) in any environment (webpage and criminal access)

## Preface

There is always a need for access to other companies during the development process, using through vpn from other companies, or jumpserver connections.

Several points are usually countered at this time:
\- want to access the container services in k8, `svc.cluster. ocal` cannot use
\- to install many bad vpn software, vpn used by different companies, vpn may be different, Some may occur like rogue software,various restrictions
\- some companies do not provide vpn or jumpservers, can only go on site
\- some of the unconnected and non-interoperable services in the home network or company network (some services in the company wishes to visit home, or some of the company's services at home, etc)

However, what are the benefits of being connected to the network?
\- Your own local computer does not need to accommodate too many vpn software for
\- every inner server that can be touched, becomes a tool for you when and where you can access or act as a springboard
\- the inner web to open the page,
\- Web system app can open
\- Nacos with browser on server
\- Intranet access
\- Database is connected via idea or DBeaver.

> This means that you have access to the network and ssh access where ssh can arrive, You can pull your own local computer into the same network for interoperability

## Prerequisite

需要有机会把容器起起来, 一般有以下几种方式, 选一个方便去操作的就行, 当容器起来之后, 网络就打通了, 虚拟机等过渡工具就可以删掉了, 不需要了
\- 通过jumpserver页面登录
\- 自己本身就安转了vpn
\- 找安装了vpn的同事
\- 专门找台机用于安装各种乱七八糟的vpn也行
\- 当然起个虚拟机去安转也行

## Step 1: Writing Dockerfile, used to make image

I'll find a Linux system, or your own computer (troubleshoots, possible mirrors, need to specify a platform, etc). There I choose to use the x86 archipelagic centres system, then find a suitable directory such as: `/container/frp-ssh`

- Create a `Dockerfile` file

```bash
# vim Dockerfile

FROM debian:trixie-slim

WORKDIR /www

# 安装必要的软件包
RUN apt-get update && \
    apt-get install -y openssh-server openssh-client curl wget locales gettext tini && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 生成并配置 locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# 设置环境变量
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# 解压frp
COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz
RUN tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && \
    mv frp_0.62.1_linux_amd64 frp

# 创建包装服务
RUN tee /www/frp/frpc.toml <<-'EOF'
serverAddr = ${serverAddr}
serverPort = ${serverPort}

[[${client_title}]]
name = ${client_name}
type = ${client_type}
${secretKey_stcp_line}
${localIP_proxies_line}
${localPort_proxies_line}
${serverName_visitors_line}
${bindAddr_visitors_line}
${bindPort_visitors_line}
${remotePort_proxies_tcp_line}
EOF

# 创建初始化脚本
RUN tee /entrypoint.sh <<-'EOF'
#!/bin/sh
# 替换环境变量的值
envsubst < /www/frp/frpc.toml > /tmp/frpc.toml.tmp && mv /tmp/frpc.toml.tmp /www/frp/frpc.toml

# 确保目录存在
[ ! -d "/var/run/sshd" ] && mkdir -p /var/run/sshd
# 启动 SSH（后台运行）
/usr/sbin/sshd -D &

# 启动 FRPC
/www/frp/frpc -c /www/frp/frpc.toml

# 保持容器运行
wait
EOF

RUN chmod +x /entrypoint.sh

# 暴露 SSH 端口
EXPOSE 22

# 使用 tini 作为 PID 1
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

```

## Step 2: Write docker-compose.yml, easy to build and run containers.

```bash
# vim docker-compose.yml

services:
  dev-jumpbox:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: dev-jumpbox
    environment:
      TZ: "Asia/Shanghai"
      # 配置服务端的IP
      serverAddr: '"129.204.8.8"'
      client_title: proxies
      serverPort: 7000
      # 名称随便给, 不重复就行
      client_name: '"dev-jumpbox-6666"'
      client_type: '"tcp"'
      localIP_proxies_line: localIP="127.0.0.1"
      localPort_proxies_line: localPort=22
      # 配置云服务器中开放的端口, 随便开放一个都行, 用于远程连接ssh
      remotePort_proxies_tcp_line: remotePort=6666
    extra_hosts:
      - "me.host:host-gateway"
    restart: unless-stopped
    volumes:
      - ./.ssh/authorized_keys:/root/.ssh/authorized_keys

# 以上环境变量, 除了备注的内容, 其他的都可以保持不动就行

# authorized_keys的内容示例
# ssh-ed25519 xxxxx xxx
```

- Sample content of authorized_keys

```bash
# Execute on local computer, print public key
cat ~/.ssh/id_ed25519.pub
printed public key content to write to `. .ssh/authorized_keys`, this file is a file that needs to be mounted to the container.
```

- Note on volume (volume)

This volume can also not be mounted, or can be written to the `authorized_keys` file by entering the command in the container.

```bash
# This step can omit
echo 'ssh-ed25519 xxx' > /root/.ssh/authorized_keys

```

## Step 3: Requires a cloud server with a public IP (2c2g1m, my mirror is Debian)

[frp官网安装地址](https://gofrp.org/zh-cn/docs/setup/systemd/)
[frp官方GitHub下载地址](https://github.com/fatedier/frp/releases/tag/v0.62.1)

```bash
# Download down to extreme
tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && mv frp_0.62. _linux_amd64 frp
# Enter the extracted directory, start the frp server, set the auto-start
cd frp && systemctl start frps && systemctl enable frps
```

Then, open down port, e.g. open port: 6666, for remote connection ssh

## Step 4: Start docker-compose, test container, and upload

```bash
# Build mirrors and start containing
docker-compose up -d
```

- Try the effect using the ssh remote connection

```bash
# vim ~/.ssh/config
Host frp.internet.company
  HostName 129.204.8.8
  User root
  Port 6666
  IdentitFile ~/.ssh/id_ed25519
```

```bash
# 上传公钥, 开启免密登录, 这一步也是顺便检查了是否能够正常通过内网穿透ssh到容器中
ssh-copy-id frpc.internet.company -i ~/.ssh/id_ed25519
# 然后, 通过ssh免密登录
ssh frpc.internet.company
```

> This is most complete anywhere to connect, followed by simplified configuration, and advanced applications

## Upload a mirror to Aliyun to simplify the configuration of the launch

```bash
# Login to
docker logo --username=xxx@qqq.com registry.cn-hangzhou.aliyuncs. om
## Marks local irrors and points to target repository (ip:port/image_name:tag, this format is flagged Version)
docker tag dev-jumpbox registry. n-hangzhou.aliyuncs.com/x/dev-jumpbox:frpc-ssh
## Push image to repository
docker push registry.cn-hangzhou.aliyuncs.com/x/dev-jumpbox:frpc-ssh
```

## Simplified docker-compose configuration

Simplified only docker-compose, if `authorized_keys` is not integrated into Dockerfile, then mount the configuration is required.

```bash

Services:
  dev-jumpbox:
    image: registry.cn-hangzhou.aliyuncs. om/iuin/dev-jumpbox:frpc-ssh-v5
    container_name: dev-jumpbox
    environment:
      TZ: "Asia/Shanghai"
      # Configure IP
      serverAddr: '"129. 04.8. "'
      client_title: proxies
      serverPort: 7000
      # Name given, Do not repeat line
      client_name: 'dev-jumpbox-66''
      client_type: 'tcp'
      localIP_proxies_line: localIP="127. The Committee recommends that the State party: "
      localPort_proxies_line: localPort=22
      # Configure open ports in cloud servers, open one line whenever possible, Used for remote connection ssh
      remotePort_proxies_tcp_line: remotePort=6666
    extra_hosts:
      - "me. os:host-gateway"
    restore: unless-stopped
```

## Use with sshuttle tool to facilitate access to web pages

There we use the shuttle tool to forward traffic proxies to containers through ssh, so that we can access the corresponding web pages on the container side as we visit the local area network (LAN)

- [sshuttle的github地址](https://github.com/sshuttle/sshuttle)

```bash
# Installation (macos)
brew install sshuttle
# proxy traffic
sshuttle --dns --auto-hosts --auto-nets-D -r cpolar.internet.company 10.0.0/24

```

## Use in k8, open network in name

```bash
## k8s and others (systems with internal DNS functions) Usage
sshuttle --dns --auto-hosts--auto-nots -D -r cpolar.internet.company 10.0.10.0/24100.20.0.0/ 16 100.19.0/
```

- Note: Three conferences are mounted here
  - If so, the first sentence is the one where proxy traffic is required
    - For example, this container was launched in k8s to open the name internal network
  - The second and third sessions are the meetings used by containers in namespace
    - Useful is that we can access the services provided through k8s internal names, containing in k8s
      - This is when we visit an internal domain name in `svc.cluster.local`k8s'
        - sshuttle --dns configuration will use this internal domain name to every internal dns through the first section to get internal IP and local computer to access this IP
        - Finally, just as getting an internal IP for the k8s container, secondary and third session traffic also needs to be proxy

## Last applicable

By this time we have substantially completed our objectives, have the same access as in a local area network, access pages and connect to databases, etc.

- Next objective
  - Implementing p2p connection

- More
  - [这篇文章对应的博客文档](https://183461750.github.io/doc-record/docker/dev_utls/dev-container/remote-ssh/frp/article/doc)
  - [对应的GitHub仓库](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/frp/v5/doc.md), all relevant config codes can be found here

> I think it is time to say a little bit about it, see it next time: waving_hand:
