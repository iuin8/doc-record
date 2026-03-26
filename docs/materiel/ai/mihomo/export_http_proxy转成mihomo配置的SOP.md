# export_http_proxy 转成 Mihomo 配置的 SOP

基于 Mihomo（原 Clash.Meta）的官方文档规范，要将您的 `10.0.4.95:7897` 代理转换为 Mihomo 配置，最权威且“一次性解决所有流量”的方案是使用 **TUN 模式**。

这种方案通过内核级虚拟网卡接管流量，使得宿主机、Docker 容器以及所有非 HTTP 协议（如 ICMP/UDP）都能无感走代理。

---

## 1. Mihomo 核心配置文件 (`config.yaml`)

请在 `/etc/mihomo/config.yaml` 中写入以下内容。此配置严格遵循 Mihomo 官方的 `tun` 字段规范。

```yaml
# 混合端口，支持 HTTP(S) 和 SOCKS5
mixed-port: 7890
allow-lan: true
bind-address: '*'
mode: rule
log-level: info
ipv6: false

# DNS 模块 (TUN 模式必须配置 DNS 劫持)
dns:
  enable: true
  enhanced-mode: fake-ip
  nameserver:
    - 223.5.5.5
    - 119.29.29.29

# --- 核心：TUN 模式配置 ---
tun:
  enable: true
  stack: system        # 使用系统协议栈，性能最稳
  auto-route: true     # 自动设置全局路由，接管容器流量
  auto-detect-interface: true # 自动定位物理网卡
  dns-hijack:
    - "any:53"         # 劫持所有 DNS 请求

# --- 转换您的代理配置 ---
proxies:
  - name: "My-Gateway-Proxy"
    type: http         # 对应您的 http_proxy
    server: 10.0.4.95
    port: 7897
    # 如果是 SOCKS5 也可以改为 type: socks5

proxy-groups:
  - name: "MATCH"
    type: select
    proxies:
      - "My-Gateway-Proxy"
      - DIRECT

rules:
  - MATCH,MATCH        # 全局流量强制走该代理
```

---

## 2. 标准操作程序 (SOP)

### 第一步：下载并安装二进制文件
从 Mihomo 官方 [GitHub Releases](https://github.com/MetaCubeX/mihomo/releases) 下载对应架构（通常是 `linux-amd64`）的包。

```bash
# 解压并移动到系统路径
sudo mv mihomo-linux-amd64 /usr/local/bin/mihomo
sudo chmod +x /usr/local/bin/mihomo
```

### 第二步：创建配置目录
```bash
sudo mkdir -p /etc/mihomo
# 将上面的 yaml 内容保存到 /etc/mihomo/config.yaml
```

### 第三步：配置 Systemd 服务（推荐）
这是最权威的持久化运行方式。创建文件 `/etc/systemd/system/mihomo.service`:

```ini
[Unit]
Description=Mihomo Daemon
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/etc/mihomo
ExecStart=/usr/local/bin/mihomo -d /etc/mihomo
Restart=always
# 给予修改网卡和路由的权限
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW

[Install]
WantedBy=multi-user.target
```

### 第四步：启动与验证
```bash
# 启动服务
sudo systemctl daemon-reload
sudo systemctl enable --now mihomo

# 验证网卡是否生成 (会出现一个名为 utun 的网卡)
ip addr show utun

# 验证容器流量
docker run --rm curlimages/curl -s https://www.google.com
```

---

## 3. 为什么这个方案符合您的要求？

1.  **全局覆盖**：`tun.auto-route: true` 会修改系统路由表。这意味着无论是普通的 `curl`，还是 Docker 内部的流量，都会被强制导向 `utun` 网卡，无需再执行任何 `export` 命令。
2.  **权威性**：配置采用了 `fake-ip` 模式和 `system` stack，这是 Mihomo 官方推荐的 Linux 环境高性能透明代理标准。
3.  **优雅性**：不再需要修改 Docker 的 `config.json` 或环境变量，对系统侵入性最小，关掉 Mihomo 服务，系统网络立即恢复原状。

**注意**：由于开启了 TUN 模式，Mihomo 必须以 **root** 权限运行（或拥有 `CAP_NET_ADMIN` 权限）。

您需要我为您提供一个 Python 脚本来自动完成上述所有文件的创建和安装吗？
