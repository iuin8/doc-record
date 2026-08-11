# mihomo docker 配置

> 宿主机, Docker容器和k8s容器内部都能够正常走代理访问国外网络的通用版本

- 临时使用: 可以让内网服务器访问国外的流量代理到同局域网的本地电脑(本地电脑当代理节点, 需开启局域网连接)中来, 本地电脑开tun走clash去访问国外网络
- 长期使用: 节点需要部署到公网服务器中了, 或者走隧道访问内网节点等

## 注意⚠️: 可能得考虑k8s本身的cni网络是否兼容tun虚拟网卡的情况

**对照下表 CNI 做参考：**

| 看到的 DaemonSet 名称 | 对应的 CNI 插件 | 对 TUN 模式的兼容性 |
| :--- | :--- | :--- |
| `kube-flannel-ds` / `kube-flannel` | **Flannel** | ⭐⭐⭐⭐⭐ **极好**（默认使用 VXLAN/HostGW，流量走主路由表，完美兼容 TUN） |
| `calico-node` | **Calico** | ⭐⭐⭐ **视模式而定**（如果是 IPIP/VXLAN 模式兼容较好；如果是 BGP 纯路由模式也兼容；但如果是 eBPF 模式则不兼容） |
| `cilium` | **Cilium** | ❌ **不兼容**（默认使用 eBPF 绕过内核路由表，TUN 无法拦截） |
| `kube-ovn-cni` | **Kube-OVN** | ⭐⭐⭐⭐ **很好**（类似 Flannel，通常兼容 TUN） |
| `weave-net` | **Weave** | ⭐⭐⭐⭐ **较好** |
| `canal` | **Canal** (Flannel+Calico) | ⭐⭐⭐⭐ **较好** |
| `kube-router` | **Kube-router** | ⭐⭐⭐⭐ **较好** |

*(注： **KubeKey / KubeSphere** 默认安装时, 使用的是 **Calico** 或 **Flannel** 网段。)*
