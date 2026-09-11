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

## 让指定设备走旁路由

```bash
# 安装必要工具
opkg install nmap arping iputils-ping dnsmasq iptables
```

```bash
# 创建 IP 地址监控脚本
cat > /root/monitor-ip.sh << 'EOF'
#!/bin/bash

# 日志配置
LOG_FILE="/var/log/network-manager.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

mkdir -p /etc/dnsmasq.d

# 配置文件路径
DHCP_CONF="/etc/dnsmasq.d/dynamic-dhcp.conf"
ARP_SCRIPT="/root/start-spoof.sh"
IP_FILE="/tmp/current_ip.txt"

# 获取当前IP地址
get_current_ip() {
    ip addr show br-lan | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1
}

# 初始化IP文件
current_ip=$(get_current_ip)
echo $current_ip > $IP_FILE

log "初始IP地址: $current_ip"
log "启动IP监控服务..."

while true; do
    new_ip=$(get_current_ip)
    old_ip=$(cat $IP_FILE)
    
    if [ "$new_ip" != "$old_ip" ] && [ -n "$new_ip" ]; then
        log "检测到IP地址变化: $old_ip -> $new_ip"
        
        # 更新IP文件
        echo $new_ip > $IP_FILE
        
        # 更新DHCP配置
        sed -i "s/dhcp-option=3,$old_ip/dhcp-option=3,$new_ip/g" $DHCP_CONF
        sed -i "s/dhcp-option=6,$old_ip/dhcp-option=6,$new_ip/g" $DHCP_CONF
        
        # 更新ARP欺骗脚本
        sed -i "s/PROXY_IP=\"$old_ip\"/PROXY_IP=\"$new_ip\"/g" $ARP_SCRIPT
        
        # 重启相关服务
        /etc/init.d/dnsmasq restart
        /root/restart-spoof.sh
        
        log "IP地址已更新为: $new_ip"
    fi
    
    sleep 30  # 每30秒检查一次
done
EOF

chmod +x /root/monitor-ip.sh
```

```bash
# 创建智能 IP 扫描脚本
cat > /root/scan-network.sh << 'EOF'
#!/bin/bash

# 日志配置
LOG_FILE="/var/log/network-manager.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 网络配置
# 获取完整的IP/CIDR
IP_CIDR=$(ip addr show $(ip route show default | awk '{print $5}') | grep 'inet ' | awk '{print $2}')

# 拆分IP和CIDR
IP=$(echo $IP_CIDR | cut -d'/' -f1)
CIDR=$(echo $IP_CIDR | cut -d'/' -f2)

# 获取IP前缀
IP_PREFIX=$(echo $IP | cut -d '.' -f 1-3)'.'

# 替换最后一位为0
NETWORK=$(echo $IP | awk -F. '{print $1"."$2"."$3".0/"CIDR}')
PROXY_IP=$(cat /tmp/current_ip.txt)
GATEWAY=$(ip route show default | awk '{print $3}')

touch /tmp/used_ips.txt

mkdir -p /etc/dnsmasq.d

# 扫描结果文件
SCAN_RESULT="/tmp/network_scan.txt"
USED_IPS="/tmp/used_ips.txt"
AVAILABLE_IPS="/tmp/available_ips.txt"

# 清理旧文件
rm -f $SCAN_RESULT $USED_IPS $AVAILABLE_IPS

log "开始扫描网络: $NETWORK"

# 1. 使用nmap扫描活跃主机
nmap -sn $NETWORK -oG $SCAN_RESULT > /dev/null 2>&1

# 2. 从扫描结果中提取IP地址
grep "Up$" $SCAN_RESULT | awk '{print $2}' > $USED_IPS

# 3. 添加已知的重要IP
echo $GATEWAY >> $USED_IPS
echo $PROXY_IP >> $USED_IPS

# 4. 去重并排序
sort -u $USED_IPS -o $USED_IPS

# 5. 生成可用IP范围（$IP_PREFIX100-$IP_PREFIX250）
for ip in $(seq 100 250); do
    current_ip="$IP_PREFIX$ip"
    if ! grep -q "$current_ip" $USED_IPS; then
        echo $current_ip >> $AVAILABLE_IPS
    fi
done

# 6. 显示结果
log "扫描完成:"
log "已使用IP数量: $(wc -l < $USED_IPS)"
log "可用IP数量: $(wc -l < $AVAILABLE_IPS)"

# 7. 更新DHCP配置
if [ -s $AVAILABLE_IPS ]; then
    first_ip=$(head -n1 $AVAILABLE_IPS)
    last_ip=$(tail -n1 $AVAILABLE_IPS)
    
    log "更新DHCP范围: $first_ip - $last_ip"
    
    # 更新DHCP配置 - 添加手机MAC地址
    cat > /etc/dnsmasq.d/dynamic-dhcp.conf << DHCP_EOF
interface=br-lan
bind-interfaces
dhcp-range=$first_ip,$last_ip,255.255.252.0,1h
dhcp-option=3,$PROXY_IP
dhcp-option=6,$PROXY_IP
dhcp-authoritative

# 手机配置（固定IP）
dhcp-host=d4:a3:65:89:69:9c,10.0.4.124,MyPhone
DHCP_EOF
    
    # 重启DHCP服务
    /etc/init.d/dnsmasq restart
    log "DHCP服务已重启"
else
    log "警告: 没有可用IP地址!"
fi

log "智能IP管理完成"
EOF

chmod +x /root/scan-network.sh
```

