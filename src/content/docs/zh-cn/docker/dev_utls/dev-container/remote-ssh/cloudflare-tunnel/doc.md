# cloudflare tunnel使用记录

[官方下载文档](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/)

## 安装

```bash
# macos
brew install cloudflared
```

> PS: 这种方式暂时不搞了, 国外的渠道, 延迟估计不小
> 做了, 用作备选方案

## 配置

![docker3](https://github.com/iuin8/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/cloudflare-tunnel/imgs/cloudflare-tunnel-ssh.png?raw=true)

> PS: 创建隧道的时候, 填完子域名, 点击保存后, 会自动创建DNS记录, 所以有的时候, 不小心把DNS删了的话, 会导致隧道连接失败, 这时就需要重新创建新的隧道让它重新创建DNS记录了
