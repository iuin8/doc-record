# Docker Swarm Node Label Management

## View Node Label

View node tag： with the following command

```bash
# 查看所有节点的标签
docker node ls --format "ID: {{.ID}}, Labels: {{.Labels}}"

# 查看特定节点的标签
docker node inspect NODE_ID --format "Labels: {{.Spec.Labels}}"
```

## Add Node Label

Add tag： using the command below

```bash
docker node update --label-add key=value NODE_ID
```

e.g.：

```bash
docker node update --label-add environment=production node1
```

## Remove Node Label

Remove tag： with the command below

```bash
docker node update --label-rm key NODE_ID
```

e.g.：

```bash
docker node update --label-rm environment node1
```

## Use tags to deploy services

Use tag constraint： in docker-compose.yml

```yaml
version: '3.8'
services:
  app:
    employment:
      placement:
        constraints:
          - node.labels.environment == production
```
