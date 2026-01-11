# 配置 wifi

```bash
# 检查是否安装了 wpad 或 hostapd
opkg list-installed | grep -E 'wpad|hostapd'
```

## 配置软件源并安装 wpad-full

```bash
# 备份当前软件源配置
cp /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.backup
# 配置ImmortalWrt国内镜像源
cat > /etc/opkg/distfeeds.conf << "EOF"
src/gz immortalwrt_core https://mirrors.ustc.edu.cn/immortalwrt/releases/23.05.4/packages/x86_64/core
src/gz immortalwrt_base https://mirrors.ustc.edu.cn/immortalwrt/releases/23.05.4/packages/x86_64/base
src/gz immortalwrt_luci https://mirrors.ustc.edu.cn/immortalwrt/releases/23.05.4/packages/x86_64/luci
src/gz immortalwrt_packages https://mirrors.ustc.edu.cn/immortalwrt/releases/23.05.4/packages/x86_64/packages
src/gz immortalwrt_routing https://mirrors.ustc.edu.cn/immortalwrt/releases/23.05.4/packages/x86_64/routing
src/gz immortalwrt_telephony https://mirrors.ustc.edu.cn/immortalwrt/releases/23.05.4/packages/x86_64/telephony
EOF

# 更新软件包列表
opkg update
# 查看可用的wpad版本
opkg list | grep wpad

# 安装完整版本的wpad
opkg install wpad-full

## 如果 wpad-full 不可用，可以尝试安装其他完整版本：

# 或者安装wpad-openssl（推荐）
opkg install wpad-openssl

# 或者安装wpad-mbedtls（占用空间更小）
opkg install wpad-mbedtls

# 验证安装
opkg list-installed | grep wpad

```

```bash
# 配置 WiFi 热点
vi /etc/config/wireless
# 添加或修改以下内容：
config wifi-device 'radio0'
    option type 'mac80211'
    option channel '11'
    option hwmode '11g'
    option path 'platform/qca953x_wmac'
    option htmode 'HT20'
    option disabled '0'

config wifi-iface 'default_radio0'
    option device 'radio0'
    option network 'lan'
    option mode 'ap'
    option ssid 'ImmortalWrt'
    option encryption 'psk2'
    option key 'password'

# 重启网络服务
/etc/init.d/network restart
# 或者直接重启wpad服务
/etc/init.d/wpad restart
# 或者使用wifi命令（如果可用）
wifi reload

# 确保dnsmasq已启用
/etc/init.d/dnsmasq enable
/etc/init.d/dnsmasq restart


# 若WiFi命令未找到
# 安装wireless-tools（包含iwconfig、iwlist等工具）
opkg install wireless-tools

# 安装hostapd（无线接入点管理工具）
opkg install hostapd

# 安装iwinfo（无线信息工具）
opkg install iwinfo

# 安装iw（现代无线配置工具）
opkg install iw

# 安装wpad-openssl（完整功能的无线管理）
opkg install wpad-openssl

# 检查无线服务状态
# 查看wpad服务状态
/etc/init.d/wpad status

# 查看hostapd进程
ps | grep hostapd

# 查看无线接口状态
iw dev wlan0 link

# 安装必要的无线驱动和内核模块

# 更新软件包列表
opkg update

# 安装无线驱动和内核模块
opkg install kmod-mac80211 kmod-cfg80211 kmod-ath9k kmod-ath9k-common

# 安装完整的hostapd版本
opkg install hostapd-utils

# 重启网络服务
/etc/init.d/network restart

# 检查内核模块是否加载
lsmod | grep 80211

# 检查无线设备
iwconfig

# 如果iwconfig也没有输出，检查网络接口
ifconfig -a
```

