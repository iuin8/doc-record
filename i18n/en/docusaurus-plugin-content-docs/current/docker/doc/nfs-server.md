## Service installation NFS service step：

- Step 1：Install NFS and rpc.

```shell
[root@localhost ~]# yum install -y nfs-utils   
#Installing nfs service
[root@localhost ~]# yum install -y rpcind
#Installing rpc service

```

- Step 2：Start service and setup start：

> Note that：starts rpc service before nfs.

```shell
[root@localhost ~]# systemctl start rpcind #start rpc service
[root@localhost ~]# systemctl enable rpcind #set start
[root@localhost ~]# systemctl start nfs-server nfs-secure-server      
#Start nfs-server service and nfs secure transmission service (nfs-secure-server can not be needed)
[root@localhost ~]# systemctl enable nfs-server nfs-secure-secure-server
# Set up to start (nfs-secure-server not required)

```

> Configure Firewall

```shell
[root@localhost /]# firewall-cmd --permanent --add-service=rpc-bind
success #Configure firewall release rpc-binds
[root@localhost / ]# firewall-cmd --add-service=nfs
success #Configure firewall release nfs service (failure： clnt_cree: RPC: Port map failure - Unable to receive: errno 113 (No rout to host))
[root@localhost /]# firewall-cmd --add-add-service=mountd
success #Configure firewall release of mountd service (not turned on: rpc mount export: RPC: Unable to receive; errno = No route to host)
[root@localhost /]# firewall-cmd --reload 
success

```

- Step 3：config shared file directory, edit profile：
  1. First create a shared directory and then edit the configuration in the /etc/export profile.

```shell
[root@localhost /]# mkdir /public
#Create public shared directory
[root@localhost /]# vi /etc/exports
	/public 192.168.245.0/24(rw)
	/protected 192.168.245. /24(ro)
[root@localhost /]# systemctl reload nfs 
#Reload NFS service to make the configuration file effective (take it one)
[root@localhost /]# exportfs -rv
#Exposure NFS service to make the configuration file effective (take it one)

```

## NFS Client Mount Configuration：

- Step 1：Use the showmount command to view nfs server sharing information.The output format is 'shared directory name' allowed to use client addresses.

```shell
yum - y install nfs-utils
# install nfs-utils client
[root@localhost ~]# showmount -e 192.168.245.128      
Export list for 192.168.245.128:
/protected 192.168.245.0/24
/public 192.168.148.245.0/24

```

- Step 2. Create directories on clients and mount shared directories.

```shell
[root@localhost ~]# mkdir /mnt/public
[root@localhost ~]# mkdir /mnt/data
[root@localhost ~]# vim /etc/fstab 
#在该文件中挂载，使系统每次启动时都能自动挂载
	192.168.245.128:/public  /mnt/public       nfs    defaults 0 0
	192.168.245.128:/protected /mnt/data     nfs    defaults  0 1
[root@localhost ~]# mount -a   #是文件/etc/fstab生效

```

- Step 3：Check：

```shell
showmount -e 192.168.56. 03
# To see if you have permission to access
[root@mail ~]# df -Th
# See mount
Filesystem Type Size Avail Use% Mounted on
/dev/mapper/rhel-root xfs 17G 3. G 14G 18% /
devtmpfs devtmpfs 1. G 01. G 0% /dev
tmpfs tmpfs 1. G 140K 1. G 1% /dev/shm
tmpfs tmpfs 1. G 9.1M 1. G 1% /run
tmpfs tmpfs 1. G 01. G 0% /sys/fs/cgroup
/dev/sda1 xfs 1014M 173M 842M 18% /boot
tmpfs tmpfs 280M 3222 280M 1% /run/user/0
/dev/sr0 iso9660 3. G 3.6G 0 100% /mnt/cdrom
192.168.245.128:/public nfs4 17G 3. G 14G 22% /mnt/public
192.168.245. 28:/protected nfs4 17G 3.7G 14G 22% /mnt/data

```
