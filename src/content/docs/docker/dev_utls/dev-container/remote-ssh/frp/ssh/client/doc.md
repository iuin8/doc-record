# frp+ssh+docker打通受限网络(client)

- [官方文档](https://gofrp.org/zh-cn/docs/overview/)
- [frp_0.65.0_linux_amd64.tar.gz](https://github.com/fatedier/frp/releases/download/v0.65.0/frp_0.65.0_linux_amd64.tar.gz)

```bash
# 下载frp_0.66.0_linux_amd64.tar.gz
wget https://github.com/fatedier/frp/releases/download/v0.66.0/frp_0.66.0_linux_amd64.tar.gz
```

## 后续优化

```bash
# 服务端配置
# sudo nano /etc/ssh/sshd_config
# 每60秒向客户端发送心跳
ClientAliveInterval 60
# 允许5次心跳失败（总共300秒）
ClientAliveCountMax 5
# 启用TCP保活
TCPKeepAlive yes
```
