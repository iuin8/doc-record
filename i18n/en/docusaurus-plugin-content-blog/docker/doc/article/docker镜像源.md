# Docker Mirror

[参考文章](https://developer.aliyun.com/article/653081)

```bash
# Docker Official Chinese Area
# https://registry.docker-cn.com
# Internet trade
# http://hub-mirror.c.163.com
# ustc
# https://docker.mirrors.usc. n

# Test mirror Source
docker run --rm hello-world --registry-mirror=https://registry.docker-cn.com
docker run --rm hello-world --registry-mirror=http://hub-mirror. m
docker run --rm hello-world --registry-mirror=https://docker.mirrors.ustc.edu.cn

docker run --rm node:14.21.1 - slim --registry-mirror=https://registry.docker-cn. om
docker run --rm node:14.21.1 - slim --registry-mirror=http://hub-mirror.c.163.com
docker run --rm node:14.21.1 - slim --registry-mirror=https://docker.mirrors.ustc.edu.cn

```

- Latest available docker image sources
  - docker.fxk.dedyn.io
    - Work by Cloudflare Workers, feel useful
    - [相关博客](https://blog.cmliussss.com/p/CF-Workers-docker.io/)
  - Down docker Mirror
    - [docker镜像源](https://cf-workers-docker-io-ac6.pages.dev/)
