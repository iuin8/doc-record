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

# 1. 写一个“服务器证书”专用配置
cat > kasm-server.cnf <<'EOF'
[req]
distinguished_name = dn
prompt = no
x509_extensions = v3_ext
[dn]
CN = kasm.local
[v3_ext]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = DNS:kasm.local, IP:10.0.5.167
EOF

# 2. 生成新证书（覆盖旧的 tls.key / tls.crt）
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt -config kasm-server.cnf

# 3. 验证扩展（必须看到 CA:FALSE、Digital Signature、TLS Web Server Authentication）
openssl x509 -in tls.crt -noout -text | grep -A1 "Key Usage\|Basic Constraints"

# 热替换 K8s 里的 TLS Secret
kubectl create secret tls kasm-prod-auto-tls \
  --cert=tls.crt --key=tls.key \
  -n kasm-prod \
  --dry-run=client -o yaml | kubectl apply -f -

# ingress-nginx 会自动监听 Secret 变化并热加载，无需重启。如果 10 秒后还不生效，执行 `kubectl rollout restart deploy -n ingress-nginx ingress-nginx-controller-nginx`。

# 在 Mac 上验证新证书已生效
openssl s_client -connect 10.0.5.167:32743 -servername kasm.local </dev/null 2>/dev/null | openssl x509 -noout -text | grep -A1 "Key Usage"
# 确认输出里是 Digital Signature, Key Encipherment，而不是 Certificate Sign。


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

## 让 Ingress 控制器直接“霸占” K8s 节点的 80/443 端口。

```bash
# 确认节点 443 端口未被占用
sudo ss -tlnp | grep -E ':80|:443'

# 开启 Ingress 的 hostNetwork（一键执行）
# 1. 确保 Ingress 只有 1 个 Pod (防止两个 Pod 在同一个节点抢 443 端口导致崩溃)
kubectl scale deploy ingress-nginx-controller-nginx -n ingress-nginx --replicas=1

# 2. 开启 hostNetwork 并修正 DNS 策略
kubectl patch deploy ingress-nginx-controller-nginx -n ingress-nginx --type=json -p='[
  {"op":"add","path":"/spec/template/spec/hostNetwork","value":true},
  {"op":"add","path":"/spec/template/spec/dnsPolicy","value":"ClusterFirstWithHostNet"}
]'
```
