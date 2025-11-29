# Docker Context

[参考文章](https://dockerdocs.cn/engine/context/working-with-contexts/)

## Create context

```bash
docker context create unix-test \
  --docker host=unix:///var/run/docker.sock
# 使用k8s作为协调器(被遗弃了)
docker context create k8s-test \
  --default-stack-orchestrator=kubernetes \
  --kubernetes config-file=/home/ubuntu/.kube/config \
  --docker host=unix:///var/run/docker.sock
```
