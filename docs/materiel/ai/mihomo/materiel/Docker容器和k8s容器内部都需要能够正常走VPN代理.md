在同时运行 Docker 和 Kubernetes (K8s) 的宿主机上开启全局 TUN 透明代理，在业界属于**高危操作**。如果配置不当，极易引发“集群脑裂”、“CoreDNS 瘫痪”或“Pod 网络黑洞”。

针对您的复杂环境，我对之前的配置进行了**深度重构**。这份配置基于 **Mihomo (Clash.Meta) 在 K8s 节点部署的最佳实践**，解决了虚拟网卡流量接管、内部 DNS 劫持冲突以及路由黑洞等核心痛点。

---

### 一、 深入分析：为什么之前的配置在 K8s/Docker 下会崩溃？

1. **致命误区：排除虚拟网卡 (`exclude-interface`)**
   * **错误做法**：之前建议排除 `docker0`、`cni0` 等网卡。
   * **真相**：如果在 Mihomo 中排除了这些虚拟网卡，容器发出的流量到达网桥后，**将直接被放行而不进入 TUN 虚拟网卡**。这会导致 Docker 和 K8s 容器**彻底无法走代理**。
   * **业界实践**：**必须放行所有虚拟网卡**，让流量进入宿主机路由表，然后通过**IP 级别的路由排除 (`route-exclude-address`)** 来保证内部通信直连，外部流量进入 TUN 被代理。
2. **DNS 劫持导致 CoreDNS 瘫痪**
   * **冲突点**：`dns-hijack: any:53` 会无差别劫持所有 53 端口流量。K8s Pod 解析内部服务时，目标是 CoreDNS (如 `10.96.0.10:53`)。如果被劫持，Mihomo 会去公网解析内部域名，导致失败。
   * **业界实践**：只要将 K8s 的 Service CIDR (`10.96.0.0/12`) 加入 `route-exclude-address`，去往 CoreDNS 的包在路由层就会被剔除，**根本不会进入 TUN 设备**，从而完美绕过 `dns-hijack` 的拦截。
3. **API Server 失联 (节点 NotReady)**
   * **冲突点**：Kubelet 需要与 API Server (通常是 6443 端口) 保持心跳。如果宿主机的物理 IP 或 API Server 的 IP 被 TUN 代理劫持，会导致心跳超时，K8s 节点状态变为 `NotReady`。

---

### 二、 业界生产级完整精简版配置 (K8s/Docker 深度融合版)

请直接使用以下配置，它已经最大程度精简了非必要参数，并对 K8s/Docker 进行了针对性加固。

