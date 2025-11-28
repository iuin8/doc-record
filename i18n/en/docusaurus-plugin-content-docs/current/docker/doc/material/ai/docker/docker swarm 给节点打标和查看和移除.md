# Docker Swarm Node Label Management

## View Label

View tag： with the following command

```bash
# 查看所有节点的标签
docker node ls --format "ID: {{.ID}}, Labels: {{.Labels}}"

# 查看特定节点的标签
docker node inspect NODE_ID --format "Labels: {{.Spec.Labels}}"
```

## Add Label

Add tag： using the command below

```bash
docker node update --label-add key=value NODE_ID
```

e.g.：

```bash
docker node update --label-add environment=production node1
```

## Move Node Label

Move tag： with the command below

```bash
docker node update --label-rm key NODE_ID
```

e.g.：

```bash
docker node update --label-rm environment node1
```

## Use tags to upload services

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
