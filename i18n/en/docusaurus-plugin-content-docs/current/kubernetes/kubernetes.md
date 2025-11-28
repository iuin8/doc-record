# k8s Related Usage

## k8 installation

### Install via `KubeKey`

[kubekey](https://github.com/kubesphere/kubekey)

```bash
# 	Kubernetes 版本 ≥ 1.18
# socat	必须安装
# conntrack	必须安装
# 验证: socat -V && conntrack --version
sudo apt install socat conntrack -y


# 使用脚本获取 KubeKey
export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | sh -
# 创建集群(快速开始)
export KKZONE=cn
# ./kk create cluster [--with-kubernetes version] [--with-kubesphere version]
# 使用默认版本创建一个纯 Kubernetes 集群
./kk create cluster
# 创建一个部署了 KubeSphere 的 Kubernetes 集群 （例如 --with-kubesphere v3.1.0）
./kk create cluster --with-kubesphere
# 使用配置文件创建集群
./kk create cluster -f ~/myfolder/config-sample.yaml


# Console: http://10.0.16.146:30880
# Account: admin
# Password: P@88w0rd

# Please check the result using the command:
kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f


# 删除集群
./kk delete cluster
# 有时候可能还需要主动删除这个文件夹
rm -rf /etc/kubernetes/
```

#### Problem

```bash
# FATA[0000] validate service connection: validate CRI v1 image API for endpoint "unix:/run/containerd/containerd.sock": rpc error: code = Unimplemented desc = unknown service runtime.v1. mageService: Process Excludes with status 1

vi /etc/containerd/config. oml

# disabled_plugins = []# Ensure CRI
# Restart Containerd：
sudo systemctl start containerd


## /etc/etc/etc/etcd. nv (this file may need to be created manually) (file in the current document directory)

# Certification question
sudo mkdir -p /etc/ssl/certs
sudo chmod 755 /etc/ssl/certs
apt update && sudo apt install ca-certificates
sudo update-ca-certificates
## if docker is used, then you may need to restart docker (systemctl start docker)
```

### Install via `RKE`

[官方文档](https://docs.rancher.cn/docs/rke/example-yamls/_index)

### Install via `KuboardSprey`

[官网地址](https://kuboard-spray.cn/)

```bash
# 进入指定目录
cd /data/docker/k8s
# 快速安装
docker run -d \
  --dns=223.5.5.5 \
  --privileged \
  --restart=unless-stopped \
  --name=kuboard-spray \
  -p 80:80/tcp \
  -e TZ=Asia/Shanghai \
  -e https_proxy=http://10.0.16.17:7890 \
  -e http_proxy=http://10.0.16.17:7890 \
  -e all_proxy=socks5://10.0.16.17:7890 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/kuboard-spray-data:/data \
  eipwork/kuboard-spray:latest-amd64
# 在浏览器地址栏中输入 http://这台机器的IP地址，输入用户名 admin，默认密码 Kuboard123
docker run -d \
  --dns=223.5.5.5 \
  --privileged \
  --restart=unless-stopped \
  --name=kuboard-spray \
  -p 80:80/tcp \
  -e TZ=Asia/Shanghai \
  -v /var/run/docker.sock:/var/run/docker.sock \
  eipwork/kuboard-spray:latest-amd64
```

### yum installation k8s

- [文档详情地址](./docs/temp/yum安装k8s.md) (PS: AI, has not yet been tested)

## helm command

```bash
# Install
brew install helm

# Use

# to install
help install my-release skywalking -n <namespace>
# View list
helm list
# Uninstall
$ help uninstall my-release -n <namespace>
```

## minikube

```bash
# Installation (needs to be re-on docker)
curl -LO https://storage.googleapis. om/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
# please note that this method will continue to run minikebe with root mission, But it may pose security risks because the "docker" driver should not be used as root.
minikbe start-force
# Dashboard
minikuku dashboard
```

## kuboard visualization interface

- [也可以使用helm方式部署](./kuboard/doc.md)
- Docker installation

```bash
# KUBOARD_ENDPOINT="http://内网IP:80"
docker run -d \
  --restart=unless-stopped \
  --name=kuboard \
  -p 80:80/tcp \
  -p 10081:10081/tcp \
  -e KUBOARD_ENDPOINT="http://10.0.16.17:80" \
  -e KUBOARD_AGENT_SERVER_TCP_PORT="10081" \
  -v /root/kuboard-data:/data \
  eipwork/kuboard:v3
```

- kubtl installation

```bash
# Employment
kubectl app -f https://addons.kuboard.cn/kuboard/kuboard-v3.yaml
# See
kubectl get Methods -n kuboard
Uninstall #
kubectl ete -f https://addons. uboard.cn/kuboard-v3.yaml
  # Cleanup legacy
    # in master node and k8s.kuboard. n/role=etcd tag executes
rm -rf /usr/share/kuboard

---

## FAQ
# View Node
kubectl get nodes
# Headed
kubtl label nodes docker-desktop k8. uboard. n/role=etcd

----

## Visit Kuboard
# Open link http://your-node-ip-address:30080(eg: http://localhost:30080)
# Enter initial username and password, Login to
# Username： admin
# Password： Kuboard123
```

### Reference link

- [官方链接](https://kuboard.cn/install/v3/install-in-k8s.html#%E5%AE%89%E8%A3%85)

### v4 Installation

[官方快速开始页面](https://www.kuboard.cn/v4/install/quickstart.html#%E9%9B%86%E6%88%90%E5%A4%96%E9%83%A8%E7%94%A8%E6%88%B7%E5%BA%93)
