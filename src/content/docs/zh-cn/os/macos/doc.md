# macos

## FreeRDP

```bash
brew install freerdp
# 在能连集群的机器上：
kubectl port-forward svc/windows 3389:3389 -n default
# Mac 上连接：
xfreerdp /v:127.0.0.1:3389 /u:Docker /p:admin /dynamic-resolution
```

```bash
# 继续用 xfreerdp → 装 XQuartz（能用，但体验一般）
brew install --cask xquartz
open -a XQuartz          # 启动 X 服务器（首次安装建议注销重登一次）
export DISPLAY=:0       # 这个命令的作用是告诉 xfreerdp（以及其他所有 X11 图形程序）应该把窗口画在哪个显示器屏幕上。:0 的含义：代表当前系统中的第一个本地物理显示器（屏幕）。
xfreerdp /v:windows.default.svc.cluster.local:3389 /u:Docker /p:admin /dynamic-resolution /clipboard
```

```bash
# Ubuntu
export DISPLAY=:0 && xfreerdp /v:10.0.5.xxx /u:xxx /dynamic-resolution +clipboard /d:WORKGROUP /cert:ignore

# /cert:ignore 参数用于忽略 Ubuntu 自签证书的安全警告。*
# /f：全屏模式（退出全屏按 Ctrl+Alt+Enter）。
# +clipboard：启用双向剪贴板（支持复制粘贴文本）。
# /dynamic-resolution：自适应分辨率，缩放窗口时自动调整 Ubuntu 分辨率。

# /d:WORKGROUP：指定工作组为 WORKGROUP（Ubuntu 默认工作组）。如果连接仍不成功，可以尝试完全移除 /d 参数。
# /cert:ignore：（警告：仅限安全局域网） 彻底忽略一切 SSL/TLS 证书校验。在无外网的纯净 LAN 中，这可以跳过由于自签名证书导致的连接中断。
```
