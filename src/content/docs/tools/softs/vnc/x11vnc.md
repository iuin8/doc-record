# x11vnc 配置

```bash
# 在服务器安装并启动x11vnc
apt install -y x11vnc
x11vnc -auth guess -forever -noxdamage -rfbport 5900 -shared
```

## 问题

找不到X11认证文件

```bash
# xauth: file /root/.Xauthority does not exist
# -auth guess: failed for display='unset'

# 正确配置x11vnc共享当前桌面

# 1. 存储VNC密码（首次运行）
x11vnc -storepasswd
# 按提示输入密码，默认保存在~/.vnc/passwd

# 2. 找到正确的X认证文件路径
# 查看当前活跃的X会话
ps aux | grep Xorg | grep -v grep
# 假设输出显示Xorg在运行，使用以下命令启动x11vnc
x11vnc -auth /var/run/gdm3/*/database -forever -noxdamage -rfbauth ~/.vnc/passwd -rfbport 5901 -shared

# 3. 若上述命令失败，尝试自动探测X会话
x11vnc -find -forever -noxdamage -rfbauth ~/.vnc/passwd -rfbport 5901 -shared

# xauth: file /root/.Xauthority does not exist
# wait_for_client: find display cmd failed

# 为root创建临时X会话
# 1. 创建Xauthority文件
touch ~/.Xauthority

# 2. 生成MIT-MAGIC-COOKIE
mcookie | sudo tee -a ~/.Xauthority

# 3. 指定display启动x11vnc
x11vnc -display :99.0 -auth ~/.Xauthority -forever -noxdamage -rfbauth ~/.vnc/passwd -rfbport 5901 -shared -usepw

# 修复gem用户账户（推荐）
# 检查用户完整性
pwck gem

# 修复用户账户
useradd -u 1000 -g 1000 -d /home/gem -s /bin/bash gem

# 重新尝试切换用户
su - gem
```

```bash
# 创建新的虚拟桌面会话
vncserver :1 -geometry 1920x1080 -depth 24

# 然后连接这个新会话
x11vnc -display :1 -auth ~/.vnc/passwd -forever -noxdamage -rfbport 5901 -shared
```
