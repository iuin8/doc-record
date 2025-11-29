# Drop

## Deemploy_to_docker.sh Usage

```bash
# Requires to pack and upload the specified service
sh deemploy_to_docker. h package web
# No need to pack only the specified service
sh deEmploy_to_docker.sh web
# All services
sh deemploy_to_docker.sh
```

## Full Position

- Drop to the project peer directory and place all items to the same level

## docker compose command

```bash
# 部署某个服务
docker compose -f ./docker-compose.yml -p ma-compose up -d --build $service_name
# 重启某个服务
docker compose -p ma-compose restart nginx
```
