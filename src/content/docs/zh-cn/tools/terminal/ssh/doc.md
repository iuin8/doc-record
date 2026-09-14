# ssh使用记录

## SSH X11转发使用指南

```bash
# 服务器端配置（远程主机）
# 编辑SSH配置文件
sudo nano /etc/ssh/sshd_config  

# 确保以下参数设置为yes（取消注释并修改）
X11Forwarding yes  
X11DisplayOffset 10  
# 开启这个配置就只能通过localhost连接, 其他IP连接会失败
X11UseLocalhost no
# 这个看情况是否需要配置
AddressFamily inet  # 强制使用IPv4（避免IPv6冲突）

# 重启SSH服务使配置生效
sudo systemctl restart sshd
```

```bash
# 客户端连接（本地计算机）
# 基础命令（-X：安全模式，-Y：信任模式）
ssh -Y username@远程服务器IP

# 示例：连接名为"server"的主机
ssh -Y alice@192.168.1.100  
```

```bash
# 连接成功后，直接在远程终端输入图形程序名称即可：
# 测试命令（需服务器安装x11-apps）
xclock   # 显示简单时钟窗口（验证X11是否正常工作）  
xeyes    # 显示跟随鼠标的眼睛动画  
gedit    # 启动文本编辑器  
firefox  # 运行浏览器（远程渲染，本地显示）  
```

```bash
# 必备条件与故障排查
# 服务器端依赖
# 安装X11相关工具（ Ubuntu/Debian ）
sudo apt install xauth x11-apps  

# 高级技巧
# 压缩传输：慢网络环境下启用压缩（-C参数）：
ssh -YC username@远程IP  # -Y信任模式 + -C压缩  
# 多窗口管理：结合screen或tmux保持程序后台运行，断开SSH后重连仍可恢复窗口。

```

```bash
# Mac客户端配置（关键步骤）
# 1. 安装XQuartz（Mac必备X服务器）
brew install --cask xquartz

# 2. 启动XQuartz并配置
open -a XQuartz
# 在XQuartz偏好设置→安全性中勾选"允许从网络客户端的连接"

# 3. 重启终端后重新连接
ssh -Y pdd.intranet.company

# 4. 验证DISPLAY变量
echo $DISPLAY  # 应显示类似 localhost:10.0
```

```bash
# Firefox打不开窗口的问题
# 方式一: 允许Snap访问X11（推荐）
# 给Firefox snap添加X11权限
sudo snap connect firefox:x11

# 然后重新启动Firefox
firefox

# 方式二: 使用非Snap Firefox
# 先停止当前的snap firefox
sudo snap remove firefox

# 安装deb版本的firefox
sudo apt update
sudo apt install firefox

# 测试
firefox

# 方法3：临时绕过Snap限制
# 使用--no-sandbox参数启动
firefox --no-sandbox

# 或者设置环境变量
export MOZ_DISABLE_CONTENT_SANDBOX=1
firefox

# 方法4：使用其他浏览器测试
# 安装并测试Chromium
sudo apt install chromium-browser
chromium-browser
```

```bash
# chromium-browser打不开窗口的问题
# 修复缺失的共享库
# 安装X11基础依赖库（覆盖libpxbackend相关组件）
sudo apt update && sudo apt install -y \
  libx11-dev libxext-dev libxrender-dev \
  libxtst-dev libxi-dev libxrandr-dev \
  libgl1-mesa-glx libglu1-mesa

# 检查库文件是否存在
sudo find /usr/lib -name "libpxbackend*"

# 为Chromium添加X11权限
sudo snap connect chromium:x11

# 验证权限是否生效
snap interfaces | grep chromium:x11

# 方法5：检查DISPLAY和XAUTHORITY变量
echo $DISPLAY $XAUTHORITY
export DISPLAY=localhost:10.0
chromium-browser --no-sandbox --disable-setuid-sandbox

# 方法6：完全绕过Snap限制
# 方法A：安装Firefox ESR（非Snap）
sudo apt update
sudo apt install firefox-esr

firefox-esr

# 方法B：安装Chromium deb版本
sudo apt install chromium-browser

# 方法C：安装其他轻量级浏览器
sudo apt install epiphany-browser  # GNOME Web
sudo apt install midori

# 完全绕过Snap限制
# 临时禁用Snap安全特性
sudo snap set core experimental.xdg-desktop-portal=false

# 或者使用--no-sandbox
chromium-browser --no-sandbox --disable-setuid-sandbox

sudo apt install libgtk-3-0  # 确保GTK库完整

```

```bash
# 移除 Snap 版 Firefox：
sudo snap remove firefox
# 添加 Mozilla 官方 PPA 源：
sudo add-apt-repository ppa:mozillateam/ppa
# 设置优先级（防止系统自动装回 Snap）： 执行以下命令创建一个配置文件：
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
# 安装原生 Firefox：
sudo apt update
sudo apt install firefox

# 使用独立模式启动 (推荐)
firefox --no-remote --new-instance
# 或者，如果还是报错，可以尝试指定一个新的 Profile：
firefox -P
# 重启 Firefox 确保 Profile 生效
sudo killall -9 firefox
firefox --no-remote

# 创建新配置文件
firefox -CreateProfile "newprofile"

# 使用新配置文件启动
firefox -P "newprofile"
```

```bash
# 赋予 Snap 特权权限（不一定成功）
sudo snap refresh firefox --channel=stable/pkg-testing
# 注意：即便如此，Snap 在处理 X11 转发路径（如 /tmp/.X11-unix）时依然经常出错。
```

```bash
# 处理OpenGL/图形警告（可选）
# 安装OpenGL和Mesa图形库
sudo apt update
sudo apt install -y mesa-utils libgl1-mesa-dri libglx-mesa0

# 验证图形配置（非必需，仅用于确认）
glxinfo | grep "direct rendering"  # 输出"direct rendering: Yes"表示正常
```

```bash
# 安装原生 Google Chrome (非 Snap 版)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
google-chrome --no-sandbox
# 强制新实例：  (这会给 Chrome 指定一个临时文件夹存放数据，避开所有权限冲突。)
google-chrome --user-data-dir=/tmp/chrome-remote --no-sandbox
# --disable-gpu: 在远程 SSH 环境下，禁用硬件加速能大幅提高稳定性，减少闪退。
google-chrome --no-sandbox --user-data-dir=/tmp/chrome_test --disable-gpu
```

```bash
# 方法4：使用VNC
# 启动VNC服务器
vncserver :1 -geometry 1920x1080 -depth 24

# 从Mac连接
open vnc://master1:5901
```
