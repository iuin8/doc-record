# sshuttle

[github地址](https://github.com/sshuttle/sshuttle)

```bash
# Install
brew install sshuttle

# Configure local macs free of
sshuttle ---sudoers-no-modify
# After execution you print configuration content
# Execute the following commands and write configuration content to
visudo /etc/sudoers in the following file. /sshuttle_auto
# Add configuration (specified user john) to the specified user (it seems that the specified user sshuttle is free to take effect)
sudo visudo /etc/sudoers. /sshuttle_auto_john

# Free use (fa: free user, specified) (in conjunction with ssh config)
# PS: Looks do not seem to be decriminalizing
sshuttle --sudoers-user fa-r jump.local.container22-sshuttle.fa.intranet.company 10.0.1.0/24

```

```bash

# 其他使用方式示例
sshuttle -r root@10.0.1.90 --python $(which python3) 0.0.0.0/0

# 成功命令(--python指定的是服务端的python命令, 在服务端安装了python3)
sshuttle -r root@container2222.fa.intranet.company --python /usr/bin/python3 0.0.0.0/0
# 简化版
sshuttle -r container2222.fa.intranet.company 0.0.0.0/0

# 通过内部mac服务器访问网络, mac中连接了其他公司内部VPN, 一下命令实现让本机也能访问受VPN限制的网络
sshuttle -r mac.intranet.company 0.0.0.0/0
# 可以指定代理的域名
sshuttle -r mac.intranet.company baidu.com
```

## Advanced actions (client zero configuration test failed)

### Server side configuration (one-time)

#### 1. Create only VPN users

```bash
sudo useradd -r -s /usr/sbin/nologin vpn-tunnel # Create system user
sudo mkdir -p /home/vpn-tunnel/.sssh
```

#### 2. Generate server private key pairs

```bash
# Generate keys on server (just one)
sudo ssh-keygen -t 25519-f /etc/ssh/vpn-server-key -N "" -C "vpn-server@company"

# Set permissions
sudo chmod 600 /etc/ssh/vpn-server-key*
```

#### Configure automatic authorization

```bash
# Set public key to VP's unique authorization mode
sudo cp /etc/ssh/vpn-server-key.pub /home/vpn-tunnel/.ssh/authorized_keys
sudo chown -R vpn-tunnel:vpn-tunnel /home/vpn-tunnel/.ssh
```

#### Facsimile SSH configuration (`/etc/ssh/sshd_config`)

```bash
# Limit VPN User Permissions
Match User vpn-tunnel
   AllowTcpForwarding no # Port
   PermitTunnel yes # allows the creation of tunnels
   ForceCommand /bin/false# prohibits execution of any command
   AuthenticationMethods publickey
   PermitRootLogin no
   X11Forwarding no
   AllowAgentForwarding no
   IdentityFile /etc/ssh/vpn-server-key
```

#### 5. Apply configuration

```bash
# Restart sshd
sudo systemctl start sshd
# If you don't have the above command, Use the following schema

# below to test the syntax of the sshd configuration file for the correct
/usr/sbin/sshd -t
# Send HUP Signal, and the sshd process reload configuration.
/usr/sbin/sshd -k HUP
```

### Client Zero Configuration Connection Scheme

#### Program B：Certificate Authentication (safer, fit for production)

```bash
# Generate CA certificate
sudo ssh-keygen -t 25519-f /etc/ssh/ca_key -N ""

# Signed VPN user certificate (30 days)
sudo ssh-keygen -s /etc/ssh/ca_key -I "vpn-cert" -n vpn-tunnel -V +30d /home/vpn-tunnel/. sh/authorized_keys

# Clients only trust CA public key to connect
```
