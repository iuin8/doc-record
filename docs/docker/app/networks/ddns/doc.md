# ddns使用记录

## nat类型检测

[nat类型检测网页版](https://mao.fan/mynat)

```bash
# 检测nat类型
docker run --rm --network host python:3.12.12-alpine3.23 /bin/sh -c "pip install pystun3 && pystun3"
```

## TODO

- 看看这个项目是否能用上[ddns-go](https://github.com/jeessy2/ddns-go)
- 看看cloudflare的ddns服务
