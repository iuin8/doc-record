# mihomo配置智能分流SOP

thought Target: 32 tokens.
是的，**Mihomo 以 Docker 方式运行完全可以实现宿主机全局 TUN 代理**。

这种方案的精髓在于利用 Docker 的 `host` 网络模式，使容器直接操作宿主机的网络协议栈。通过 `GEOSITE` 和 `GEOIP` 规则，我们可以实现“中国大陆 IP/域名直连，海外流量走代理”的自动化分流。



### 1. 完整配置：Docker Compose 方案

请在服务器创建目录（如 `/opt/mihomo`），并准备以下两个文件。

#### 文件 A：`docker-compose.yaml`
```yaml
services:
  mihomo:
    image: metacubex/mihomo:latest
    container_name: mihomo
    restart: always
    network_mode: "host" # 必须：共享宿主机网络
    cap_add:
      - NET_ADMIN        # 必须：赋予修改路由权限
    devices:
      - /dev/net/tun     # 必须：映射 TUN 设备
    volumes:
      - ./config.yaml:/root/.config/mihomo/config.yaml
```

#### 文件 B：`config.yaml` (按需转换的权威分流版)
此配置实现了：**中国流量直连，海外走代理，且接管宿主机所有容器。**

```yaml
# 基础配置
mixed-port: 7890
allow-lan: true
log-level: info
ipv6: false

# DNS 配置 (TUN 模式的核心，防止 DNS 污染)
dns:
  enable: true
  enhanced-mode: fake-ip
  nameserver:
    - 223.5.5.5 # 阿里 DNS
    - 119.29.29.29 # 腾讯 DNS
  proxy-server-nameserver:
    - 8.8.8.8
  nameserver-policy:
    "geosite:cn": [223.5.5.5, 119.29.29.29]

# TUN 模式配置：自动接管宿主机及容器流量
tun:
  enable: true
  stack: system
  auto-route: true     # 自动设置系统路由
  auto-detect-interface: true
  dns-hijack:
    - "any:53"

# 代理节点
proxies:
  - name: "My-Proxy-Node"
    type: http
    server: 10.0.4.95
    port: 7897

# 分流策略组
proxy-groups:
  - name: "FINAL"
    type: select
    proxies:
      - "My-Proxy-Node"
      - DIRECT

# 分流规则 (权威来源：GeoSite/GeoIP)
rules:
  # 1. 局域网和本地流量直连
  - GEOIP,private,DIRECT,no-resolve
  
  # 2. 中国大陆域名直连 (需 Mihomo 自动下载 Geosite 库)
  - GEOSITE,cn,DIRECT
  
  # 3. 中国大陆 IP 直连
  - GEOIP,cn,DIRECT
  
  # 4. 剩余所有流量（海外）走代理
  - MATCH,FINAL
```

---

### 2. 标准操作程序 (SOP)

1.  **启动服务**：
    在 `/opt/mihomo` 目录下运行：
    ```bash
    sudo docker compose up -d
    ```
2.  **检查路由接管状态**：
    运行 `ip route`，你会发现默认网关（default）或部分路由已被指向 `utun` 设备。
3.  **验证分流效果**：
    * **测试国内**：`curl -I https://www.baidu.com` (应该很快，且 Mihomo 日志显示 DIRECT)。
    * **测试海外**：`curl -I https://www.google.com` (应该成功，且日志显示走代理)。
    * **测试容器内**：随意启动一个新容器 `docker run --rm alpine apk add curl && curl -I https://www.google.com`，无需任何配置即可走代理。

---

### 3. 注意事项 (权威提醒)

* **内核权限**：`cap_add: [NET_ADMIN]` 是必须的，否则容器无法创建 `utun` 网卡。
* **资源下载**：Mihomo 启动后会自动尝试下载 `Country.mmdb` 和 `geosite.dat` 规则库。如果你的服务器完全无法连接外网，请手动将这些文件下载并放入 `/opt/mihomo` 目录。
* **与现有代理冲突**：如果你之前执行过 `export http_proxy`，请运行 `unset http_proxy https_proxy all_proxy` 清除它们，因为 TUN 模式在网络层工作，不再需要环境变量。

这个配置能解决您“全局接管”且“智能分流”的需求。您需要我为您写一个简单的测试脚本，用来实时查看流量走的是直连还是代理吗？
