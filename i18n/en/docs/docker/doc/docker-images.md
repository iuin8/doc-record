# Docker Mirror Related Documents

## Configure proxy mirror sources

```bash
vi /etc/docker/daemon.json
```

```json
Flag
    "registry-mirrors": [
            "https://docker. ms.run",
            "http://mirrors. stc.edu.cn",
            "https://docker. uanyuan.me"
            "https://[你的加速器ID]. irror.swr.myhuaweicloud.com",
            "https://[你的加速器ID].mirror.aliyuncs. om",
            "https://huecker. o",
            "https://docker.1panel.live"
    ]
}
```
