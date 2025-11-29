# NFS usage records

## Install

- [macfuse官网](https://macfuse.github.io/)

```bash
# macos
# Installing macfuse and sshfs

# centos server
yum install -y nfs-utils

# Ubuntu/Debian
sudo app install -y nfs-common

# Start and enable NFS service
systemctl start nfs-server
systemctl enabling nfs-server
systemctl status nfs-server

```

## Configure NFS shared directory

```bash
# 编辑 /etc/exports 文件
vim /etc/exports

# 示例
# 格式：共享目录 客户端IP(选项)
/data/nfs_share 192.168.1.0/24(rw,sync,no_root_squash)

# /data/nfs_share：要共享的目录（需提前创建）。
# 192.168.1.0/24：允许访问的客户端 IP 范围（* 表示所有客户端，但不推荐）。
# rw：读写权限（ro 表示只读）。
# sync：同步写入（async 表示异步，但可能丢失数据）。
# no_root_squash：允许客户端 root 用户保持 root 权限（谨慎使用，可能带来安全风险）。
# root_squash（默认）：客户端 root 用户映射为 nobody 用户。

# 创建共享目录
mkdir -p /data/nfs_share
chmod 755 /data/nfs_share
# 可选，NFS 默认用户
chown nfsnobody:nfsnobody /data/nfs_share
# 导出 NFS 共享
# 运行以下命令使配置生效：
exportfs -ra
# 查看当前共享情况：
exportfs -v
```

## Configure firewall (if enabled)

```bash
# If CentS has firewall enabled (firewall), To release NFS related port：
sudo firewall-cmd --add-service=nfs
sudo firewall-cmd --add-service=mountd
sudo firewall-cmd --add-service=rpc-bind
sudo firewall-cmd -reload
# or directly release N/default FS port (not recommended, Affects security)：
sudo firewall-cmd --permanent --add={2049/tcp,2049/udp}
sudo firewall-cmd --reload

```

## Test NFS Service

```bash
# Test
showmount -e localhost
 on server
```

## Mount NFS Sharing

```bash
# Secure client directories
chmod 755/Users/xx/mount/sshfs

mount - t nfs 192.168.1.100:/data/nfs_share /mnt/nfs
# (192). 68.1.1.100 is the NFS server IP, /mnt/nfs is the client mount)
# Use mount_nfs(macOS original lift)
sudo mount_nfs -o resport xx. ntranet.company:/data/nfs_share/dev /Users/xx/mount/sshfs/x.intranet. ompany


# Check if successful：
df -h | grep nfs
# If mounted information like /dev/nfs is seen, indicate success.

```

## Uninstall

```bash
# /mnt/nfs is client mount point
amount /mnt/nfs
```

## FAQ

```bash
# Client cannot mount

# to check /etc/exports configuration correctly.
# to ensure that firealls release NFS related ports.
# Check that rpind service is running (CencoOS 7+ enabled by default)：
sudo systemctl status rpwind

# Permissions question

# Ensure that shared directory properties are correct (chmod 755).
# if no_root_squash, client root has permissions.
```

- macos mount showing issues with no permissions

```bash
The NFS service for macOS is managed by launchchd and cannot run nfsdstart. You need：
```
