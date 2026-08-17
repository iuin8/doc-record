# kasm

```bash
# 调整 K8s 节点内核参数（防崩溃，必做！）
# 临时生效
sudo sysctl -w fs.inotify.max_user_watches=1048576
sudo sysctl -w fs.inotify.max_user_instances=1024

# 永久固化（防止重启失效）
cat <<EOF | sudo tee /etc/sysctl.d/99-kasm-inotify.conf
fs.inotify.max_user_watches=1048576
fs.inotify.max_user_instances=1024
EOF
sudo sysctl --system

# 生成内网自签证书并注入 K8s
# 1. 创建命名空间
kubectl create namespace kasm-prod

# 2. 生成自签证书(把 kasm.local 换成你实际想用的内网域名或 IP，把 10.68.85.58 换成你 Ingress 的内网 IP)
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=kasm.local" \
  -addext "subjectAltName=DNS:kasm.local,IP:10.68.85.58"

# 3. 注入 K8s (名字必须和下面 values 里的一致)
kubectl create secret tls kasm-prod-auto-tls \
  --cert=tls.crt --key=tls.key \
  -n kasm-prod

# 编写生产级 values-prod.yaml（纯内置 DB 版）
# ⚠️ 请仔细修改带有 【必改】 的 3 个地方。

# 一键部署 Local Path Provisioner
# 1. 部署 Local Path Provisioner（自动创建 StorageClass）
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.31/deploy/local-path-storage.yaml
# 2. 验证 StorageClass 是否创建成功
kubectl get storageclass
# 设置为集群的默认 StorageClass。这样，所有没指定存储类的 PVC（包括这个 Guac 的 tmp-data）都会自动使用它。
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# 一键安装（给足 15 分钟耐心  --wait --timeout 15m）
helm install kasm-prod kasmweb/kasm-helm \
  -n kasm-prod \
  -f values-prod.yaml

# 盯紧 Pod 状态：
watch kubectl get pods -n kasm-prod

# 提取管理员密码：
kubectl get secret --namespace kasm-prod kasm-prod-secrets -o jsonpath="{.data.admin-password}" | base64 -d; echo

# 浏览器登录：
# 访问：https://kasm.local (记得在内网电脑 hosts 里加上 Ingress IP kasm.local)
# 账号：admin@kasm.local
# 密码：上面提取的密码
# (浏览器提示不安全时，盲打 thisisunsafe 或点击“继续前往”)
# 4. 解决内网 WebRTC 黑屏（必做）：
# 登录后，点击左侧 Admin -> Settings -> Server，往下滚动找到 WebRTC 设置项，将 "Enable WebRTC" 取消勾选（或开启 WebRTC Fallback）。保存后，重新打开 Ubuntu 桌面，画面瞬间丝滑出现！
```