```bash
# 创建 ARP 监控脚本
cat > /root/monitor-arp.sh << 'EOF'
#!/bin/bash

# 日志配置
LOG_FILE="/var/log/network-manager.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 监控间隔（秒）
INTERVAL=60

# 临时文件
ARP_CACHE="/tmp/arp_cache.txt"
NEW_DEVICES="/tmp/new_devices.txt"

log "启动ARP监控服务..."

while true; do
    # 获取当前ARP缓存
    ip neigh show | awk '/^10\.0\.4\./ {print $1" "$3}' > $ARP_CACHE
    
    # 检查新设备
    if [ -f /tmp/previous_arp.txt ]; then
        grep -Fxvf /tmp/previous_arp.txt $ARP_CACHE > $NEW_DEVICES
        
        if [ -s $NEW_DEVICES ]; then
            log "发现新设备:"
            cat $NEW_DEVICES | while read line; do
                log "  $line"
            done
            
            # 触发IP扫描更新
            log "触发网络扫描更新"
            /root/scan-network.sh
        fi
    fi
    
    # 保存当前ARP缓存用于下次比较
    cp $ARP_CACHE /tmp/previous_arp.txt
    
    sleep $INTERVAL
done
EOF

chmod +x /root/monitor-arp.sh
```

```bash
# 创建 IP 冲突检测脚本
cat > /root/check-conflict.sh << 'EOF'
#!/bin/bash

# 日志配置
LOG_FILE="/var/log/network-manager.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 检查IP冲突
check_ip() {
    local ip=$1
    arping -c 1 -w 1 $ip > /dev/null 2>&1
    return $?
}

# 检查DHCP分配的IP
check_dhcp_leases() {
    LEASES_FILE="/var/lib/misc/dnsmasq.leases"
    
    if [ -f $LEASES_FILE ]; then
        while read lease; do
            ip=$(echo $lease | awk '{print $3}')
            mac=$(echo $lease | awk '{print $2}')
            hostname=$(echo $lease | awk '{print $4}')
            
            if check_ip $ip; then
                # 发现冲突，释放该IP
                log "发现IP冲突: $ip (MAC: $mac, 主机名: $hostname)"
                # 可以在这里实现自动释放和重新分配
            fi
        done < $LEASES_FILE
    fi
}

# 主程序
log "检查IP冲突..."
check_dhcp_leases
log "冲突检查完成"
EOF

chmod +x /root/check-conflict.sh
```

```bash
# 设置定时任务
# 使用 sleep 循环脚本
cat > /root/start-monitors.sh << 'EOF'
#!/bin/bash

# 日志配置
LOG_FILE="/var/log/network-manager.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "启动监控服务主程序..."

# 初始扫描
log "执行初始网络扫描"
/root/scan-network.sh

# 主循环
while true; do
    # 每小时执行一次网络扫描
    log "执行定时网络扫描"
    /root/scan-network.sh
    
    # 每10分钟检查一次IP冲突
    for i in {1..6}; do
        log "检查IP冲突"
        /root/check-conflict.sh
        sleep 600  # 10分钟
    done
done
EOF

chmod +x /root/start-monitors.sh
```

