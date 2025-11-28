# docker-related error record

## Docker info reporting warning

```shell
# WARNING: IPv4 forwarding is disabled.Networking will not work.
# Solutions：
vi /etc/sysctl. onf
# or
vi /usr/lib/syctl.d/00-system.conf
# Add the following code：
    net. pv4.ip_forward=1

# Restart network service
systemctl start network

# View successful
sysctl net.ipv4.ip_forward

# Successful if returned to net.ipv4.ip_forward = 1
```

```shell
# 执行 docker info 时出现警告
# WARNING: bridge-nf-call-iptables is disabled
# WARNING: bridge-nf-call-ip6tables is disabled
# 解决办法：

vi /etc/sysctl.conf
# 在文件里添加下面两行代码：

net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
# 然后 ESC 退出后 :wq 保存，执行下面代码：

sysctl -p
# 再试一次 docker info 问题应该解决了
```

## Image could not be accessed on a registration to record its digest when using docker stack upload

- First say the pit encountered, when executing the command, the image specified in the pull configuration file on the worknode, if the image is present in DockerHub, if it is private, it will not be possible to fetch even if it is logged in
- Solutions：add --with-registry-authve after stack deemployment
