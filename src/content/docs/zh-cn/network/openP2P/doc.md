# openP2P 文档

[openP2P 安装文档](https://console.openp2p.cn/install)

## 使用systemd服务

```bash
# 创建docker-compose.yml文件
sudo nano /etc/openp2p/docker-compose.yml

# 写入以下内容
services:
  openp2p:
    image: openp2pcn/openp2p-client:3.24.35
    container_name: openp2p-client
    restart: always
    network_mode: host
    privileged: true
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    environment:
      - OPENP2P_TOKEN=xxx
```

```bash
# 创建服务文件
sudo nano /etc/systemd/system/openp2p.service

# 写入以下内容
# 确保iptables规则存在(PS: 使用iptables -C检查规则是否已存在, 仅在规则不存在时才添加，避免重复添加导致错误)
[Unit]
Description=OpenP2P Client Service
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStartPre=/bin/sleep 10
ExecStart=/bin/bash -c 'docker compose -f /etc/openp2p/docker-compose.yml up -d'
ExecStartPost=/bin/bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
ExecStartPost=/bin/bash -c 'iptables -t filter -C FORWARD -i optun -j ACCEPT 2>/dev/null || iptables -t filter -I FORWARD -i optun -j ACCEPT'
ExecStartPost=/bin/bash -c 'iptables -t filter -C FORWARD -o optun -j ACCEPT 2>/dev/null || iptables -t filter -I FORWARD -o optun -j ACCEPT'

[Install]
WantedBy=multi-user.target


# 启用并启动服务
sudo systemctl daemon-reload
sudo systemctl enable openp2p.service
sudo systemctl start openp2p.service

# 检查服务状态
sudo systemctl status openp2p.service
```

## 额外建议：环境变量配置

为了确保$OPENP2P_TOKEN环境变量在系统启动时可用，建议将其添加到/etc/environment：

```bash
# 运行以下命令添加环境变量
echo "OPENP2P_TOKEN=xxx" | sudo tee -a /etc/environment
```
