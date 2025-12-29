# ddns使用记录

## nat类型检测

[nat类型检测网页版](https://mao.fan/mynat)

```bash
# 检测nat类型
docker run --rm --network host python:3.12.12-alpine3.23 /bin/sh -c "pip install pystun3 && pystun3"
```

## ddns-go

[ddns-go](https://github.com/jeessy2/ddns-go)

用途

- 动态更新域名解析记录到当前公网IP
- 动态更新域名解析记录到当前内网IP
  - 自己家里或者公司的机器的内网IP会自动变的情况可以使用(当然, 只能内网访问)

```bash
docker run -d --name ddns-go --restart=always --net=host -v /opt/ddns-go:/root jeessy/ddns-go
```

```bash
# 子域名的DNS修改(例如: DNS上的子域名(即后缀)为tx.iuin888vip.icu)
fa:tx.iuin888vip.icu
```

## TODO

- 看看这个项目是否能用上[ddns-go](https://github.com/jeessy2/ddns-go)(done)
- 看看cloudflare的ddns服务
