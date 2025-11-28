# Logsash usage

## Install

- Helm Installation
  - [参考文章](https://segmentfault.com/a/1190000044266596)

```shell
help repo add bitnami https://charts.bitnami.com/bitnami
helm search logstash
helm null bitnami/logstash

```

- Profile
  - [values.yaml](./config/6.0.3-values.yaml)

```shell
help install -f ./config/6.0.3-values.yaml logstash bitnami/logstash --namespace midleware
helm install all logstash bitnami/logstash --namespace middle leware

```
