# Use cash records in linux

## Install clash-for-linux

- clash file directory[内网服务器路径备忘](/root/vpn)
  - [本地备份文件](clash-linux-amd64-v1.18.0.gz), `gzi-d clash-linux-amd64-v.18.0.gz`
- Additional reference links (previous links don't know where to go and new ones are found)
  - [clash-for-linux](https://github.com/ghostxu97/clash-for-linux)
  - [clash-for-linux](https://blog.iswiftai.com/posts/clash-linux/)

## Add config.yaml profile

Add config.yaml file to the clash peer directory

File source:
\- Local Client
\- Settings -> Configuration -> Opens Configuration Folder - Valid config. aml (can be found when clash is placed on server)

## Start command

```shell
# Rename
mv clash-linux-amd64-v.18.0 clash
# vim start.sh
cd /root/vpn
nowhp./clash -d.
```

- Environment Variable Configuration (for system proxy)

```shell
# vim .env
# Setup System Proxy
export https:///127.0.0.0.0.0.17890 http_proxy=http://127.0.0.1:7890all_proxy=socks5://127.0.0.0.0.1:7890
# Cancel System Proxy
unset http_proxy https://proxy_proxy
```

> There is already access to the external network

## DashBoard External Control (clash configuration in Visualizer Remote Managed Server)

> Prerequity: there is a cloud customer on the local computer to install a visualized interface.

PS：is only using default configuration, this step does not require action

```bash
# Modified /etc/clash/config. Aml file section configured：
mixed-port: 12345
authorization:
  - "Username 1:Password 1"
  - "Username 2:Password 2"
allow-lan: true
mode: Rule
log-level: info
external-controller: ::9090

# Setup
export https_proxy=http://username1:password 1127. :12345 http_proxy=http://username1: password 1127.0.1:1234all_proxy=socks5:// username 1: password 1.1127.0.1:12345

# config. aml, external control port
external-controller: :9090
# Clash installed on your own local computer can find the remote controller manager interface in the configuration interface in the settings where api url (http://ip:900) is added to perform remote control
```
