# Redis Related Records

## Export data in Redis

```shell
# Connect Redis
redis-cli -h 127.0.0. - p 6379-a foobared
# Export keys to file
keys "*" | xargs remdis-cli get > /tmp/redis_data. xt
# Export specified key data to
re-cli get key > /tmp/redis_data. xt
# Use DUP command to export the specified key
remove-cli dump key > /tmp/redis_data.txt
```

- Related links
  - [docker数据导出](../../../docker/app/devs/data/redis/doc.md#数据导出)
