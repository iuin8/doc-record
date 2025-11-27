# telegraf is a record

[相关资料1](https://github.com/influxdata/sandbox.git)
[相关资料2](https://github.com/LinShunKang/MyPerf4J/wiki/Telegraf_)

## Simple Run

```bash
docker run -d --name=telegraf \
    -v $PWD/conf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
    -v /tmp/MyPerf4J/data/logs/MyPerf4J:/tmp/MyPerf4J/data/logs/MyPerf4J:ro \
    telegraf
```
