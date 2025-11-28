# (frps selfhost version) can access the entire inner network without having to start a container? Use Container to connect restricted network: frp+ssh combination image and clash (mihomo) network

> Use carriers to access restricted networks: frp+ssh combinations and clash(mihomo) to enable access to all inline services in any environment (including k8s) (webpages and criminal access)
> There is one more mention here because my scientific access environment is the clash(mihomo) software, so I use clash(mihomo) here to open various inner networks
> so I can need only one proxy

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

## Write docker-compose.yml (server)

> This is the server you have a public IP cloud server. I use Debian here, you can choose the right image according to your own numbers.

```yml
# vi /dev-jumpbox/server/docker-compose.yml
services:
  frps-ssh:
    image: registry.cn-hangzhou.aliyuncs. om/iuin/frps-ssh:tcpmux
    network_mode: host
    environment:
      - TZ="Asia/Shanghai"
      - auth_token="xxxxx"
      - bindPort=18000
      - tcpmuxHTTPConnectPort=12222
    restart: unless-stopped

```

```bash
# Build mirrors and start containing
docker-compose up -d
```

## Write dock-compose.yml (client)

```yml
# vi /dev-jumpbox/client/docker-compose.yml
services:
  dev-jumpbox:
    image: registry.cn-hangzhou.aliyuncs.com/iuin/dev-jumpbox:tcpmux-v6.
    Container_name: dev-jumpbox
    environment:
      TZ: "Asia/Shanghai"
      serverAddr: '"55. 4.33"'
      ServerPort: 18000
      auth_token: 'jumpboxs-ssh'
      client_name: '''`jumpboxc-ssh-fa''
      customDomains: '["fa". ntranet.company"]'
    volumes:
      - .ssh/:root/.ssh/:ro
    restore: unless-stopped

```

```bash
# Build mirrors and start containing
docker-compose up -d
```

- Note on volume (volume)

This volume can also not be mounted, or it can be written to the `authorized_keys` file by entering the Container, But when the container returns, it will lose the written content

```bash
# Execute on local computer, print public key
cat ~/.ssh/id_ed25519.pub
printed public key content to write to `. .ssh/authorized_keys`, this file is the file
# Full path: /dev-jumpbox/client/. Sh/authorized_keys(note: Don't confuse with the host's authorised_keys file)
# There can also be managed by the dev-jumpbox container, mount the most generated public and private keys in the container, then execute the command in the container to write the authorised_keys file, and then give the private key to the clash (Mihomo) tool using
# If the clash user wants to use their own private keys, then choose to create the public private key into the clash configuration directory, and then in the clash configuration file, Use your own private key to use the private key file (cash verge rev supports only to read the private key from the root directory)
```

```bash
# Executed in customer host or container, written to the public key in the authorized_keys file
echo 'ssh-ed25519 xxxxx' > ./.ssh/authorized_keys
```

## Step 4: Start docker-compose, test container, and upload

```bash
# Build mirrors and start containing
docker-compose up -d
```

- Try the effect using the ssh remote connection

```bash
# 上传公钥, 开启免密登录, 这一步也是顺便检查了是否能够正常通过内网穿透ssh到容器中
ssh-copy-id root@129.204.8.8 -p 12222 -i ~/.ssh/id_ed25519
# 然后, 通过ssh免密登录
ssh root@129.204.8.8 -p 12222
```

[参考详情链接](https://iuin8.github.io/doc-record/docker/dev_utls/dev-container/remote-ssh/frp/tcpmux/v6.1.1/doc)

> This is most complete every where to connect to the ssh, followed by advanced apps, Working with the clash (mihomo) tools, and implementing network traffic agents to the content container.

## Use the clash(mihomo) tool to facilitate access to the web page

There we use the clash (Mihomo) tool to redirect traffic agents to containers through ssh, so that we can access the corresponding Intranet pages on the side of the container as we visit the local area network

- [clash(mihomo)'s github address (https://www.clashverge.dev/guide/quickstart.html)

```JavaScript
// 代理流量(script.js[这里用了全局脚本的方式, 兼容自己的原有的订阅, 不影响原有的订阅, 只做扩展])
function main(config, profileName) {
  const privateKeyContent = `-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZxxxABAAAAMwAAA
QyNTUxOQAAAxxxAAAIgIqewcCKn
HAAAAAtxxxDYC8YhlRDIhM+GUeg
-----END OPENSSH PRIVATE KEY-----`;
  const extra = {
    proxies: [
      {
        name: "company_container",
        type: "ssh",
        server: "183.11.11.11",
        port: 11111,
        username: "root",
        // 用密钥的情况下, 这里需要把密钥复制到软件配置目录下的.ssh目录中, 才能正常使用
        // "private-key": "./.ssh/id_ed25519_iu"
        "private-key": privateKeyContent
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
# 单独订阅配置(ssh.yml)
proxies:
  - name: company_container
    type: ssh
    server: 183.11.11.11
    port: 11111
    username: root
    # 用密钥的情况下, 这里需要把密钥复制到软件配置目录下的.ssh目录中, 才能正常使用
    # private-key: ./.ssh/id_ed25519_iu
    private-key: |
      -----BEGIN OPENSSH PRIVATE KEY-----
      b3BlbnNzaC1rZxxxABAAAAMwAAA
      QyNTUxOQAAAxxxAAAIgIqewcCKn
      HAAAAAtxxxDYC8YhlRDIhM+GUeg
      -----END OPENSSH PRIVATE KEY-----

proxy-groups:
  - name: company_g
    type: select
    proxies:
      - company_container

rules:
  - "IP-CIDR,10.0.11.0/24,company_g"
  - "DOMAIN-SUFFIX,company.com,company_g"

```

## Use in k8, open network in name

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

- Note: Three conferences are mounted here
  - If so, the first sentence is the one that needs to be proxy for other regular traffic
  - The second and third sessions are the meetings used by containers in namespace
    - Useful is that we can access the services provided through k8s internal names, containing in k8s
      - Access via internal domain name in `svc.cluster.local`k8s

## Last applicable

By this time we have substantially completed our objectives, have the same access as in a local area network, access pages and connect to databases, etc.

> Welcome to Message Exchange for Questions

- More
  - [这篇文章对应的GitHub博客文档地址](https://iuin8.github.io/doc-record/docs/docker/dev_utls/dev-container/remote-ssh/frp/article/frp+ssh组合镜像以及clash打通网络.md)
