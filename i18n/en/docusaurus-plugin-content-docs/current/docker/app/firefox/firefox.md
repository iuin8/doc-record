# firefox browser instructions

## 1. Install

```shell
##### kasmweb version (recommended)
# The Container is now accessible via a brower: https://IP_OF_SERVER:690
# User : kasm_user
# Password: password
docker run --rm -it --shm-size=512m -p 6901:6901-e VNC_PW=password kasmweb/firefox:1. 4.0
```

- Container image available for mac's docker

[仓库地址](https://github.com/jlesage/docker-firefox)

```bash
# Simple command
docker run -d --name=firefox -p 5800:5800 -e LANG=en_CN. TF-8 -e ENABLE_CJK_FONT=1 jlesage/firefox

# VNC version
docker run -d --name firefox -e TZ=Asia/Hong _Kong -e LANG=en_CN. TF-8 - e KEEP_APP_RUNNING=1 - e ENABLE_CJK_FONT=1 - e VNC_PASSWORD=admin -p 5800:5800 - p 5900:559 -v /data/firefox/config:/config:rw --shm-size 2g jlesage/firefox

```

## Related Articles

- [Docker's self-construction browser：gives you access to web devices such as Wizard Route Nas](https://mp.weixin.qq.com/s/8jzfNUlqhnnjjrkbbh0o-Q)
