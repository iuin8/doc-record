# Docker-compose Deploy hadoop Cluster

## Create Network

```shell
docker network create --driver overlay --attachable --subnet 10.11.0.0.24 sg-hadoop
```

## Create Tag

```shell
docker node update --label-add hadoop-datanode=datanode sangang
```

---

## Deploy startup and View

### docker stack deployment started

```shell
docker stack uploy -c docker-compose.yml hadoop
```

### View service status once a second after boot and access the UI via IP：port

```shell
Watch - n 1 docker stack services hadoop
```

### View nodes in service

```shell
docker stack ps hadoop
```

### Stop deleting hadoop service

```shell
docker stack rm hadoop
```
