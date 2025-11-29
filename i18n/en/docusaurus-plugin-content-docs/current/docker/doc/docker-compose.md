# docker-compose.

## Install or upgrade the specified version

```shell
# View previously downloaded program
still /usr/local/bin/docker-compose
# Delete previously downloaded program
rm /usr/local/bin/docker-compose

# Download install program to specified directory
# sudo curl -L https://get. aocloud.io/docker/compose/releases/download/1. /docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/v2.11.2/dock-linux-x86_64 > /usr/local/bin/docker-compose

# Add execution permission
chmod +x /usr/local/bin/docker-compose

```

- Install with package manager

```shell
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-compose

```

- Install docker-compose using python
  - [参考文章](https://help.aliyun.com/zh/ecs/use-cases/deploy-and-use-docker-on-alibaba-cloud-linux-2-instances)

```shell
# Important: Only Python 3 and above support docker-compose, and make sure that pie is installed.
p3 install -U pip setuptools
pip3 install docker-compose
docker-compose --version
```

> Please note that using package management will ensure that it is an official and stable strength. He latest version may be installed using the pip, but in some cases depending or compatibility problems may be counted.

## Sample Commands

```bash
docker compose -f ./docker-compose.yml -p project_name up -d --build service_name
```
