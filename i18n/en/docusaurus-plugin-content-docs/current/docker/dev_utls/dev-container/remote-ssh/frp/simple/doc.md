# frp Intranet through

[GitHub地址](https://github.com/fatedier/frp)

## Quick Start

[服务端docker-compose配置](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/frp/server/simple/docker-compose.yml)

[客户端docker-compose配置](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/frp/simple/docker-compose.yml)

Start with the following orders separately

```bash
docker compose up -d
```

ssh connection

```bash
ssh -oport=6000 root@116.1.1.1.1.1
```
