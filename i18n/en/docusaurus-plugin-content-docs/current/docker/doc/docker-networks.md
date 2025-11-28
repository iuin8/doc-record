## Create Network

```shell
#
network creation -d bridge midleware

# swarm
docker network creation -d overlay --attachable middle leware

docker network creation --driver=overlay --gateway 192. 68.1.1 --subnet 192.168.1.0/24 --attachable my_network
```

## Use host mode

```shell script
docker run --net="host" 
docker-compose -f file.yml up # yml 文件中，在services:[serviceName]:network_mode: "host"
docker stack up -c file.yml 
# yml 文件中
# services:
#   nginx:
#     networks:
#       hostnet: {}
# networks:
#   hostnet:
#     external: true
#     name: host
```
