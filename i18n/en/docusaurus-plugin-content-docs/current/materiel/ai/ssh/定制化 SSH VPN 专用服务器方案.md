# Customize SSH VPN specific scheme

> PS: Nothing to use

---

### Customize SSH VPN specific scheme

For server only for SSH VPN, the following are optimized for safe implementation, implement **Client Zero Configuration** + **Server Autoauthorization**：

---

### Server side configuration (one-time)

#### 1. Create only VPN users

```bash
sudo useradd -r -s /usr/sbin/nologin vpn-tunnel # Create system user
sudo mkdir -p /home/vpn-tunnel/.sssh
```

#### General server private key pairs

```bash
# Generate keys on server (just one)
sudo ssh-keygen -t 25519-f /etc/ssh/vpn-server-key -N "" -C "vpn-server@company"

# Set permissions
sudo chmod 600 /etc/ssh/vpn-server-key*
```

#### Configure automatic authentication

```bash
# Set public key to VP's unique authorization mode
sudo cp /etc/ssh/vpn-server-key.pub /home/vpn-tunnel/.ssh/authorized_keys
sudo chown -R vpn-tunnel:vpn-tunnel /vpn-tunnel/.ssh
```

#### Facsimile SSH configuration (`/etc/ssh/sshd_config`)

```bash
# Limit VPN User Permissions
Match User vpn-tunnel
   AllowTcpForwarding no # Port
   PermitTunnel # allows the creation of tunnels
   ForceCommand /bin/false# prohibits execution of any community
   AuthenticationMethods publickey
   PermitRoot Login no
   X11Forwarding no
   AllAgentForwarding no
```

#### Supply configuration

```bash
sudo systemctl start sshd
```

---

### Client Zero Configuration Connection Scheme

#### Scheme A：Pre-Shared Key (for inner network trust)

1. **Get the server private keys**：  
   distributed the server-generated `/etc/ssh/vpn-server-key` private key to clients, save as `~/.ssh/vpn-default-key`

2. **Connected**：
   ```bash
   sshuttle --ssh -i ~/.ssh/vpn-default-key" -r vpn-tunnel@10.0.1.90 0.0.0 / 0
   ```

#### Program B：Certificates Authentication (safer, fit for production)

```bash
# Generate CA certificate
sudo ssh-keygen -t 25519-f /etc/ssh/ca_key -N ""

# signed VPN user certificate (30 days)
sudo ssh-keygen -s /etc/ssh/ca_key -I "vpn-cert" -n vpn-tunnel -V +30d /home/vpn-tunnel/. sh/authorized_keys

# Customers only trust CA public key to connect
```

---

### Automated Connection Script

#### Create a one-click connection script `vpn-connect`

```bash
#!/bin/bash
SERVER_IP="10.0.1.90"
TUN_KEY="vpn-default-key"

# 自动检测本地密钥
if [ ! -f ~/.ssh/$TUN_KEY ]; then
  echo "下载默认 VPN 密钥..."
  curl -s https://internal.company.com/vpn-keys/$TUN_KEY > ~/.ssh/$TUN_KEY
  chmod 600 ~/.ssh/$TUN_KEY
fi

# 静默启动 VPN
sshuttle --ssh "ssh -i ~/.ssh/$TUN_KEY -o StrictHostKeyChecking=no" \
  -r vpn-tunnel@$SERVER_IP 0.0.0.0/0 \
  --daemon --pidfile /tmp/sshuttle.pid

echo "VPN 已启动 (PID: $(cat /tmp/sshuttle.pid))"
```

---

### Security enhancements

| Security Level             | Means of implementation                                                                                                      |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **Network Isolation**      | Server binding VPN edited web card, only SSH port                                                                            |
| **Key Wheels**             | Automatically update server keys with cron per weekk, client scripts to get new keys                                         |
| **Connect to Audit**       | Server records all VPN connection logs to `/var/log/ssh-vpn.log`                                                             |
| **Traffic Limits**         | Use iptables to limit bandwidth and concordance per customer                                                                 |
| **Two-factor authoration** | Integrated Google Authenticator imperplements dynamic passwords (need to modify my SSH PAM configuration) |

---

### Programme comparative advantages

| Features            | Pre-shared key scheme               | Certification Scheme                          |
| ------------------- | ----------------------------------- | --------------------------------------------- |
| Employment Complex  | Low (small team) | Medium (CA Admin required) |
| Security            | Dependency on key custody           | Auto-Expire + Revocation List                 |
| Update Requirements | Key changes need to be resigned     | No client needs to be updated                 |
| Scene               | Internal test/temporary use         | Production environment/long-range transport   |

---

### VMM Recommendations

1. **Status Check Script** (`check-vpn.sh`)

```bash
#!/bin/braash
# Check active connection
netstat -tn | grep ':22' | grep ESTABLISHED

# Monitor traffic
vnstat -i tun0 -tr 5

# Auto-reboot (if process does not exist)
pgrep shutt|| /path/to/vpn-connit
```

2. **Prometheus Monitoring Indicator**

```yaml
# Expos SSH tunnel indicator
- job_name: 'ssh_vpn'
  static_configs:
    - targets: ['10.0.1.90:9100']
  metrics_path: /probe
  params:
    module: [ssh_tunnel]
```

---

### Emergency preparedness

1. **Quick Block Users**

```bash
# Removes license
sudo ed -i '/user-pubkey/d' /home/vpn-tunnel/.ssh/authorized_keys
```

2. **Emergency port witch**

```bash
# Use socat temporary redirect traffic
socat TCP-LISTEN:222222,fork TCP/10.0.1.90:22
```

3. **Full Traffic Capture Analysis**

```bash
sudo tcpdp -i tun0 -w vpn-traffick.pcap
```

---

With this schedule, you will get：

- **Client**：does not need to manual keys, one-click connection
- **Server**：Automated Key Life Management
- **Security**：Corporate Protection and Monitoring Capabilities
- **Vitary**：Good Emergency and Audit Mechanisms

Pre-shared keys or certificate certification schemes can be selected on the basis of actual needs, balancing security with phase of use.