```yaml
# ================= 基础配置 =================
mode: rule
allow-lan: true
bind-address: '127.0.0.1' # 保证 API 仅本地访问
mixed-port: 7890
log-level: info
ipv6: false

# ================= DNS 配置 =================
dns:
  enable: true
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  # [核心加固] 保护 K8s/Docker 内部服务发现域名，防止被分配 Fake-IP
  fake-ip-filter:
    - '*.lan'
    - '*.local'
    - '*.arpa'
    - '*.svc'               # K8s Service 简写
    - '*.svc.cluster.local' # K8s 内部完整域名
    - 'kubernetes.default'  # K8s 默认 API 域名
  respect-rules: true       # [生产必备] 让 DNS 解析严格遵循下方的 rules 分流规则
  
  nameserver:
    - https://doh.pub/dns-query
    - https://dns.alidns.com/dns-query
  proxy-server-nameserver:
    - https://doh.pub/dns-query

# ================= Sniffer (嗅探器) =================
sniffer:
  enable: true
  sniff:
    HTTP:
      ports: [80, 8080-8880]
      override-destination: true
    TLS:
      ports: [443, 8443]

# ================= TUN 模式配置 (核心重构区) =================
tun:
  enable: true
  stack: gvisor # [生产必备] 彻底解决 system 栈在复杂网络下的日志刷屏问题
  auto-route: true
  auto-detect-interface: true
  strict-route: false 
  
  dns-hijack:
    - "any:53" # 配合下方的 route-exclude-address，实现“外网劫持，内网放行”
    
  # [严重警告] 绝对不要排除 docker0, cni0 等虚拟网卡！否则容器将无法走代理！
  # exclude-interface: 
  
  route-exclude-address:
    # 1. 常规私有网段直连
    - 127.0.0.0/8
    - 10.0.0.0/8
    - 172.16.0.0/12
    - 192.168.0.0/16
    - 100.64.0.0/10
    
    # 2. [K8s 专属] 必须根据您的集群实际情况修改以下 CIDR！
    # 如果不加，Pod 之间互访、Pod 访问 CoreDNS 将被代理或丢弃，导致集群瘫痪
    - 10.244.0.0/16  # TODO: 替换为您的 K8s Pod CIDR (Flannel/Calico 默认)
    - 10.96.0.0/12   # TODO: 替换为您的 K8s Service CIDR (ClusterIP 网段)
    
    # 3. [宿主机保护] 防止 Kubelet 访问 API Server 被代理
    # 如果您的 K8s API Server 暴露在公网 IP，请务必将宿主机公网 IP 加入此处
    # - <您的宿主机公网IP>/32 

# ================= 代理节点 =================
proxies:
  - name: "Gateway-Proxy"
    type: http
    server: mbp-fa.xxx.xxx # TODO: 替换为您的实际服务器
    port: 9090             # TODO: 替换为您的实际端口

# ================= 分流策略组 =================
proxy-groups:
  - name: "GLOBAL-ROUTER"
    type: select
    proxies:
      - "Gateway-Proxy"
      - DIRECT

# ================= 分流规则 =================
rules:
  # 1. 局域网与内部网络防回环直连 (最高优先级)
  - IP-CIDR,127.0.0.0/8,DIRECT,no-resolve
  - IP-CIDR,10.0.0.0/8,DIRECT,no-resolve
  - IP-CIDR,172.16.0.0/12,DIRECT,no-resolve
  - IP-CIDR,192.168.0.0/16,DIRECT,no-resolve
  - IP-CIDR,100.64.0.0/10,DIRECT,no-resolve
  
  # 2. [K8s 专属] 内部域名强制直连
  - DOMAIN-SUFFIX,cluster.local,DIRECT
  - DOMAIN-SUFFIX,svc,DIRECT
  - DOMAIN-KEYWORD,kubernetes,DIRECT

  # 3. 常规防泄漏与 GeoIP 规则
  - IP-CIDR,224.0.0.0/4,REJECT,no-resolve
  - IP-CIDR6,::1/128,DIRECT,no-resolve
  - IP-CIDR6,fc00::/7,DIRECT,no-resolve
  - IP-CIDR6,fe80::/10,DIRECT,no-resolve
  - IP-CIDR6,fd00::/8,DIRECT,no-resolve
  - GEOIP,private,DIRECT,no-resolve
  
  # 4. 中国大陆直连
  - GEOSITE,cn,DIRECT
  - GEOIP,cn,DIRECT
  
  # 5. 兜底规则：剩余所有流量（海外）走代理
  - MATCH,GLOBAL-ROUTER
```

---

### 三、 部署与验证指南 (业界避坑标准流程)

#### 1. 获取真实的 K8s CIDR (必做)
配置中的 `10.244.0.0/16` 和 `10.96.0.0/12` 是默认值。您必须在宿主机上执行以下命令，获取您集群**真实的网段**，并替换到 `route-exclude-address` 中：

*   **获取 Pod CIDR**:
    ```bash
    kubectl cluster-info dump | grep -m 1 cluster-cidr
    # 或者查看 node 的 podCIDR: kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
    ```
*   **获取 Service CIDR**:
    ```bash
    kubectl get svc kubernetes -o jsonpath='{.spec.clusterIP}'
    # 假设输出 10.96.0.1，则网段通常为 10.96.0.0/12 或 10.96.0.0/16
    ```

#### 2. Docker 容器的 DNS 行为说明
开启此配置后，Docker 容器内部的 `/etc/resolv.conf` 通常指向 `127.0.0.11` (Docker 内部 DNS) 或宿主机 IP。
*   当容器发起外部域名（如 `google.com`）解析时，请求会被 TUN 的 `dns-hijack` 拦截，并由 Mihomo 的 DoH (`doh.pub`) 解析，**彻底杜绝 DNS 污染**。
*   当容器访问内部服务时，因为 IP 在 `route-exclude-address` 中，请求走宿主机本地路由，**不受 Mihomo 影响**。

#### 3. 验证流量是否成功接管
在 Docker 容器或 K8s Pod 内部执行以下命令测试：
```bash
# 测试外部代理是否生效 (应返回代理节点的 IP)
curl -I https://ipinfo.io

# 测试内部 K8s 服务是否正常 (以 CoreDNS 为例，应正常返回)
nslookup kubernetes.default.svc.cluster.local
```