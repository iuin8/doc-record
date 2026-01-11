# ImmortalWrt使用记录

[macos-m1-utm](https://downloads.immortalwrt.org/releases/24.10.4/targets/armsr/armv8/immortalwrt-24.10.4-armsr-armv8-generic-ext4-combined-efi.img.gz)

## 安装virt-viewer

UTM使用`SPICE`共享剪切板

```bash
# 安装virt-viewer
opkg install virt-viewer
# virt-viewer 连接到 UTM 虚拟机
# virt-viewer -c spice://127.0.0.1:5900
virt-viewer spice://192.168.1.100:5900
# virt-viewer没有的话, 可以使用tidy-viewer
brew install tidy-viewer
# 连接到 UTM 虚拟机
tidy-viewer -c spice://192.168.1.100:5900
```

## 网络配置

```bash
# 编辑网络配置文件
vi /etc/config/network
```

```bash
# 修改 LAN 接口设置
config interface 'lan'​
        option type 'bridge'​
        option ifname 'eth0'​
        option proto 'static'​
        option ipaddr '192.168.5.1'  # 修改为适合你的网段​
        option netmask '255.255.255.0'​
        option gateway '192.168.5.254'  # 设置网关​
        option dns '8.8.8.8 8.8.4.4'  # 设置DNS
```

```bash
# 重启服务
/etc/init.d/network restart
```

## 安装Argon主题

```bash
# 更新软件包列表
opkg update
# 安装Argon主题
opkg install luci-theme-argon
```

## 安装基础磁盘管理

```bash
# 安装基础磁盘管理工具
# opkg install block-mount kmod-fs-ext4
opkg install block-mount

# 重启Web服务
/etc/init.d/uhttpd restart
```

## 安装高级磁盘管理 Web 界面

```bash

# 安装DiskMan及其依赖
opkg install luci-app-diskman

# 安装必要的依赖包
opkg install parted blkid e2fsprogs btrfs-progs smartmontools

# 重启Web服务
/etc/init.d/uhttpd restart

# 要是有问题Failed to connect to ubus

# 安装 uhttpd-mod-ubus 模块
opkg install uhttpd-mod-ubus

# 重启 uhttpd
/etc/init.d/uhttpd restart
# 再不行重启就好了

```

## 扩展根分区

在页面上操作吧[系统->挂载点], 不用下面的命令了

```bash

# 查看所有磁盘设备
lsblk
# 或者查看详细的磁盘信息
fdisk -l
# 或者查看详细的磁盘信息
fdisk -l /dev/vda
# 安装分区工具​
opkg install parted resize2fs​
opkg install losetup
# 找到根文件系统的实际设备
# 查找或创建循环设备
LOOP_DEV=$(losetup -f)
losetup "$LOOP_DEV" /dev/vda2

# 强制扩展文件系统
resize2fs -f "$LOOP_DEV"

# 验证结果
df -h

# 查看文件系统详细信息
tune2fs -l /dev/vda2

# 重启系统
reboot

# 查看当前分区情况
parted /dev/vda print

​

# 扩展分区（假设根分区是第2个分区）
parted /dev/vda resizepart 2 100%

# 扩展文件系统
resize2fs /dev/vda2
resize2fs /dev/root
# 验证扩展
df -h
```

```bash
# 优化系统性能

# 清理临时文件
rm -rf /tmp/*

# 清理opkg缓存
rm -rf /var/cache/opkg/*
# 要是下次update有lock文件不存在的问题
mkdir -p /var/lock

# 清理日志文件
rm -rf /var/log/*

# 优化文件系统
e2fsck -f /dev/vda2
resize2fs -f /dev/vda2
```

## 优化系统

```bash
# 问题 1：无法运行 e2fsck 检查
# 配置启动时自动检查（推荐）

# 设置文件系统检查标志
tune2fs -c 1 /dev/vda2

# 重启系统，系统会在启动时自动检查
reboot

# 优化ext4文件系统
tune2fs -o journal_data_writeback /dev/vda2
tune2fs -m 1 /dev/vda2  # 设置预留空间为1%

# 监控磁盘健康状态

# 安装smartmontools
opkg install smartmontools

# 检查磁盘健康状态
smartctl -H /dev/vda
```

## 安装 e2fsprogs 包来获取 tune2fs 工具

```bash

# 安装 e2fsprogs 包（包含 tune2fs）
opkg install e2fsprogs

# 验证安装
tune2fs --version

# 如果 e2fsprogs 不可用
# 安装 parted 工具（替代方案）
opkg install parted

# 使用 parted 查看磁盘信息
parted -l /dev/vda
```

## 访问

- 浏览器访问 `http://192.168.5.1`（或你设置的IP）
- 登录用户名：`root`，密码：`password`（默认）

## 配置成旁路由

[网络-接口-lan-DHCP服务器-忽略此接口]打勾-保存-保存并应用

将自己电脑的网关改成ImmortalWRT的IP(客户端将wifi/有线网络的网关设置成ImmortalWRT的IP地址即可)

> 不想手动修改网关的话，可以直接把主路由器的dhcp功能关闭，这样ImmortalWRT的dhcp就会介入分配局域网IP，只要连上主路由的设备都会自动将ImmortalWRT设为网关，但是这样的前提是mbp要24小时都开机

添加科学上网功能

搜索`openclash`，点击安装`luci-app-openclash`

## 问题

如果lan口获取失败

[服务-OpenClash-插件设置-流量控制-LAN 接口名称]选择系统可用的lan接口, 比如`eth0`或者`br-lan`
