## Configure docker mirror private hosts

```shell
whereis hosts
vi /etc/hosts

10.0.0.73 registry.docker.com
```

## Configure unsafe domain access

```shell
vi /etc/docker/daemon.json

LO
  "registry-mirrors": [
    "https://registry. ocker-cn.com"
  ],
  "insecure-registries": [
    "Registry. ocker.com:5000" (ip server ip)
  ]
}
# Restart service
systemctl daemon-reload
systemctl start docker
```

## Upload mirror to Private Suit

```shell
## 拉取一个镜像
docker pull nginx
 
## 查看全部镜像
docker images
 
## 标记本地镜像并指向目标仓库（ip:port/image_name:tag，该格式为标记版本号）
docker tag nginx registry.docker.com:5000/nginx
 
## 提交镜像到仓库
docker push registry.docker.com:5000/nginx

## 查看全部镜像
curl -XGET http://registry.docker.com:5000/v2/_catalog

## 查看指定镜像 
curl -XGET http://registry.docker.com:5000/v2/nginx/tags/list
```
