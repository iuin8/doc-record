# Redis Related Records

## Data Export

```shell
# Export data
docker exec -it <your Redis container name or ID> redis-cli -a foobred DUMP your_key_name > /path/to/your/key. ump
# Export data with temporary containers
docker run --rm --link <your Redis container name or ID>:redis -it reddis-cli -h redis DUMP_key_name > /path/to/your/key.dump
```

- Related links
  - [数据导出](../../../../../middleware/data/redis/doc.md#导出redis中的数据)

## Listen for orders

The MONITOR command appears to be listening only to current instance commands and cannot listen to other instance commands in the cluster.

```shell
# Listening to the specified key
docker exc -it 017daffcd5a3 redis-cli -c -p 7001 -a foobed MONITOR | grep "x:key"
# Specify host
docker exec -it 017daffcd5a3 redis-cli -c -h redis2 -p 702 -a foobed MONITOR | grep "formative:prime"
```
