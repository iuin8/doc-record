## Create 6 Redis Container

```shell
docker create --name redis-node1 --net host -v /data/redis-data/node1:/data redis:5.0.5 --cluster-enabled yes --cluster-config-file nodes-1.conf --port 639

docker create -name re-no-node2 --net host -v /data/redis-data/node2:/data redis:5. 5 --cluster-enabled yes --cluster-config-file nodes-2.conf -port 6380

docker create -name redis-node3 --net host -v /data/read-data/node3:/data redis:5.0.5 -cluster-enabled --cluster-config-file node-3. onf --port 631

docker create --name redis-node4 --net host -v /data/redis-data/node4:/data redis:5.0.5 --cluster-enabled yes --cluster-config-file node-4. onf --port 632

docker create --name redis-node5 --net host -v /data/redis-data/node5:/data redis:5. .5 --cluster-enabled yes --cluster-config-file nodes-5.conf --port 633

docker create --name redis-node6 --net host -v /data/read-data/node6:/data dis:5.0.5 -cluster-enabled yes --cluster-config-file node-6.conf -port 634
```

- Some parameters played in：

```
--cluster-enabled：start cluster, select：yes or no
--cluster-config-file config. onf ：specify node information, generate
--cluster-node-timeout time： configure node timeout time
--appendonly：turn on, select：yes, no
```

## Start Redis

```shell
docker start remdis-node1 remdis-node2 remdis-node3 redis-node4 remdis-node5 remdis-node6
```

## Organization Redis Cluster

```shell
# There in the case of remdis-node1 instance
docker exec -it redis-node1 /bin/bash
# Formation of clusters, 10. 11.55.4 as the current physical machine ipaddress
redis-cli --cluster create 10.211.55.4:6379 10.211.55.4:6380 11.55.4:632 10.211.4:632 10.211.55.4:6383 10.211.55.4:6384 --cluster-replas 1
# After successfully created, see cluster node information：
root@CentOS7:/data# re-cli
127.0.1:637> cluster nodes
```

## About Redish Classes

```shell
# Manually add nodes
redis-cli --cluster add-node 10.211.55.4:6383 10.211.55.4:6379-cluster-sleve -cluster-master-id b0c32b1dae9e7f7f4b744354c59bfcaa46f30a

redis-cli --cluster add-node 10.211.55.4:6379-cluster - cloud-master-id 111de8ed572585 cef5c4b5225ecb15a582e
```
