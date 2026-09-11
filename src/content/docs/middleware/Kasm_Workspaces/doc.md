# Kasm Workspaces使用记录

官方开源组织地址：https://github.com/kasmtech

控制面板与编排引擎：其管理后台、用户认证和容器调度模块本身是闭源的。但官方提供了完全免费的 [Community Edition (社区版)](https://kasm.com/community-edition)，支持高达 5 个并发会话，这对于个人和小型团队运维完全够用。

第三方维护的纯 Docker 开源一键部署地址（极力推荐）：由知名开源社区 LinuxServer 维护的 [linuxserver/docker-kasm](https://github.com/linuxserver/docker-kasm)，可以绕过官方复杂的安装包，直接用容器部署。

用 [Kasm 1.19 官方主推的 Kubernetes (Helm Chart) 生产级架构](https://kasm.com/kasm-insights/no-slug-32)

## Kasm 官方 K8s 部署核心步骤

在开始前，请确保你已有现成的 K8s 集群（建议版本 ≥ 1.26），并且本地已安装 Helm 3。

> 「Agent 节点不能包含在 Helm Chart 中」：Helm 部署仅负责拉起控制平面（App 核心、Connection Proxy 网关等）。用户秒开的 Linux/Windows 虚拟桌面（会话）必须运行在 K8s 集群之外的独立 Docker 物理机或虚拟机上（即 Agent 角色）。这是为了防止图形流编码、重度嵌套容器（DinD）抢占 K8s 核心节点的网络和 CPU 资源。

```bash
helm repo add kasmtech https://helm.kasmweb.com
helm repo update

# WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/.kube/config
# WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /root/.kube/config
# 限制 K8s 配置文件权限，消除系统安全警告, 仅 root 独占（业界生产安全审计等保必查项）
chmod 600 /root/.kube/config

# 在 /data/k8s/kasm-workspaces 目录下创建并编辑你的企业级配置文件：
nano /data/k8s/kasm-workspaces/values-production.yaml

# 创建独立的、强隔离的命名空间：
kubectl create namespace kasm-mgmt
```

```bash
# 1. 确保创建了目标命名空间
kubectl create namespace kasm-mgmt --dry-run=client -o yaml | kubectl apply -f -

#💡 测试环境临时自签命令：如果是内网测试没有自备证书，请先在当前目录下执行以下命令快速生成证书文件
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout kasm.key -out kasm.crt -subj "/CN=kasm.yourcompany.local"

# 2. 为三个网关组件分别创建对应的 K8s Secret 凭据（这会直接满足报错中 "Required value" 的校验要求）
kubectl create secret tls kasm-prod-rdp-gw-cert --cert=kasm.crt --key=kasm.key -n kasm-mgmt
kubectl create secret tls kasm-prod-proxy-cert --cert=kasm.crt --key=kasm.key -n kasm-mgmt
kubectl create secret tls kasm-prod-rdp-https-gw-cert --cert=kasm.crt --key=kasm.key -n kasm-mgmt
# kubectl delete secret kasm-prod-rdp-gw-cert kasm-prod-rdp-https-gw-cert kasm-prod-proxy-cert -n kasm-mgmt 2>/dev/null

```

```bash
# 运行 Helm 进行基于 K8s 架构的无缝安装：
helm install kasm-prod kasmtech/kasm -n kasm-mgmt -f /data/k8s/kasm-workspaces/values-production.yaml   --set kasmApp.proxy.ssl=false --set kasmApp.rdpGw.ssl=false --set kasmApp.rdpHttpsGw.ssl=false
# 1. 如果上次有残留，先彻底清除旧实例
# helm uninstall kasm-prod -n kasm-mgmt 2>/dev/null

# 检查控制面运行状态：
kubectl get pods -n kasm-mgmt -w
## 等待 kasm-api 和 kasm-proxy 等关键 Pod 的状态全部转为 Running。
```

```bash
# 彻底卸载并清除残留的 Release 状态
# 1. 彻底卸载已有的 kasm-prod 实例（释放名称占用）
helm uninstall kasm-prod -n kasm-mgmt

# 2. 验证是否已经彻底清除（确保返回结果中没有 kasm-prod）
helm list -n kasm-mgmt

```


## 第二版


```bash

# 一键安装 Cert-Manager（若已安装可跳过）：
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
# 等待 cert-manager 核心组件就绪
kubectl wait --for=condition=Available deployment --all -n cert-manager --timeout=120s

# 创建生产级 ClusterIssuer（签发证书的机构）：
# 新建 issuer.yaml，复制以下内容（修改邮箱和 Ingress Class），然后执行 
kubectl apply -f issuer.yaml


# 一键执行 Helm 安装
# 1. 创建专属命名空间
kubectl create namespace kasm-prod

# 创建 PostgreSQL 密码 Secret：
# 将 '你的PG密码' 替换为实际密码
kubectl create secret generic kasm-pg-secret --from-literal=password='你的PG密码' -n kasm-prod
# 创建 Redis 密码 Secret（如果 Redis 无密码可跳过）：
# 将 '你的Redis密码' 替换为实际密码
kubectl create secret generic kasm-redis-secret --from-literal=password='你的Redis密码' -n kasm-prod

# 生成生产级 values-prod.yaml
# 新建 values-prod.yaml，复制以下经过官方 Schema 校验的结构。⚠️ 请仔细修改带有 【必改】 的 5 个地方。

# 2. 添加/更新官方仓库
helm repo add kasmweb https://helm.kasm.com
helm repo update
# 3. 执行安装 (加入 --wait 确保所有组件和证书都 Ready, 但是默认只等5分钟, 直接后续看更方便了)
helm install kasm-prod kasmweb/kasm-helm -n kasm-prod --create-namespace -f values-prod.yaml
```

内网走自签证书

```bash
# 1. 生成自签证书
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=xxx.iuin.dev" -addext "subjectAltName=DNS:xxx.iuin.dev"

# 2. 覆盖写入 Secret
kubectl create secret tls kasm-prod-auto-tls --cert=tls.crt --key=tls.key -n kasm-prod  --dry-run=client -o yaml | kubectl apply -f -

# 3. 触发 Helm 更新：
helm upgrade kasm-prod kasmweb/kasm-helm -n kasm-prod -f values-prod.yaml
```

```bash
# 生产级验证与排错（SOP 闭环）
# 验证证书是否自动签发成功：
# 如果证书卡住，Kasm 的 Pod 会因为挂载不到 Secret 而一直 Pending 或 CreateContainerConfigError。
# 查看 Certificate 状态，READY 必须为 True
kubectl get certificate -n kasm-prod
# 如果 READY 为 False，查看 Cert-Manager 日志排错：
kubectl logs -n cert-manager deployment/cert-manager-webhook --tail=50

# 2. 验证外部 PG 连接：
# 查看 Kasm 的 API 或 DB 初始化日志，确认没有 Connection Refused 或 Authentication Failed。
kubectl logs -n kasm-prod -l app=kasm-api --tail=100 | grep -i "database"

# 获取初始管理员密码：
# 由于剥离了内置 DB，Kasm 初始化完成后，Admin 密码通常会打印在初始化 Job 中，或存入 Secret。
# 查看初始化日志获取密码
kubectl logs -n kasm-prod job/kasm-prod-db-init-job | grep -i "password"
# 或者从 Secret 中提取 (Key 名称可能因版本微调，通常为 admin_password)
kubectl get secret kasm-secrets -n kasm-prod -o jsonpath="{.data.admin_password}" | base64 --decode
```

排查

```bash
# 查看 Certificate 资源的状态
kubectl get certificate -n kasm-prod
# 查看详细的失败原因：
kubectl describe certificate kasm-prod-auto-tls -n kasm-prod
kubectl describe certificate kasm-prod-cert-manager -n kasm-prod
# 检查 ClusterIssuer 是否就绪：
kubectl get clusterissuer letsencrypt-prod
# 查看底层的 Order (订单) 状态（最准确）：
kubectl get order -n kasm-prod
# 拿到上面输出的那个 order 名字后，执行 describe：
kubectl describe order <替换为上面查到的order名字> -n kasm-prod

# 清理卡死的旧证书订单（重要！）
# 删除卡住的 Certificate 资源 (它会自动重建)
kubectl delete certificate kasm-prod-cert-manager -n kasm-prod
# 删除残留的失败 Order
kubectl delete order --all -n kasm-prod

# 重新执行 Helm 升级(--wait --timeout 15m)
helm upgrade kasm-prod kasmweb/kasm-helm -n kasm-prod -f values-prod.yaml
```

清理旧环境并重新部署

```bash
# 1. 彻底删除旧环境
helm uninstall kasm-prod -n kasm-prod
kubectl delete namespace kasm-prod

# 2. 重新创建命名空间
kubectl create namespace kasm-prod

# 3. 重新注入刚才的两个 Secret (超管密码和证书)
# (请重新执行第一步中的 kubectl create secret 命令，因为 namespace 被删了)

# 4. 终极安装 (加入 --timeout 15m 等待自动建表完成)
helm install kasm-prod kasmweb/kasm-helm -n kasm-prod -f values-prod.yaml
```

## ⚠️ 内网自签证书的“致命隐藏坑”（必看！）

在内网使用自签证书访问 Kasm 时，极大概率会遇到 “登录成功，但打开 Ubuntu 桌面时一直黑屏或提示 Connection Failed”。
原因：Kasm 的 VNC 桌面强依赖 WebRTC 技术。现代浏览器（Chrome/Edge）对自签证书的安全策略极其严格，会默默拦截 WebRTC 的 UDP 数据流，导致画面传不过来。

终极解决办法（二选一）：
方法 1：浏览器“物理”放行（最简单）
在访问 Kasm 的那个 Chrome/Edge 标签页中，不要动鼠标，直接用键盘盲打输入以下这串字母（输入时屏幕上不会有显示）：

```bash
thisisunsafe
# 敲完后，页面会自动刷新，WebRTC 就会被放行，桌面瞬间就能出来了！
```

方法 2：在 Kasm 后台关闭 WebRTC 强制要求（一劳永逸）

用 admin 账号登录 Kasm 后台。
左侧菜单导航到 Admin -> Settings -> Server。
找到 WebRTC 相关的选项，将 WebRTC Fallback 开启，或者直接禁用 WebRTC（Disable WebRTC）。
这样 Kasm 就会降级使用普通的 WebSocket 传输画面，虽然延迟比 WebRTC 高几毫秒，但在内网自签证书下绝对稳定，永不黑屏。


## 看到 failed to create fsnotify watcher: too many open files 这个报错，是 K8s 节点（宿主机 Linux 内核）的文件监控句柄（inotify）被耗尽了！

```bash
# 临时生效（立刻解决崩溃）
sudo sysctl -w fs.inotify.max_user_watches=1048576
sudo sysctl -w fs.inotify.max_user_instances=1024
```

```bash
# 永久固化（防止重启后失效）
cat <<EOF | sudo tee /etc/sysctl.d/99-kasm-inotify.conf
fs.inotify.max_user_watches=1048576
fs.inotify.max_user_instances=1024
EOF

# 重新加载系统配置
sudo sysctl --system

# 重启 Kasm Pod（让它重新读取新内核参数）
# 强制重启 kasm-prod 命名空间下的所有 Deployment 和 StatefulSet
kubectl rollout restart deploy -n kasm-prod
kubectl rollout restart statefulset -n kasm-prod
```
