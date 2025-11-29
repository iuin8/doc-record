# Deploy k8s High Available Cluster

(Production and testing available)

# Environment configuration：

Strategy

# Preparing before installation

## Add hosts configuration

```bash
# echo '192.168.50.7 k8s-master01' >/etc/hosts
# echo '192.168.50.19 k8s-master02' >/etc/hosts
# echo '192. 68.50.21 k8s-master03' >> /etc/hosts
# echo '192.168.50.8 k8s-node01' >> /etc/hosts
# echo '192. 68.50.14 k8s-node02' >> /etc/hosts
# echo '192.168.50.17 k8s-node03' >> /etc/hosts
# echo '192.168.50.18 db_server' >> /etc/hosts
# echo '192.168.50.20 middle leware_server' >/etc/hosts
```

## Implementing free key login

### Install sshpass

```bash
# yum install -y sshpass
```

### Generate key

```bash
# ssh-keygen 
```

### Distribution of public key

```bash
# vim sendkey.sh
#!/bin/bash
IP="
k8s-master01
k8s-master02
k8s-master03
k8s-node01
k8s-node02
k8s-node03
db_server
middleware_server
"
for node in ${IP};do
  sshpass -p abc1234 ssh-copy-id -o StrictHostKeyChecking=no ${node}
  echo "${node} 秘钥发送完成"
  scp /etc/hosts ${node}:/etc/hosts
  echo "${node} hosts文件发送完成"
done
```

### Add Permissions

```bash
# chmod +x sendkey.sh
```

### Execute Script

```bash
# ./sendkey.sh
```

### Verify that keys can be logged off

```bash
# ssh k8s-master01
```

## Turn off swap (optional)

### Add Script

```bash
# vim close-swap.sh
#!/bin/bash
IP="
k8s-master01
k8s-master02
k8s-master03
k8s-node01
k8s-node02
k8s-node03
"
for node in ${IP};do
    ssh ${node} "swapoff -a"
    ssh ${node} "cp /etc/fstab /etc/fstab.backup"
    ssh ${node} "sed -ri 's/.*swap.*/#&/' /etc/fstab"
done
```

### Add Permissions

```bash
# chmod +x close-swap.sh
```

### Execute Script

```bash
# ./close-swap.sh
```

### Check if there is a shutdown

```bash
# ssh k8s-master01 "free -h"
```

## Kernel Parameter Optimization

## Add configuration

```bash
# vim k8s.conf
# https://github.com/moby/moby/issues/31208 
# ipvsadm -l --timout
# 修复ipvs模式下长连接timeout问题 小于900即可
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 10
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv4.neigh.default.gc_stale_time = 120
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2
net.ipv4.ip_forward = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.netfilter.nf_conntrack_max = 2310720
fs.inotify.max_user_watches=89100
fs.may_detach_mounts = 1
fs.file-max = 52706963
fs.nr_open = 52706963
net.bridge.bridge-nf-call-arptables = 1
vm.swappiness = 0
vm.overcommit_memory=1
vm.panic_on_oom=0
#用于解决k8s内核软锁的bug
kernel.softlockup_panic = 1
kernel.softlockup_all_cpu_backtrace = 1
```

### Add Script

```bash
# vim send_k8sconfig.sh
#!/bin/bash
IP="
k8s-master01
k8s-master02
k8s-master03
k8s-node01
k8s-node02
k8s-node03
"
for node in ${IP};do
    scp k8s.conf ${node}:/etc/sysctl.d/k8s.conf
    ssh ${node} "sysctl --system"
done
```

### Add Permissions

```bash
# chmod +x send_k8sconfig.sh
```

### Execute Script

```bash
# ./send_k8sconfig.sh
```

## Disk Mount

Strategy

# Install kubeasz

Introduction...

## Set version kubeasz

```bash
export release=3.6.7
```

## Download Installation Tool

```bash
wget https://githubfast.com/easzlab/kubeasz/releases/download/${release}/ezdown
```

## Add Permissions

```bash
chmod +x ezdown
```

## Download kubeasz installation tool

### Download Installation Tool

```bash
./ezdown -D
```

# Deploy k8s cluster

## Kubeasz running containment

```bash
./ezdown -S
```

## Create k8s cluster

```bash
docker exec -it kubeasz zctl new k8s-batar
```

## Edit hosts file

```yaml
vim /etc/kubeasz/clusters/k8s-batar/hosts
# PS: Changed IP better (there may be a problem changing to domain name)
# 'etcd' cluster should have odd member(s) (1,3,5,...)
[etcd]
192.168.50.7
192.168.50.19
192.168.50. 1

# master node(s), set unique 'k8s_nodename' for each node
# CAPTION: 'k8s_nodename' must consist of lower case alphaameriic characteristics, '-' or '. ,
# and must start and end with an alpha-HCH character
[kube_master]
192.168.50. k8s_nodename='master-01'
192.168.50.19 k8s_nodename='master-02'
192.168.50. 1 k8s_nodename='master-03'

# work node(s), Set unique 'k8s_nodename' for each node
# CAPTION: 'k8s_nodename' must consist of lower case alphanumeric characteristics, '-' or '. ,
# and must start and end with an alpha-HCH character
[kube_node]
192.168.50. k8s_nodename='worker-01'
192.168.50.14 k8s_nodename='worker-02'
192.168.50.17 k8s_nodename='worker-03'

omitted...
```

## View alias

```bash
alias
```

Check if alias has 'dk' command

Deploying k8s

```bash
dk ezctl setup k8s-batar all
```

View node information

```bash
kubectl get node
```

View all pod messages

```bash
kubtl get Methods -A
```
