# (frps selfhost version) can access the entire inner network with a container? Open restricted network with a container: frp+ssh combination image and clash(mihomo)

> Use containers to access restricted networks: frp+ssh combinations and clash(mihomo) to enable access to all inline services in any environment (including k8s) (webpages and terminal access)
> There is one more mention here because my scientific access environment is the clash(mihomo) software, so I use clash(mihomo) here to open various inner networks
> so I can need only one proxy

## Preface

There is always a need for access to other company intranets during the development process, usually through vpn from other companies, or jumpserver connections.

Several pain points are usually encountered at this time:
\- want to access the container services in k8s, `svc.cluster.local` cannot use
\- to install many bad vpn software, vpn used by different companies, vpn may be different, some may even like rogue software, various restrictions
\- some companies do not provide vpn or jumpserver, can only go on site
\- some of the unconnected and non-interoperable services in the home network or company network (some services in the company wishes to visit home, or some of the company's services at home, etc.)

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

I'll find a Linux system, or your own computer (troubleshoots, possible mirrors, need to specify a platform, etc.). Here I choose to use the x86 architectural centos system, then find a suitable directory such as: `/container/frp-ssh`

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

## Step 2: Write docker-compose.yml, easy to build and run containers

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
Copy printed public key content to write to `./.ssh/authorized_keys`, this file is a file that needs to be mounted to the container
```

- Note on volume (volume)

This volume can also not be mounted, or can be written to the `authorized_keys` file by entering the command in the container

```bash
# This step can omit
echo 'ssh-ed25519 xxxxx' > /root/.ssh/authorized_keys

```

## Step 3: Requires a cloud server with a public IP (2c2g1m, my mirror is Debian)

[frp官网安装地址](https://gofrp.org/zh-cn/docs/setup/systemd/)
[frp官方GitHub下载地址](https://github.com/fatedier/frp/releases/tag/v0.62.1)

```bash
# Download down to extract
tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && mv frp_0.62. _linux_amd64 frp
# Enter the extracted directory, start the frp server, set the auto-start
cd frp && systemctl start frps && systemctl enable frps
```

Then, open down port, e.g. open port:6666, for remote connection ssh

## Step 4: Start docker-compose, test container, and upload

```bash
# Build mirrors and start container
docker-compose up -d
```

- Try the effect using the ssh remote connection

```bash
# Upload public key, enable decrypted login. This step is a passing check if you can normally pass through the Intranet through the ssh to the container
ssh-copy-id root@129.204.8.8 - p 6666-i ~/.ssh/id_ed25519
# and then sign in to
ssh root@129.204.8.8 - p 6666
```

> This is almost complete anywhere to connect, followed by simplified configuration, and advanced applications

## Upload a mirror to Aliyun to simplify the configuration of the launch container

```bash
# Login to
docker logo --username=xxx@qq.com registry.cn-hangzhou.aliyuncs.com
## Marks local mirrors and points to target repository (ip:port/image_name:tag, this format is flagged Version)
docker tag dev-jumpbox registry.cn-hangzhou.aliyuncs.com/xx/dev-jumpbox:frpc-ssh
## Push image to repository
docker push registry.cn-hangzhou.aliyuncs.com/x/dev-jumpbox:frpc-ssh
```

## Simplified docker-compose configuration

Simplified only docker-compose, if `authorized_keys` is not integrated into Dockerfile, then mount the configuration is required

[参考详情链接](https://iuin8.github.io/doc-record/docker/dev_utls/dev-container/remote-ssh/frp/tcpmux/v6.1.1/doc)

```bash

Services:
  dev-jumpbox:
    image: registry.cn-hangzhou.aliyuncs.com/iuin/dev-jumpbox:tcpmux-v6.1.
    container_name: dev-jumpbox
    environment:
      TZ: "Asia/Shanghai"
      serverAddr: '"183. 1.11.11"'
      serverPort: 11100
      auth_token: 'x-jumpbox-ssh'
      client_name: '"container". rod. x.customer"'
      customDomains: '["container.prod.xx.customer"]'
    restart: unless-stopped

```

## Use the clash(mihomo) tool to facilitate access to the web page

Here we use the clash (mihomo) tool to redirect traffic agents to containers through ssh, so that we can access the corresponding Intranet pages on the side of the container as we visit the local area network

- [clash(mihomo)'s github address (https://www.clashverge.dev/guide/quickstart.html)

```bash
# 代理流量(script.js[这里用了全局脚本的方式, 兼容自己的原有的订阅, 不影响原有的订阅, 只做扩展])
function main(config, profileName) {
  const extra = {
    proxies: [
      {
        name: "company_container",
        type: "ssh",
        server: "183.11.11.11",
        port: 11111,
        username: "root",
        "private-key": "./.ssh/id_ed25519_iu"
      }
    ],
    proxyGroups: [
      {
        name: "company_g",
        type: "select",
        proxies: ["DIRECT", "company_container"]
      }
    ],
    rules: [
      "IP-CIDR,10.0.11.0/24,company_g",
      "DOMAIN-SUFFIX,company.com,company_g"
    ]
  };

  if (!Array.isArray(config.proxies)) config.proxies = [];
  for (const p of extra.proxies) {
    if (p && p.name && !config.proxies.some(x => x && x.name === p.name)) {
      config.proxies.unshift(p);
    }
  }

  if (!Array.isArray(config["proxy-groups"])) config["proxy-groups"] = [];
  for (const g of extra.proxyGroups) {
    let existing = config["proxy-groups"].find(x => x && x.name === g.name);
    if (!existing) {
      config["proxy-groups"].unshift({ name: g.name, type: g.type, proxies: Array.isArray(g.proxies) ? [...g.proxies] : [] });
    } else {
      if (!Array.isArray(existing.proxies)) existing.proxies = [];
      for (const pn of g.proxies || []) {
        if (!existing.proxies.includes(pn)) existing.proxies.unshift(pn);
      }
    }
  }

  if (!Array.isArray(config.rules)) config.rules = [];
  for (const r of extra.rules) {
    if (!config.rules.includes(r)) config.rules.unshift(r);
  }

  return config;
}

```

```yml
# Separate Subscription Configuration (ssh.yml)
proxies:
  - name: company_container
    type: ssh
    server: 183. 1.11.11.11
    port: 11111
    username: root
    private-key: ../. sh/id_ed25519_iu

proxy-groups:
  - name: company_g
    type: select
    proxies:
      - company_container

rules:
  - "IP-CIDR,10. 1.11.0/24, company_g"
  - "DOMAIN-SUFFIX,company.com,company_g"

```

## Use in k8, open network in namespace

```yml
## k8s等(有内部DNS功能的系统)用法

# 其他配置省略
rules:
  - "IP-CIDR,10.0.11.0/24,company_g"
  - "IP-CIDR,100.20.0.0/16,company_g"
  - "IP-CIDR,100.19.0.0/16,company_g"
  - "DOMAIN-SUFFIX,svc.cluster.local,company_g"
  - "DOMAIN-SUFFIX,company.com,company_g"

```

- Note: Three segments are mounted here
  - Of these, the first segment is the one that needs to be proxy for other regular traffic
  - The second and third segments are the segments used by containers in namespace
    - Useful is that we can access the services provided through k8s internal domain names, containers in k8s
      - Access via internal domain name in `svc.cluster.local`k8s

## Last applicable

By this time we have largely completed our objectives, have the same access as in a local area network, access pages and connect to databases, etc.

- More
  - [这篇文章对应的GitHub博客文档地址](https://iuin8.github.io/doc-record/docs/docker/dev_utls/dev-container/remote-ssh/frp/article/frp+ssh组合镜像以及clash打通网络.md)
