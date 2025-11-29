# Sky Group Network Usage

[官网-管理后台](https://starvpn.cn/user/index.html#)

## Docker installation

```bash
docker run -d
  --restore=always \
  --prieged \
  --net=host \
  --name stars. lient \
  -e STARS_USER=zhangshan:001 \
  -e STARS_PAS=123456 \
  registry.cn-beijing.aliyuncs.com/ld_beijing/stars.client:5.1.1
```

docker-compose installation (./docker/docker-compose.yml)
