## Install node_exporter

```shell
1、wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
2、tar -zxf node_exporter-1.1.2.linux-amd64.tar.gz -C /usr/local/
3、cd /usr/local/
4、mv /usr/local/node_exporter-1.1.2.linux-amd64/ /usr/local/node_exporter
5、vim config.yml(配置访问的用户名密码，可根据需要跳过这一步)
```

- Use html encryption for html -nBC 12 '' | tr -d ':\n'
- config.yml

```shell
basic_auth_users:
  # The current user named prometheus can set multiple
  # Password encryption htpasswd -nBC 12 '' | tr -d :\n'
  username: password
```

```shell
6, nohor/usr/local/node_exporter/node_exporter --web.config=../config.yml &
nohup ../node_exporter --web.config=../config.yml &
```

## Influxdb Configuration

```shell
# This way to create library
docker exec -it contains name./run-basic.sh
```

## alertmanager configuration

```shell
参数说明：

resolve_timeout: 当告警的状态由firing变为resolve后需要等待多长时间，才宣布告警解除

receivers：定义谁接收告警。

name： 代称，方便后面使用

route：告警内容从这里进入，寻找相应的策略发送出去

receiver：一级的receiver，也就是默认的receiver，当告警进来后没有找到任何子节点和自己匹配，就用这个receiver

group_by：告警应该根据那些标签进行分组

group_wait：同一组的告警发出前要等待多久后才能再次发出去

group_interval：同一组的多批次告警间隔多少秒后，才能发出

repeat_interval：重复的告警要等待多久后才能再次发出去

inhibit_rules：这个叫做抑制项，通过匹配源告警来抑制目的告警。比如说当我们的主机挂了，可能引起主机上的服务，数据库，中间件等一些告警，假如说后续的这些告警相对来说没有意义，我们可以用抑制项这个功能，让Prometheus只发出主机挂了的告警

source_match：根据label匹配源告警

target_match：根据label匹配目的告警

equal：此处的集合的label，在源和目的的值必须相等。如果该集合内的值在源和目的里都没有，那么目的告警也会被抑制
```
