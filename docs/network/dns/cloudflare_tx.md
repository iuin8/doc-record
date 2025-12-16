# cloudflare结合腾讯云edgeone使用记录

- 关键点: 检查腾讯云 EdgeOne 配置
确保 EdgeOne 已正确配置 WebSocket 支持：
登录腾讯云 EdgeOne 控制台
进入站点详情页面
点击 "站点加速" → "网络优化"
找到 "WebSocket 配置"，确保已开启(要不gRPC也一起开启吧, 不确定是不是不开这个也不行)
设置合适的 "最大连接超时时长"（建议 300 秒）

- 域名配置: 回源 HOST 头: 使用源站域名

- 优化 Cloudflared 配置

```bash
# 创建或编辑配置文件
nano ~/.cloudflared/config.yml

# 添加以下优化参数
tunnel: your-tunnel-id
credentials-file: /path/to/credentials.json
protocol: quic  # 使用QUIC协议，比HTTP/2更快
log-level: info
transport-loglevel: info

```
