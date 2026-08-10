---
 sidebar_position: 2
---

# nsenter

Linux namespace 穿透工具，以**指定进程的命名空间上下文**执行任意命令。在容器化和 Kubernetes 运维中，它是"不通过网络、直接潜入目标环境"的核心工具。

## 背景：为什么需要 nsenter

Linux 容器（Docker、Kubernetes Pod）的本质是**被 Namespace 隔离的普通进程**。每个容器拥有独立的：

| Namespace | 隔离内容 | 容器视角 |
|-----------|---------|---------|
| `net` | 网络栈 | 只能看到自己的虚拟网卡、路由表 |
| `pid` | 进程树 | 容器内 PID 1 是"唯一"的根进程 |
| `mnt` | 挂载点 | 只能看到自己的根文件系统 |
| `uts` | 主机名 | 容器有自己的 hostname |
| `ipc` | 进程间通信 | 独立的消息队列、共享内存 |

当需要绕过网络层（SSH、kubectl exec）直接进入某个容器或宿主机环境时，`nsenter` 是唯一手段。

## 核心参数

```bash
nsenter [options] [program [args...]]
```

| 参数 | 全称 | 作用 |
|------|------|------|
| `-t <pid>` | `--target` | **必选。** 目标进程 PID |
| `-m` | `--mount` | 进入目标进程的挂载命名空间（**决定用谁的 `/`、用谁的命令**） |
| `-n` | `--net` | 进入目标进程的网络命名空间 |
| `-p` | `--pid` | 进入目标进程的 PID 命名空间（看到目标的进程树） |
| `-u` | `--uts` | 进入目标进程的 UTS 命名空间（使用目标的主机名） |
| `-i` | `--ipc` | 进入目标进程的 IPC 命名空间 |
| `-a` | `--all` | 进入所有命名空间（等价于 `-m -n -p -u -i`） |

## `-m` 参数：命令来源的"分水岭"

所有 namespace 参数中，**`-m` 是唯一决定"你敲的命令来自哪里"的参数**：

- **加了 `-m`**：根目录切换到目标的 `/`，所有命令二进制来自**目标环境**（宿主机或目标容器）。
- **不加 `-m`**：根目录留在当前环境，命令二进制来自**当前环境**，但其他 namespace（网络、PID 等）已切换到目标。

这个区别决定了：你是"用目标的刀，砍目标的柴"，还是"借自己的刀，砍目标的柴"。

## 参数组合对照表

| 命令 | 命令来源 | 文件系统 | 网络栈 | 典型场景 |
|------|---------|---------|--------|---------|
| `nsenter -t 1 -a` | 📂 宿主机 | 宿主机 `/` | 宿主机 | 接管宿主机：重启 kubelet、查系统日志 |
| `nsenter -t 1 -n` | 🐳 当前容器 | 当前容器 `/` | 宿主机 | 宿主机没装诊断工具，借用容器工具抓宿主机网卡的包 |
| `nsenter -t $PID -n` | 📂 宿主机 | 宿主机 | 目标容器 | 用宿主机 tcpdump 抓精简容器的网络流量 |
| `nsenter -t $PID -m` | 🐳 目标容器 | 目标容器 `/` | 当前环境 | 查看/修改容器内文件 |

> **记忆口诀**：`-m` 决定"命令从哪来"，`-n` 决定"网从哪走"，两者独立。

## 工作原理：Kuboard Node-Shell 示例

Kuboard 的 "node-shell" 功能完整展示了 `nsenter` 的生产级用法。其前置条件是一个特权 Pod：

```yaml
spec:
  hostPID: true        # 容器内可见宿主机所有进程
  privileged: true     # 特权模式，允许 namespace 切换
```

Kuboard 在 Pod 内部执行的核心命令：

```bash
nsenter --target 1 --mount --uts --ipc --net --pid
```

逐项拆解：

1. **`--target 1`**：指向宿主机 PID 1（systemd / init），它持有宿主机所有 namespace
2. **`--mount`** 🗝️：切换到宿主机根文件系统 —— 从此敲的命令全是宿主机二进制
3. **`--net`**：获得宿主机网络栈（`ip addr` 看到物理网卡）
4. **`--pid`**：获得宿主机进程树（`ps aux` 看到所有进程）
5. 执行后，终端从"容器内部"瞬间变为"宿主机 root shell"

## 常用场景

### 场景一：全量穿透 —— 从容器接管宿主机

宿主机 SSH 不可用，通过集群中已有的特权 Pod 直接接管：

```bash
# 在特权 Pod 内执行
nsenter -t 1 -a bash

# 此时所有命令来自宿主机，可执行：
systemctl restart kubelet
journalctl -u kubelet -f
ip addr show
cat /var/log/messages
```

### 场景二：精细穿透 —— 借用容器工具诊断宿主机网络

生产宿主机常是精简系统（CoreOS、Talos、安全加固的 Linux），宿主机层连 `tcpdump`、`curl` 都没有。此时**不加 `-m`、只加 `-n`**，用容器的工具去解剖宿主机网络：

```bash
# 在 netshoot 等工具丰富的 Pod 内执行
# 注意：没有 -m！文件系统还在容器，但网络栈已切到宿主机
nsenter -t 1 -n

# 敲下 tcpdump —— 调用的是容器自带的 tcpdump
# 但它抓取的是宿主机 eth0 网卡上的真实物理流量
tcpdump -i eth0 -w /tmp/host.pcap

# 其他容器自带、宿主机缺失的工具同样可用：
curl -v https://<api-endpoint>
ip route show
ss -tlnp
```

### 场景三：从宿主机进入容器网络抓包

反向操作：生产容器（distroless、alpine 精简版）缺失 `tcpdump`。从宿主机用 `-n` 进入容器网络，借用宿主机工具：

```bash
CONTAINER_PID=$(crictl inspect <container-id> | jq -r '.info.pid')
# 用宿主机 tcpdump，抓容器 eth0 的流量
nsenter -t $CONTAINER_PID -n tcpdump -i eth0 -w /tmp/container.pcap
```

### 场景四：从宿主机操作容器文件

```bash
nsenter -t $CONTAINER_PID -m ls /app/config
nsenter -t $CONTAINER_PID -m cat /app/logs/error.log
```

## 注意事项

1. **`-m` 是分水岭**：新手最容易踩的坑 —— 以为进了目标环境，结果忘了加 `-m`，敲的命令还是当前环境的。
2. **需要 `CAP_SYS_ADMIN`**：常规容器默认不具备，需配合 `privileged: true` 或特定 `securityContext`。
3. **`--target` 必须准确**：目标 PID 错误会导致进入错误的 namespace 上下文。
4. **非持久化**：`nsenter` 只在命令执行期间生效，退出后 shell 回到原有上下文。
5. **镜像选择**：如果是"精细穿透"场景（不加 `-m`），镜像必须自带诊断工具（推荐 `nicolaka/netshoot`）；如果是"全量穿透"场景（加 `-m`），工具依赖宿主机，镜像用 `alpine` 足够。

## 相关命令

- `unshare`：反向操作，从父命名空间中"脱离"，创建新的独立命名空间
- `lsns`：列出当前系统中所有命名空间
- `ip netns`：管理网络命名空间（底层也基于 namespace 机制）
