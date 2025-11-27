# Docker Container has no permissions

1. Specify the `--priveed` parameter when creating a docker container

## docker gid view command

[参考地址1](https://www.doubao.com/thread/w9e714164e14f12b9)
[参考地址2](https://github.com/influxdata/sandbox/issues/79)(PPS: something that seems to be used)
[参考地址3](https://github.com/influxdata/sandbox/issues/83)

```bash
stat -c '%g' /var/run/docker.sock
```
