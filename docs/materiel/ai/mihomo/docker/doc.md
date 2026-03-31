# mihomo docker 配置

## 关于本地内网IP用域名的问题

### 🛠️ 方案一：清空 systemd-resolved 缓存（推荐）⭐


方法 1：重启 systemd-resolved 服务（最简单）

```bash
# Ubuntu系统
# 重启服务（会清空所有 DNS 缓存）
sudo systemctl restart systemd-resolved

# 验证服务状态
sudo systemctl status systemd-resolved
```

方法 2：使用 resolvectl 命令（更优雅）

```bash
# 清空所有缓存
sudo resolvectl flush-caches

# 查看缓存统计（确认已清空）
sudo resolvectl statistics
```

### 🔍 第二步：验证域名解析是否更新

```bash
# 1. 使用 resolvectl 查询（绕过本地缓存，直接问上游）
resolvectl query mbp-fa.tx.iuin888vip.icu

# 4. 对比系统解析结果（可能仍有缓存）
getent hosts mbp-fa.tx.iuin888vip.icu
```

2️⃣ 检查域名 TTL 设置

```bash
# 查询域名的实际 TTL 值
dig mbp-fa.tx.iuin888vip.icu +nocmd +noall +answer

# 输出示例：
# mbp-fa.tx.iuin888vip.icu.  300  IN  A  203.0.113.50
#                              ↑
#                        TTL=300 秒（5 分钟）
```
