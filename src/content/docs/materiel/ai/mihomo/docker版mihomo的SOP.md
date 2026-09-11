# docker版mihomo的SOP

可以。**Mihomo 完全支持以 Docker 方式运行，并且可以控制宿主机全局走 TUN 虚拟网卡。**

根据 Mihomo 官方文档和 Docker 网络驱动的最佳实践，要实现“Docker 运行 + 宿主机全局代理”，关键点在于：**必须使用 `host` 网络模式**，并赋予容器**网络管理权限**。



### 1. 核心原理
当 Docker 容器使用 `--network host` 时，它不再拥有独立的网络命名空间，而是直接共享宿主机的网卡和路由表。配合 `cap_add: NET_ADMIN`，容器内的 Mihomo 进程就有权限在宿主机内核中创建 `utun` 设备并修改系统路由，从而实现全局接管。

---

### 2. Docker Compose SOP（权威推荐方案）

这是最优雅的部署方式。请在您的服务器新建一个目录（如 `/opt/mihomo`），准备以下两个文件：

#### A. `docker-compose.yaml`
```yaml
services:
  mihomo:
    image: metacubex/mihomo:latest
    container_name: mihomo
    restart: always
    # 关键点 1：共享宿主机网络栈
    network_mode: "host"
    # 关键点 2：赋予创建虚拟网卡和修改路由的权限
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    volumes:
      - ./config.yaml:/root/.config/mihomo/config.yaml
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
```

#### B. `config.yaml` (根据您的代理地址转换)
将您之前的代理信息直接写入 `proxies` 节点。

```yaml
mixed-port: 7890
allow-lan: true
log-level: info
ipv6: false

dns:
  enable: true
  enhanced-mode: fake-ip
  nameserver:
    - 223.5.5.5
    - 119.29.29.29

# 关键：开启 TUN 模式接管宿主机全局
tun:
  enable: true
  stack: system        # 官方推荐 Linux 使用 system 栈
  auto-route: true     # 核心：自动修改宿主机路由表实现全局代理
  auto-detect-interface: true
  dns-hijack:
    - "any:53"

proxies:
  - name: "Your-Gateway-Proxy"
    type: http         # 您提供的 http_proxy 对应类型
    server: 10.0.4.95
    port: 7897

proxy-groups:
  - name: "MATCH"
    type: select
    proxies:
      - "Your-Gateway-Proxy"
      - DIRECT

rules:
  - MATCH,MATCH        # 所有流量走代理
```

---

### 3. 使用步骤 (SOP)

1.  **准备环境**：
    确保宿主机已安装 Docker 和 Docker Compose。
2.  **创建文件**：
    将上述两个文件放在同一个文件夹下。
3.  **启动容器**：
    ```bash
    sudo docker compose up -d
    ```
4.  **验证生效**：
    * **查看网卡**：执行 `ip addr`，如果看到 `utun` 或 `mihomo0` 类似的网卡，说明 TUN 已启动。
    * **验证流量**：直接在宿主机执行 `curl -I https://www.google.com`。
    * **验证容器**：启动一个新容器 `docker run --rm alpine curl -I https://www.google.com`，由于宿主机路由已被接管，该容器流量也会自动走代理。

---

### 4. 为什么这个方案比 `export` 更好？

* **真正的全局**：`export` 只能覆盖支持环境变量的应用。TUN 模式覆盖内核路由，无论是 `git`、`apt`、`docker pull` 还是容器内的流量，全部自动生效。
* **无感透传**：容器不需要任何额外配置。
* **一键管理**：通过 `docker compose stop` 停止容器后，Mihomo 会自动清理宿主机路由，网络立即恢复原样，不会残留垃圾配置。

**需要我为您检查一下您的 10.0.4.95 代理是否支持 UDP 流量（这会影响 TUN 模式下的某些应用体验）吗？**
