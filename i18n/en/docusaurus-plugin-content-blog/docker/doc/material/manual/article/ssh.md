# ssh

- [SSH Tunnel Concise Tutorial](https://www.lixueduan.com/posts/linux/07-ssh-tunnel/)
  - Dynamic Forward
    - The request address is 192.168.1.100:300, and the request address transmitted via SSH is 192.168.1.100:3000.
    - ssh -N -D localhost: 2000 root@192.168.10.85
    - We need only socks proxy on local configuration, localhost:2000 to forward all requests to the 192.168.10.85 machine via the ssh 2000 port.
  - Local Forward
    - We need to execute the following command on ServerA to enable ssh tunnel：
    - ssh -N - L 888: 192.168.10.134:8888 root@192.168.10.85
    - After execution server A has started listening to the 8888 port. By default it is on a local ring address, it can specify an ip or add -g parameters to open gateway mode.

- socks5 proxy

- [参考文章](https://wlwang41.github.io/content/ops/ssh%E9%9A%A7%E9%81%93%E4%BB%A3%E7%90%86.html)

- [参考文章1](https://blog.bug-maker.com/archives/47.html)

- [参考文章2](https://www.cnblogs.com/memphise/articles/6420019.html)
  - You can use a software called Sockscap. Throw an app and get it online.(apps that partially require calling multiple processes may not work anyway)
  - If you want to convert the socks proxy to an http-proxy, you can use the east.

```bash
# Upload Key ~/.ssh/id_ed25519_iu
chmod 400 ~/.ssh/id_ed25519_iu

# ~/.ssh/config
Host mac.intranet.company
  HostName 10.0.1. 51
  User iuin
  IdentityFile ~/.ssh/id_ed25519_iu
  # PasswordAuthentication 123456

# ssh mac.intranet.company see whether or not to be set up
```

- [ssh动态代理](ssh动态代理)

```bash
# 登录服务器10.0.1.233
# 后台启动ssh动态转发
ssh -o GatewayPorts=yes -D 2000 mac.intranet.company -NTfCg

# 在本机中配置socks代理, 网络流量则会通过ssh转发到服务器上, 然后在访问互联网
# 配置地址: 10.0.1.233:2000

# PS: 可以配合clash一起使用, 实现通过ssh让中间机器去连接指定或多个VPN, 本机不连多余的VPN(其实是不想下载一堆的VPN相关软件), 只用clash就能透传流量过去
port: 7890
socks-port: 7891
allow-lan: false
mode: Rule
log-level: info
external-controller: 127.0.0.1:9090
proxies:
  - name: iuin_bpDev_mac
    type: socks5
    server: 10.0.1.233
    port: 2000
proxy-groups:
  - name: ssh_g
    type: select
    proxies:
      - iuin_bpDev_mac
rules:
 # 乐橘nacos所在服务器
 - IP-CIDR,10.0.10.180/32,ssh_g
 - DOMAIN-SUFFIX,yelomall.cn,ssh_g
 
```