```bash
# 确保网络接口配置正确：
vi /etc/config/network
# 配置 LAN 接口：
config interface 'lan'
    option type 'bridge'
    option ifname 'eth0 wlan0'
    option proto 'static'
    option ipaddr '192.168.1.1'
    option netmask '255.255.255.0'
    option gateway '宿主机IP或主路由IP'
    option dns '8.8.8.8 8.8.4.4'

# 示例配置
config interface 'loopback'​
    option device 'lo'​
    option proto 'static'​
    option ipaddr '127.0.0.1'​
    option netmask '255.0.0.0'​
​
config globals 'globals'​
    option ula_prefix 'fdff:2c52:622b::/48'​
    option packet_steering '1'​
​
config device​
    option name 'br-lan'​
    option type 'bridge'​
    list ports 'eth0'​
    list ports 'wlan0'​
​
config interface 'lan'​
    option device 'br-lan'​
    option proto 'static'​
    option ipaddr '192.168.1.1'​
    option netmask '255.255.255.0'​
    option gateway '192.168.1.254'​
    option dns '8.8.8.8 8.8.4.4'


# 重启网络服务：
/etc/init.d/network restart

# 确保 DHCP 服务已启用：
vi /etc/config/dhcp

# 配置 DHCP：
config dhcp 'lan'
    option interface 'lan'
    option start '100'
    option limit '150'
    option leasetime '12h'
    option dhcpv6 'server'
    option ra 'server'

# 重启 DHCP 服务：
/etc/init.d/dnsmasq restart

# 确保防火墙允许 WiFi 热点流量：
vi /etc/config/firewall

# 修改防火墙配置：
config zone
    option name 'lan'
    option input 'ACCEPT'
    option output 'ACCEPT'
    option forward 'ACCEPT'
    option network 'lan wlan'

# 重启防火墙：
/etc/init.d/firewall restart
```

```bash
# 激活无线设备
uci set wireless.radio0.disabled='0'
uci commit wireless
wifi reload

opkg update

opkg install hostapd dnsmasq wireless-tools wpa-supplicant


# 检查无线设备状态
iw dev
iwconfig

# 确保无线接口已启用
uci set wireless.@wifi-iface[0].disabled='0'
uci commit wireless
wifi reload

# 检查无线接口状态
iw dev wlan0 link
iwlist wlan0 scanning

# 在ImmortalWrt中安装USB相关软件包
opkg update
opkg install usbutils kmod-usb-core kmod-usb-ohci kmod-usb-uhci kmod-usb2

# 在 ImmortalWrt 中安装驱动
# 更新软件包列表
opkg update

# 安装USB无线网卡驱动（根据你的网卡芯片选择）
# 对于Realtek芯片
opkg install kmod-rtl8192cu kmod-rtl8192ce kmod-rtl8192de kmod-rtl8188eu

# 对于Atheros芯片
opkg install kmod-ath9k-htc

# 安装无线管理工具
opkg install wireless-tools wpa-supplicant hostapd
```

```bash
# 更新软件包列表
opkg update

# 安装核心无线软件包
opkg install iw iwinfo wireless-tools wifi-scripts

# 安装无线驱动框架
opkg install kmod-cfg80211 kmod-mac80211

# 安装无线AP支持（wpad包含hostapd和wpa-supplicant）
opkg install wpad-openssl

# 安装可能需要的其他包
opkg install libnl-tiny
```

```bash
# 加载cfg80211和mac80211模块
modprobe cfg80211
modprobe mac80211

# 检查模块是否加载
lsmod | grep cfg80211
lsmod | grep mac80211
```

```bash
# 如果 WiFi 热点仍不可见

# 检查频道设置
uci set wireless.radio0.channel='auto'
uci commit wireless
wifi reload

# 检查国家代码
uci set wireless.radio0.country='CN'
uci commit wireless
wifi reload
```

## 故障排除

```bash
# 如果遇到问题，可以尝试以下命令进行排查：
# 查看无线状态
wifi status

# 查看系统日志
logread | grep hostapd
logread | grep wpad

# 重启无线服务
wifi down
wifi up

# 查看网络接口
ifconfig
iwconfig
# 验证 WiFi 热点
# 现在你应该可以在其他设备上看到名为 "MyImmortalWrt" 的 WiFi 热点了。连接它并测试网络连接。
```

## 宿主机查找虚拟机IP地址

```bash
arp -a
# 或者
nmap -sn 192.168.1.0/24
```
