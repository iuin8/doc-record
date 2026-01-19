# TigerVNC

```bash
# 安装TigerVNC服务器和密码工具
sudo apt update
sudo apt install -y tigervnc-standalone-server tigervnc-tools

# 首次运行需设置密码（会生成~/.vnc/passwd）
vncpasswd

# 创建1920x1080分辨率、24位色深的VNC会话（显示端口:1）
vncserver :1 -geometry 1920x1080 -depth 24

```

```bash
# 启动支持局域网访问的VNC服务
# 使用TigerVNC启动，明确指定不限制本地访问
Xtigervnc :1 -geometry 1920x1080 -depth 24 -rfbport 5901 -localhost no -SecurityTypes VncAuth -passwordfile ~/.vnc/passwd

# 或使用标准vncserver命令（如已安装完整TigerVNC）
vncserver :1 -geometry 1920x1080 -depth 24 -localhost no
```

```bash
# 永久配置方案

# 1. 创建VNC配置目录
mkdir -p ~/.vnc

# 2. 创建正确的xstartup脚本（关键修复）
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
# exec startxfce4 &  # 使用XFCE桌面环境（轻量且稳定）
# 启动基本X终端和窗口管理器
xterm -geometry 80x24+10+10 -ls -title "VNC Terminal" &
twm &
EOF

# 3. 添加执行权限
chmod +x ~/.vnc/xstartup

# 4. 设置VNC密码（必须步骤）
vncpasswd
# 输入并确认密码（不会显示输入内容）

# 创建VNC配置文件
mkdir -p ~/.vnc
cat > ~/.vnc/config << 'EOF'
geometry=1920x1080
depth=24
localhost=no
rfbport=5901
EOF

# 设置VNC密码
vncpasswd

# 创建systemd服务实现开机自启
sudo tee /etc/systemd/system/vncserver@.service << 'EOF'
[Unit]
Description=TigerVNC Server on %i
After=syslog.target network.target
[Service]
Type=forking
User=pengdd
Group=pengdd
WorkingDirectory=/home/pengdd
PIDFile=/home/pengdd/.vnc/%H%i.pid  # 添加PID文件路径
# 修复启动命令，添加-xstartup指定会话脚本
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver %i -geometry 1920x1080 -depth 24 -localhost no -xstartup /home/pengdd/.vnc/xstartup
ExecStop=/usr/bin/vncserver -kill %i
[Install]
WantedBy=multi-user.target
EOF

# 启用并启动服务
sudo systemctl daemon-reload
sudo systemctl enable vncserver@:1
sudo systemctl start vncserver@:1
```

```bash
# 常用管理命令

# 列出所有VNC会话
vncserver -list

# 终止指定会话（:1为显示编号）
vncserver -kill :1

# 带日志启动（排障用）
vncserver :1 -geometry 1920x1080 -depth 24 -log ~/vncserver.log
```
