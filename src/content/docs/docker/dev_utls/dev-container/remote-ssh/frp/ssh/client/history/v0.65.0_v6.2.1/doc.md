# frp+ssh+docker打通受限网络(client)

- [官方文档](https://gofrp.org/zh-cn/docs/overview/)
- [frp_0.65.0_linux_amd64.tar.gz](https://github.com/fatedier/frp/releases/download/v0.65.0/frp_0.65.0_linux_amd64.tar.gz)

## 配置说明

必须配置项:
- serverAddr
- serverPort
- auth.token
- proxies.name
- proxies.customDomains

```json
{
    // 必须参数
    "serverAddr": "55.44.33.33",
    // 必须参数
    "serverPort": 18000,
    "auth": {
        "method": "token",
        // 必须参数
        "token": "frps-ssh"
    },
    "loginFailExit": false,
    "transport": {
        "heartbeatInterval": 25,
        "heartbeatTimeout": 120,
        "poolCount": 10,
        "tcpMux": true
    },
    "proxies": [
        {
            // 必须参数
            "name": "frpc-ssh-fa",
            "type": "tcpmux",
            "multiplexer": "httpconnect",
            // 必须参数
            "customDomains": ["fa.intranet.company"],
            "localIP": "127.0.0.1",
            "localPort": 22
        }
    ]
}
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
