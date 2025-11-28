# Disk Related Usage

## Can SFTP be automatically mounted on local disk via ssh configuration and via ssh connection?

- Profile path: `~/.ssh/config`

```bash
Host myserver
    HostName example.com
    User your_username
    Port 22
    IdentityFile ~/.ssh/id_rsa

```

- Mount remote directory using sshfs

```bash
# On macOS, you can install：
brew install sshfs
# on Linux, Install：
sudo apt install sshfs # Debian/Ubuntu
sudo yum install sshfs # CentOS/RHEL

# Mount remote directory
sshfs myser:/remote/path /local/mountpoint
```

- Macos Installation sshfs Failed Solutions

```bash
brew install --cask macfuse
brew install --cask sshfs-mac

```

- Auto-mount

```bash
# Use the systemd service (Linux)
sudo nano /etc/systemd/system/mnt-myser.service

# Add the following to：
[Unit]
Description=Mount remote directory via SFTP
After=network. arget

[Service]
Type=simple
ExecuecStart=/usr/bin/sshfs myserver:/remote/path /local/mountpoint
ExecStop=/bin/fusermount -u /local/mountpoint
Restart=on-failure

[Install]
WantedBy=multi-user. arget

# Enable and start service：
sudo systemctl daemon-reload
sudo systemctl enabling mnt-myser.service
sudo systemctl start mnt-myser.service

```

```bash
# 使用launchd（macOS）
nano ~/Library/LaunchAgents/com.example.mountmyserver.plist

# 添加以下内容：
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.example.mountmyserver</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/sshfs</string>
        <string>myserver:/remote/path</string>
        <string>/local/mountpoint</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>

# 加载并启动服务：
launchctl load ~/Library/LaunchAgents/com.example.mountmyserver.plist

```

```bash
# 使用autossh方式

# 在macOS上，可以使用Homebrew安装：
brew install autossh
# 在Linux上，可以使用包管理器安装：
sudo apt install autossh  # Debian/Ubuntu
sudo yum install autossh  # CentOS/RHEL

# 在~/.bashrc或~/.zshrc中添加以下内容：
autossh -M 0 -f -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -L 2222:localhost:22 myserver

# 使用 autossh 运行 sshfs
autossh -M 0 -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null your_username@example.com /usr/bin/sshfs -o allow_other,default_permissions myserver:/remote/path /local/mountpoint

# -M 0：禁用 autossh 的监控端口，使用 SSH 内置的保持连接功能。
# -o "ServerAliveInterval 60" 和 -o "ServerAliveCountMax 3"：配置 SSH 保持连接的参数。
# -o StrictHostKeyChecking=no 和 -o UserKnownHostsFile=/dev/null：简化连接（注意：在生产环境中应谨慎使用，以避免安全风险）。
# your_username@example.com：替换为您的 SSH 连接信息。
# /usr/bin/sshfs：sshfs 的路径。
# -o allow_other,default_permissions：允许其他用户访问挂载点，并应用默认权限。
# myserver:/remote/path：远程路径。
# /local/mountpoint：本地挂载点。

```

> Current Method[CloudMounter破解版](https://macwk.cn/app/1321.html)
