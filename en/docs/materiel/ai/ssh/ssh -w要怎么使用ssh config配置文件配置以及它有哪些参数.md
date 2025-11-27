# ssh -w how to use ssh config configuration configuration and what parameters it has

Below is a detailed description of how to use the `-w` parameter (tunnel device forward) in the SSH configuration file, including the parameter explanation and configuration example：

---

### **1. Roles and syntax of the `ssh-w` parameter**

- **Function**：creates TUN/TAP virtual network interfaces to implement tunnels at network level (L3) or data link layer (L2).
- **Syntax**：
  ```bash
  ssh -w <local_tun>:<remote_tun> user@host
  ```
  - `<local_tun>`：Local TUN device number (e.g. `0` for `tun0`).
  - `<remote_tun>`：Remote TUN device number (e.g. `0` for `tun0`).
  - Special value `any`：allows the system to automatically assign device numbers (e.g. `-w 5:any`).

---

### **2. The `Tunnel` directive in the SSH configuration file**

Use `Tunnel` parameter to configure tunnel device： in `~/.ssh/config`

```bash
Host my-tunnel-host
  HostName remote-server. om
  User root
  # Tunnel device configuration
  Tunnel 0:0# Price in command line -w 0:0
  TunnelDevice 0:0# (optional) explicitly specified device number
  # Other necessary parameter
  IdentityFile ~/. sh/id_rsa
  Permit LocalCommand yes
  # Stay connected to
  ServerAliveInterval 60
  ServerAliveCountMax 3
```

#### **Key Parameter Description**：

| **Parameters**       | **Effects**                                                                                                                                             |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Tunnel`             | Specify a local and remote TUN device number, format `<local>:<remote>`(e.g. `0:0`). |
| `TunnelDevice`       | An explicit bound (partially supported) to a specific device number, similar to `Tunnel`.                            |
| `PermitTunnel`       | Set to `yes` in the server `sshd_config`, otherwise tunnels cannot be built (see below).                             |
| `PermitLocalCommand` | Allows to execute commands locally (e.g. auto-configure IP address).                 |

---

### **3. Server configuration (required)**

Enable tunnel support for： on remote server `/etc/ssh/sshd_config`

```bash
PermitTunnel yes # Allow TUN/TAP tunnels
```

Restart SSH service to take effect on：

```bash
sudo systemctl start sshd
```

---

### **4. Use a step example**

#### **(1) Establishment of SSH tunnel**

```bash
ssh -w 0:0 root@remote-server.com
```

#### **(2) Configure Virtual Interface IP Address**

- **Local**：
  ```bash
  sudo ip addr add 10.0.0.1/24 dev tun0
  sudo ip link set tun0 up
  ```
- \*\*Remote \*\*：
  ```bash
  sudo ip addr add 10.0.0.2/24dev tun0
  sudo ip link set tun0 up
  ```

#### **(3) Test connection**

```bash
ping 10.0.0.2 # Local ping local tunnel IP
```

---

### **5. Advanced Usage：Automatic Configuration**

Add `LocalCommand` to the SSH profile, auto-complete IP assignment：

```bash
Host my-tunnel-host
  HostName remote-server. om
  User root
  Tunnel 0:0
  PermitLocalCommand yes
  LocalCommand sudo ip addr 10. .0.1/24 dev tun0 && sudo ip link set tun0 up
```

---

### General questions and attentions\*\*

1. **Permissions**：
   - Require `root` permission to create TUN/TAP devices and recommend running SSH commands with `sudo`.
   - You need to configure \`CAP_NET_ADMINISTRATIVE ALL： if you use normal users.
     ```bash
     sudo setcap cap_net_admin=step /usr/bin/ssh
     ```

2. **OS Support**：
   - **Linux**：native support TUN/TAP.
   - **macOS**：needs to be installed [TUN/TAP Driver](https://tuntaposx.sourceforge.net/).
   - **Windows**：needs to install the OpenVPN `tap-windows` driver.

3. **Protocol select**：
   - TUN mode (default)：transfer IP packet (L3).
   - TAP mode：transfer in ethernet (L2), explicitly specified：
     ```bash
     ssh -o Tunnel=ethernet -w 0:0 user@host
     ```

---

### **7. Full configuration example**

```bash
# ~/.ssh/config
Host vpn-tunnel
  HostName vpn.example.com
  User root
  IdentityFile ~/. sh/vpn_key
  Tunnel 0:0
  PermitLocalCommand yes
  LocalCommand sudo ip addr 10. .0.1/24 dev tun0 && sudo ip link set tun0 up
  Removal Command sudo ip addr ad 10.0.0. /24 dev tun0 && sudo ip link set tun0 up
  ServerAliveInterval 30
  RequestTTY yes # allows remote command (RemoteCommand)
```

---

### **Summary**

- **`-w` parameter**：for creating TUN/TAP tunnel. Use the `Tunnel` directive in the configuration file.
- **Core step**：Enables `PermitTunnel`, Clients configure tunnel devices and assign IPs.
- **Apply Scene**：builds VPN, cross-network transparent proxies, and supports UDP fullprotocol forwarding.
