---
title: "frp+ssh+docker打通受限网络"
---

# frp+ssh+docker打通受限网络

目的: 解决客户环境只能使用jumpserver连接的限制
通过启动一个docker容器即可解决

## 安装包获取

frp 0.62.1（linux/amd64）官方下载地址：

- https://github.com/fatedier/frp/releases/download/v0.62.1/frp_0.62.1_linux_amd64.tar.gz
- 发行版列表：https://github.com/fatedier/frp/releases

```bash
wget https://github.com/fatedier/frp/releases/download/v0.62.1/frp_0.62.1_linux_amd64.tar.gz
tar -xzf frp_0.62.1_linux_amd64.tar.gz && mv frp_0.62.1_linux_amd64 frp
```

完整性校验（MD5）：`1e8e703edfa96e915d158b9f3767da3a`

容器内构建时，若未随镜像保留安装包，可将 `COPY` 指令替换为直接下载：

```dockerfile
RUN wget -O ./frp_0.62.1_linux_amd64.tar.gz \
    https://github.com/fatedier/frp/releases/download/v0.62.1/frp_0.62.1_linux_amd64.tar.gz && \
    tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && \
    mv frp_0.62.1_linux_amd64 frp
```

- 查看日志

```bash
journalctl -u frpc.service
```
