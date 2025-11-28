以下是对命令 `ssh -o GatewayPorts=yes -D 2000 test-2023.intranet.company -NTfCg` 的逐项解析和完整说明：

---

### **Command summary functions**

This command establishes a **live port to forward tunnel** (SOCKS5 proxy) via SSH and binds to all local network interfaces, allowing remote hosts to access target network resources through that proxy.Specific uses include：

- Use the local `2000` port as the proxy entry, traffic is forwarded via the `test-2023.intranet.company` server.
- Remote host (non-native) connection to local `2000` port is supported (via `-g` and `GatewayPorts=yes`).
- The background is quiet running without terminal interaction and suitable for long-term stable proxy needs.

---

### **Parameter parsed item**

#### **1. `-o GatewayPorts=yes`**

- **Effects**：allows remote hosts to connect to local forwarding ports.
- **Default behaviour**：SSH binds local ports to `127.0.0.1` (local access only).
- **Enabled**：binds to `0.0.0.0` (all network interfaces), allowing other hosts to access `2000` ports via local IP
- **Typical scenario**：requires that local agents be shared with other devices in the local area network (e.g. phones, tablets).

---

#### **2. `-D 2000`**

- **Effects**：enables dynamic port forwarding (SOCKS5 proxy), listening to local `2000` port.
- **Traffic Rules**：All traffic sent to `2000` ports will be encrypted via SSH tunnels and forwarded to the destination network.
- **Port select**：
  - The port of `<1024` requires permission to `root` (e.g. `-D 80`).
  - `2000` is a user level port without privileges.

---

#### **3. `test-2023.intranet.company`**

- **Effects**：specifies the SSH connected target server.
- **Supplementary description**：
  - Ensure that the domain name is correctly resolved (e.g. via DNS or `/etc/hosts` configuration).
  - If authenticated using a key, you need to configure `~/.ssh/config` in advance or specify a private key via `-i`.

---

#### **4. `-N`**

- **Effects**：does not perform remote command, only tunnels.
- **Usage**：applies to purely port forward scenes, without starting a remote Shell.

---

#### **5. `-T`**

- **Effects**：disables the distribution of pseudo-terminals (PTY).
- **Use**：further reduces resource usage, ensuring connection is only used for forwarding.

---

#### **6. `-f`**

- **Effects**：turns SSH process into the background.
- **Action Tip**：
  - To terminate the background process, `ps aux | grep ssh` can be used to search for PIDs after `fill <PID>`.
  - When combined with `-f`, enter the password in the command in advance (e.g. using a key or no password).

---

#### **7. `-C`**

- **Effects**：enables compression (based on gzip algorithms).
- **Apply Scene**：
  - Reduces transmission data when network bandwidth is low (e.g. mobile network).
  - Transfer a lot of text data (e.g. log, code).
- **Not applicable to scenario**：
  - High-speed local area network environment (compression may increase delay).
  - Encrypted or pre-compressed data (e.g. video, image).

---

#### **8. `-g`**

- **Effects**：allows remote hosts to connect to local forwarding ports (duplicated with the `GatewayPorts=yes` function but double guarantee).
- **Historical background**：is an equivalent command line option to implement the `GatewayPorts=yes` in the old SSH version and both can be used in a modern version with a clear intent.

---

### **Full Command Behavior**

```bash
ssh \
  -o GatewayPorts=yes # Allows a remote host to connect to the local port
  -D 2000 \# Dynamically forward to the local port 2000 (SOCKS5)
  test-2023. ntranet. ompany # Destination Server
  -N # Do not execute Remote Command
  -T # Do not assign Terminal
  -f # Run
  -C # Enable compression
  -g # to allow remote host connections
```

---

### **Typical Use Scenaries**

#### **Scene 1：Local Development Agent**

- Browser or app configures SOCKS5 proxy to `127.0.0.0.1:2000`. All traffic is forwarded via `test-2023.intranet.company`.
- When visiting internal services (e.g. `http://internal-app:8080`), traffic reaches the Intranet through tunnels.

#### **Scene 2：shared proxy across devices**

- Run this command in a local PC, the phone or other device sets the proxy to `<PC的IP>:2000`, and access the Intranet via the PC SSH tunnel.

#### **Scene 3：piercing firewall**

- Blocked resources (e.g. access external API) bypassing network restrictions and relying on server export IPs.

---

### **Frequently asked questions**

#### **1. Connection failed：`permission denied`**

- **Reason**：SSH authentication failed (password error, key not configured).
- **Resolve**：
  - Use the `-v` parameter to view the detailed log：`ssh -v...`.
  - Configure key login to：`ssh-copy-id user@test-2023.intranet.company`.

#### **2. Port occupied：`bind: Address already in use`**

- **Reason**：Local `2000` port is used by other processes.
- **Resolve**：
  - Replace port：`-D 2001`.
  - Release port：`lsof -i :2000` to find the occupancy process and abort.

#### **3. Remote host cannot connect to proxy**

- **Reason**：Local Firewall or Router prevents external access to `2000` port.
- **Resolve**：
  - Open Firewall：`sudo ufw allow 2000` (Linux).
  - Check router NAT rules (for public access).

---

### **Extension**

#### **1. Combining ClashX use**

Add SOCKS5 proxy： in the ClashX configuration file

```yaml
proxies:
  - name: "ssh-tunnel"
    type: socks5
    server: 127.0.0.
    port: 2000
    udp: true # Enable UDP Forward

rules:
  - DOMAIN-SFIX, ntranet. ompany,ssh-tunnel
```

#### **2. Maintenance of tunnel stability (cordons)**

Use `autossh` instead of `ssh` to automatically reconnect：

```bash
autosh -M 0 -o "ExitOnForwardFailure=yes" - NTfCg -D 2000 test-2023.intranet.company
```

---

### **Summary**

This command is forwarded via the SSH dynamic port, turning the local `2000` port into a multi-purpose SOCKS5 proxy, suitable for a scenario that requires safe penetration of the Intranet or shared proxy.Optimizing background running, compression, and remote access support via parameter combinations is a practical tool for efficient management of network traffic.
