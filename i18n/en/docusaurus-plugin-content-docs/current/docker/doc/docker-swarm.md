## Create Swarm Cluster

```shell script
Docker swarm init --advertise-addr 192.168.31.43
# --advertise-addr parameter indicates that other worker nodes in swarm use this ip address to contact manager.
docker swarm init --advertise-addr enp0s8
# --advertise-addr this parameter can also use network card names
```

## Query commands to join the Swarm cluster

```shell script
docker swarm join-token manager
```

## Leave Swarm Cluster

```shell script
docker swarm leave
```

## Add tag to node

```shell
# docker node update --label-add client=true <node-name>
docker node update --label-add func=nginx worker1
```

## Create Network

- overlay network
  - [No route to host issue](./problems/docker-swarm-networks.md#网段冲突问题解决方案)

```shell
docker network create middle leware --d overlay --scope swarm 

# Specify subnet range (PS: prevent and host IP conflicts (error: No route to host))
docker swarm init --default-addr-pool 192.168.0.0/16
```

## Deployment command

```shell script
docker stack up -c docker-compose.yml rmq
```

## docker swarm port mapping problem

```shell
  <serviceName>:
    ports:
      - target: 639
        published: 639
        protocol: tcp
        mode: host
```

## Docker swarm port open

```shell
# Before starting, verify its status:
systemctl status firewalld
# It should not be running, so start:
systemctl start firewalld
# en enable it so that it starts on boot:
systemctl enable firewalld
# Afterwards, read the firewall:
firewall-cmd --load
# Then start Docker.
systemctl start docker
```

> ###### Note: If you make a mistake and need to remove an entry, type:
>
> firewall-cmd --remove-port=port-number/tcp — permanent.
>
> \####On the notation that will be a Swarm manager, Use the following orders to open the necessary ports:
> firewall-cmd --add-port=2376/tcp --permanent\
> firewall-cmd --add-port=2377/tcp --permanent\
> firewall-cmd --add-port=7946/tcp-permanent\
> firewall-cmd --add-port=7946/udp --permanent\
> firewall-cmd --add-port=4789/udp -permanent
>
> \######Then on each node that will function as a Swarm worker, execute the following commands:
> firewall-cmd --add-port=2376/tcp --permanent\
> firewall-cmd --add-port=7946/tcp --permanent\
> firewall-cmd --add-port=7946/udp --permanent\
> firewall-cmd --add-port=4789/udp --permanent

```shell
# docker machine
fireall-cmd --add-port=2376/tcp --permanent
# manager
firewall-cmd --add-port=2377/tcp --permanent
# communication among nodes (container network discovery).
firewall-cmd --add-port=7946/tcp --permanent
firewall-cmd --add-port=7946/udp --permanent
# overlay network traffic (container address networking).
firewall-cmd --add-port=4789/udp ---permanent

# 2376 for docker machine on the entity machine, is not usually needed.

```

> docker swarm port open[参考链接](https://www.digitalocean.com/community/tutorials/how-to-configure-the-linux-firewall-for-docker-swarm-on-centos-7)

```shell script
# xml开放端口
# 通过以下命令查找xml文件存放路径(这里查找的是系统存放路径)
find / -name ssh.xml
# 查找docker相关xml
ls | grep docker
# 如果有(docker-swarm.xml)则可直接开启它，可省去下面自己新建文件的过程

vi /etc/firewalld/services/docker.xml # 这个是用户存放路径，可能不在这个路径，可以通过上面那条命令查找路径

<?xml version="1.0" encoding="utf-8"?>
      <service>
        <short>docker</short>
        <description>docker daemon for remote access</description>
        <port protocol="tcp" port="2376"/>
        <port protocol="tcp" port="2377"/> # manager节点才需要
        <port protocol="tcp" port="7946"/>
        <port protocol="udp" port="7946"/>
        <port protocol="udp" port="4789"/>
      </service>
      
# 查看默认zone(一般是public)
firewall-cmd --get-default-zone
# 在zone中加入这个service
firewall-cmd --zone=public --add-service=docker --permanent
# 重新加载
firewall-cmd --reload
# 详见linux.md 和 firewalld.md文件
```
