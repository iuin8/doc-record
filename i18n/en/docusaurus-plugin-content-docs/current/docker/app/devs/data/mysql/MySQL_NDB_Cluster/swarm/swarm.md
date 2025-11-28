# Docker swarm Deploy Document

## Create Network

```shell
# Initialize swarm
# docker swarm init
# This network can not be created and can create
# network creation -d overlay --attachable middle leware by command below.
```

## Start cluster

```shell
docker stack uploy -c docker-compose.yml mysqlCluster
```

## References

- [docker环境安装MySQL-Cluster](http://t.csdnimg.cn/9KmNs)
