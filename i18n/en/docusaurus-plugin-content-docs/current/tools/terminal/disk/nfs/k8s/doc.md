# k8s NFS Mount

## Install NFS server

```bash

## ubuntu server (250926)
# Updated package list
sudo apt update
sudo apt install -y nfs-kernel-server
# Start NFS service
sudo systemctl start nfs-kernel-server
# Set aut
sudo systemctl enable nfs-kernel-server
# Check service status (firm whether work)
sudo systemctl status nfs-kernel-server

```

## Configure NFS shared directory

```bash
# 创建共享目录
sudo mkdir -p /data/k8s/volume/postgresql/postgresql-data

# 编辑 exports 文件
sudo nano /etc/exports

# 添加如下配置（允许 Kubernetes 节点访问，根据实际网络调整权限）
# 172.20.0.0/16：替换为你的 Kubernetes 节点所在的 IP 段（确保包含所有需要挂载的节点）。
# rw：读写权限；sync：同步写入；no_root_squash：允许 root 用户操作（Kubernetes 通常需要此权限）。
# /data/k8s/volume/postgresql/postgresql-data  172.20.0.0/16(rw,sync,no_root_squash,no_subtree_check)
# 这里配置上节点的网段和容器网段
/data/k8s/volume/postgresql/postgresql-data  10.0.0.0/16(rw,sync,no_root_squash,no_subtree_check)  172.20.0.0/16(rw,sync,no_root_squash,no_subtree_check)

# 保存退出后，重新加载 NFS 配置
sudo exportfs -r

# 验证共享是否生效
sudo exportfs -v

```

## Test Mount

After completing the above steps, mount test： manually on the Kubernetes node that needs to be mounted.

```bash
# Create temporary directory
mkdir -p /tmp/test-nfs

# Mount
sudo mount-t - t nfs master2:/data/k8s/volume/postcongresql-data /tmp/test-nfs

# If mount success story, Verify
df -h | grep /tmp/test-nfs

# Unmount
sudo amount /tmp/test-nfs after completion of the test
```

Restart Kubernetes Pod to solve MountVolume failure： if manually mounted

```bash
# Delete question Pod (Kubernetes will be autoreconstructed)
kubectl delete pod <pod-name> -n <namespace>
```

## Problem

Bitnami PostgreSQL irrors run by default using UID 1001 and GID 1001 non-root install of root)

```bash
# Parent directory to witch to NFS shared directories
cd /data/k8s/volume/postcongresql/

# View current permissions (confirmed as root:root)
girls-Old postprogresql-data

# Modify master and affiliation to 01 (default user of Bitnami mirror)
sudo chown -R 1001:1001 postprogresql-data/

# St directories only 700 (PostgreSQL requests data directory permission, Free other user access)
sudo chmod -R 700 postcongresql-data/

# Confirm changes (drwx ---10001)
girls-Old postcongresql-data
```
