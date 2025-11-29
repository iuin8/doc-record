# v3 version

## Snooze

- Tunnel name, added to environment variable, customizable (temporarily not required)
- Other Advanced Actions
  - `cpolar.yml` file is customized by mount (mount configuration file)
- Docker-compose.yml uses with export command, so token is not easy to see

## Usage

```bash
# docker-compose.yml配置内容
services:
  cpolar-ssh:
    image: registry.cn-hangzhou.aliyuncs.com/iuin/cpolar-ssh:latest
    environment:
      - TZ="Asia/Shanghai"
      - CPOLAR_AUTH_TOKEN=${CPOLAR_AUTH_TOKEN}
      - CPOLAR_CONTANER_SSH_NAME=contaner_ssh_1
    restart: unless-stopped
    privileged: true 


export CPOLAR_AUTH_TOKEN=xxx
docker compose up -d

# 进cpolar官网页面查看域名

# ~/.ssh/config配置

Host cpolar.internet.company
  HostName 3.tcp.cpolar.top
  User root
  Port 11968
  IdentityFile ~/.ssh/id_ed25519_1
  # ForwardAgent yes
  # 让远程机器使用本地的代理(可以访问google了)
  # RemoteForward 127.0.0.1:9090 192.168.0.218:9090
  # PasswordAuthentication password

# 通过ssh远程连接容器
ssh cpolar.internet.company
```
