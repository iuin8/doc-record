# How to mount holders in server containers via nfs into local macs

To mount the folder in the server container, via NFS into the local Mac computer, You need to complete the configuration of the server (host) and the customer (Mac) below：

### **I, server configuration (Linux host)**

1. **Install NFS service**  
   install NFS service on server (not in container)：
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install nfs-kernel-server

   # CentOS/RHEL
   sudo yum install nfs-utils
   ```

2. **Directory to share**  
   assurances that the directory in the container is `/container/data` and is mounted to the host `/host/data` via `-v /host/data:/container/data`. e need to share the `/host/data` of the host：
   ```bash
   # Ensure directory exists and set permissions to
   sudo mkdir - p /host/data
   sudo chmod 777/host/data # Simplified permissions. Production environments need to be carefully configured.
   ```

3. **配置 NFS 共享**  
   编辑 NFS 配置文件 `/etc/exports`，添加允许 Mac 访问的规则：
   ```bash
   sudo nano /etc/exports
   ```
   Add content (place `MAC_IP` with your Mac local IP)：
   ```
   /host/data MAC_IP(rw,sync,no_subtree_check,insecure)
   ```
   - `rw`：write permissions
   - `sync`：Sync write to disk
   - `insecure`：allows non-standard ports (Mac may require)

4. **Effective configuration and restart services**
   ```bash
   # Refresh shared configuration
   sudo exports --a

   # Restart NFS service
   sudo systemctl start nfs-kernel-server # Ubuntu/Debian
   # or
   sudo systemctl start nfs-server # CentOS/RHEL
   ```

5. **Open Firewall Ports**  
   to allow NFS related ports (2049, 111 etc.)：
   ```bash
   # UFW Firewall (Ubuntu)
   sudo ufw from MAC_IP to any port nfs
   sudo ufw allow 111/tcp
   sudo ufw allow 111/udp
   ```

### **Secondary , Mac Client Configuration**

1. **Create local mount point**  
   to create a directory on Mac to mount：
   ```bash
   mkdir -p ~/nfs_mount
   ```

2. **Mount NFS shared**  
   mount using `mount` command (replace `SERVER_IP` with the server IP)：
   ```bash
   sudo mount -t nfs SERVER_IP:/host/data ~/nfs_mount
   ```

3. **Verify mount**  
   to see if the mount was successful：
   ```bash
   df -h # View mount information
   girls ~/nfs_mount # view shared directory content
   ```

### **iii. Unmount (optional)**

Execute： when disconnecting is required

```bash
sudo amount ~/nfs_mount
```

### **Caution**

1. **Container with Host**：must ensure that the directory inside the containing is properly mounted to the host, or NFS shares a host directory.
2. **Permissions Questions**：Check the server directories (`chmod`) and the `rw` option in the NFS configuration.
3. **IP address**：Mac and server need to be on the same network, and IP addresses need to be correct (Mac Local IP can be viewed via `ifconfig`).

With the above steps, direct access to files in server containing on Mac is available.
