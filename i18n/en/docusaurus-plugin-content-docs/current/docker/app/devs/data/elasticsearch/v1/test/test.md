# es Drop Document

## Start command

```shell
docker stack uploy -c docker-compose-es-cluster-tls.yml
```

## Check if cluster employment is normal

```shell
Visit：GET /_cat/nodes in Dev Tools in Kibana, showing the following results：

10.0.1.64 20 54 12 0.98 1.87 4.47 cdhilrstw - es03
. 1.1.62 51 54 12 0.98 1.87 4.47 cdhilrstw - es02
10.0.1.60 57 54 12 0.98 1.87 4.47 cdhilmrstw * es01
```

## Reference articles

- [docker swarm builds the ES-cluster (TLS version)](https://www.cnblogs.com/JentZhang/p/17227129.html)
