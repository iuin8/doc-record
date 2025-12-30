# ip相关

## 固定IP

```bash
# 查看网络接口
ip a
# 编辑 Netplan 配置文件
sudo nano /etc/netplan/01-netcfg.yaml
# （文件名可能不同，如 00-installer-config.yaml）
# 配置静态 IP
```

```yaml
network:
  version: 2
  renderer: networkd  # 或 NetworkManager（如果使用GUI）
  ethernets:
    ens33:  # 替换为您的网卡名称
      dhcp4: no  # 禁用DHCP
      addresses:
        - 192.168.1.100/24  # 静态IP和子网掩码
      routes:
        - to: default
          via: 192.168.1.1  # ← 新的网关配置
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4  # DNS服务器
```

```bash
# 应用配置
sudo netplan apply
# 验证配置
ip route show default
```
