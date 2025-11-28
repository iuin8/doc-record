# Customize SSH VPN specific server scheme

> PS: Nothing to use

---

### Customize SSH VPN specific server scheme

For server only for SSH VPN, the following are optimized for safe implementation, implement **Client Zero Configuration** + **Server Autoauthentication**：

---

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
   AllAgentForwarding no
```

#### 5. Apply configuration

```bash
sudo systemctl start sshd
```

---

### Client Zero Configuration Connection Scheme

#### Scheme A：Pre-Shared Key (for inner network trust)

1. **Get the server private keys**：  
   distribute the server-generated `/etc/ssh/vpn-server-key` private key to clients, save as `~/.ssh/vpn-default-key`

2. **Connected**：
   ```bash
   sshuttle --ssh -i ~/.ssh/vpn-default-key" -r vpn-tunnel@10.0.1.90 0.0.0.0 / 0
   ```

#### Program B：Certificate Authentication (safer, fit for production)

```bash
# Generate CA certificate
sudo ssh-keygen -t 25519-f /etc/ssh/ca_key -N ""

# Signed VPN user certificate (30 days)
sudo ssh-keygen -s /etc/ssh/ca_key -I "vpn-cert" -n vpn-tunnel -V +30d /home/vpn-tunnel/. sh/authorized_keys

# Clients only trust CA public key to connect
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

| Security Level                | Means of implementation                                                                                               |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| **Network Isolation**         | Server binding VPN dedicated web card, only SSH port                                                                  |
| **Key Wheels**                | Automatically update server keys with cron per week, client scripts synchronize to get new keys                       |
| **Connect to Audit**          | Server records all VPN connection logs to `/var/log/ssh-vpn.log`                                                      |
| **Traffic Limits**            | Use iptables to limit bandwidth and concurrent connections per client                                                 |
| **Two-factor authentication** | Integrate Google Authenticator implements dynamic passwords (need to modify SSH PAM configuration) |

---

### Programme comparative advantages

| Features                   | Pre-shared key scheme                | Certification Scheme                          |
| -------------------------- | ------------------------------------ | --------------------------------------------- |
| Deployment Complex         | Low (small team)  | Medium (CA Admin required) |
| Security                   | Dependency on key custody            | Auto-Expire + Revocation List                 |
| Client Update Requirements | Key changes need to be redistributed | No client needs to be updated                 |
| Scene                      | Internal test/temporary use          | Production environment/long-term transport    |

---

### VMM Recommendations

1. **Status Check Script** (`check-vpn.sh`)

```bash
#!/bin/bash
# Check active connection
netstat -tn | grep ':22' | grep ESTABLISHED

# Monitor traffic
vnstat -i tun0 -tr 5

# Auto-reboot (if process does not exist)
pgrep shutt|| /path/to/vpn-connit
```

2. **Prometheus Monitoring Indicator**

```yaml
# Exposes SSH tunnel indicator
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

2. **Emergency port switch**

```bash
# Use socat temporary redirect traffic
socat TCP-LISTEN:22222,fork TCP/10.0.1.90:22
```

3. **Full Traffic Capture Analysis**

```bash
sudo tcpdp -i tun0 -w vpn-traffick.pcap
```

---

With this scheme, you will get：

- **Client**：doesn't need to manage keys, one-click connection
- **Server**：Automated Key Life Cycle Management
- **Security**：Corporate Protection and Monitoring Capabilities
- **Vitary**：Good Emergency and Audit Mechanisms

Pre-shared keys or certificate certification schemes can be selected on the basis of actual needs, balancing security with ease of use.