```bash
# 添加 ARP 欺骗脚本
cat > /root/start-spoof.sh << 'EOF'
#!/bin/bash

# 日志配置
LOG_FILE="/var/log/network-manager.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 网络配置
INTERFACE="br-lan"
GATEWAY=$(ip route show default | awk '{print $3}')
PROXY_IP=$(cat /tmp/current_ip.txt)
TARGET_IPS="10.0.4.124"  # 手机IP

log "启动ARP欺骗服务..."
log "接口: $INTERFACE"
log "网关: $GATEWAY"
log "旁路由IP: $PROXY_IP"
log "目标设备: $TARGET_IPS"

# 启动ARP欺骗
for ip in $TARGET_IPS; do
    arpspoof -i $INTERFACE -t $ip $GATEWAY &
    arpspoof -i $INTERFACE -t $GATEWAY $ip &
    log "  欺骗设备: $ip"
done

log "ARP欺骗服务已启动"
EOF

chmod +x /root/start-spoof.sh

cat > /root/restart-spoof.sh << 'EOF'
#!/bin/bash

# 日志配置
LOG_FILE="/var/log/network-manager.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 停止现有ARP欺骗进程
killall arpspoof 2>/dev/null
log "停止现有ARP欺骗进程"

# 获取当前配置
PROXY_IP=$(cat /tmp/current_ip.txt)
GATEWAY=$(ip route show default | awk '{print $3}')
INTERFACE="br-lan"
TARGET_IPS="10.0.4.124"  # 手机IP

log "重启ARP欺骗服务..."
log "当前IP: $PROXY_IP"
log "网关: $GATEWAY"

# 启动新的ARP欺骗进程
for ip in $TARGET_IPS; do
    arpspoof -i $INTERFACE -t $ip $GATEWAY &
    arpspoof -i $INTERFACE -t $GATEWAY $ip &
    log "  欺骗设备: $ip"
done

log "ARP欺骗服务已重启"
EOF

chmod +x /root/restart-spoof.sh
```

```bash
# 启用 IP 转发
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
```

```bash
# 配置防火墙
# 允许IP转发
# 配置防火墙转发
uci set firewall.@zone[0].forward=ACCEPT
uci set firewall.@zone[0].masq=1
uci commit firewall
/etc/init.d/firewall restart
```

```bash
# 添加 NAT 规则
# 创建NAT规则配置文件
cat > /etc/nftables.d/nat-rules.nft << 'EOF'
table ip nat {
    chain postrouting {
        type nat hook postrouting priority 100; policy accept;
        oifname "br-lan" masquerade;
    }
}
EOF

# 应用配置
nft -f /etc/nftables.d/nat-rules.nft

/etc/init.d/firewall restart
```

```bash
# 设置开机自启
cat > /etc/rc.local << 'EOF'
#!/bin/sh -e

# 等待网络就绪
sleep 10

# 启动IP地址监控服务
/root/monitor-ip.sh &

# 启动网络扫描
/root/scan-network.sh &

# 启动ARP欺骗服务
/root/start-spoof.sh &

# 启动ARP监控
/root/monitor-arp.sh &

# 启动IP冲突检测
/root/start-monitors.sh &

# 应用NAT规则
nft -f /etc/nftables.d/nat-rules.nft

exit 0
EOF

chmod +x /etc/rc.local
```

```bash
cat > /root/start-all.sh << 'EOF'
#!/bin/bash

echo "启动智能网络服务..."

# 启动IP监控
/root/monitor-ip.sh &

# 启动网络扫描
/root/scan-network.sh &

# 启动ARP监控
/root/monitor-arp.sh &

echo "所有服务已启动"
echo "当前IP: $(cat /tmp/current_ip.txt)"
EOF

chmod +x /root/start-all.sh
```

```bash
# 创建日志文件
touch /var/log/network-manager.log
chmod 666 /var/log/network-manager.log
```

```bash
# 检查IP转发是否启用
sysctl net.ipv4.ip_forward

# 检查nftables规则
nft list ruleset

# 检查防火墙状态
/etc/init.d/firewall status

# 检查NAT规则是否生效
nft list table ip nat

# 测试网络连接
ping -c 3 8.8.8.8

# 检查防火墙状态
/etc/init.d/firewall status

# 测试旁路由功能
# 检查所有服务是否正常运行
ps | grep -E 'monitor-ip|scan-network|arpspoof|dnsmasq'

# 查看DHCP租约
cat /var/lib/misc/dnsmasq.leases

# 查看ARP表
arp -a

# 查看日志
tail -f /var/log/network-manager.log
```

```bash
# 日志查看方法
# 实时查看日志
tail -f /var/log/network-manager.log

# 查看特定服务日志
grep "IP监控" /var/log/network-manager.log
grep "ARP欺骗" /var/log/network-manager.log
grep "DHCP" /var/log/network-manager.log
```

```bash
# 测试和验证
# 手动运行测试
/root/scan-network.sh
/root/start-spoof.sh

# 查看状态
ps | grep -E 'monitor-ip|scan-network|arpspoof'
cat /tmp/network_config.txt
cat /etc/dnsmasq.d/dynamic-dhcp.conf
```

## 其他

```bash
# 可以看到IP和网关
# 执行以下命令，直接查看当前路由表的默认网关
ip route show default
```

## 问题

如果lan口获取失败

[服务-OpenClash-插件设置-流量控制-LAN 接口名称]选择系统可用的lan接口, 比如`eth0`或者`br-lan`
