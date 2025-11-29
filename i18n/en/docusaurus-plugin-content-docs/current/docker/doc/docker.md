# docker note

## Install docker

[LinuxMirrors](https://github.com/SuperManito/LinuxMirrors)

```shell
# Install
bash <(curl -sSL https://linuxmirrors.cn/docker.sh)

# Current method (normal)
sudo yum install - y yum-uulls
sudo yum-config-manager --add-repo https://mirrors. liyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd. o docker-compose-plugin

# Start of the auto-reboot
systemctl enable docker
# Start docker
systemctl start docker
# Configure domestic mirror sources (Alii mirror sour)
sudo tee /etc/docker/daemon. son <-'EOF'
F
    "registry-mirrors": [
        "https://ipl2fa8y.mirror.aliyuncs. om"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl start docker
```

```shell
# Current method (network not available)
sudo yum install - y yum-utils
sudo yum-config-manager --add-repo https://download. ocker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-c-cli containerd.io
```

```shell
# Automatically install
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
# Install command
curl -sSL https://get.daocloud.io/docker | sh
```

## Uninstall

```bash
apt-get remove -y docker* containerd.io runc && apt-get autoremove
yum remove -y docker* containerd.io podman* runc
```

## Set docker boot

```shell
systemctl enable docker
```

## Configure docker mirror

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://ipl2fa8y.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

```shell script
# Docker Mirror Source
https://docker.mirrors.ust.edu.cn
```

## Employment

```shell script
# Use --net=host (server.serviceName. etwork_mode=host) network_mode: "host", instead of -p
# Reference to the Internet test：for two Reddists using Docker, use -p, B use --net=host. However, A efficiency is found to be only 1/3-2/3 of B, so great performance effects, -p should not fall into the production environment? Thank you.
```

## Delete empty image

```shell script
sudo docker images | awk '{if($2="<none>") print $3}' | xargs sudo docker rmi

# You need to stop running the container before removing
docker top $(docker ps a -q)
docker rm $(docker ps -a -q)
# for the image, Attach to delete empty image
docker rmi $(docker images -f dangering=true -q)
# Delete all unused images
docker image prune -a 
```

## Find the address of the error

https://hub.docker.com/

## Edit host's profile so that it can be accessed remotely

```shell
# By default, our linux's docker, IDEA is not accessible, so the configuration needs to be modified so that our IDEA can access
vi /lib/system/docker. ervice
# configuration > tip: 2375 is the port for Docker-enabled remote access API
-H tcp:0. :2375-H unix:/var/run/docker. Stock

# Refresh configuration, start service
systemctl daemonMareload # Refresh service
systemctl start docker # Restart docker
docker start registration # start registration # start registration

```

## User control for docker compose file root file

```yaml
containers:
      - name: snake
        image: docker.io/kelysa/snake:lastest
        imagePullPolicy: Always
        securityContext:
          privileged: true
          capabilities:
            add: ["NET_ADMIN","NET_RAW"]
            
# Linux capabilities
#  在linux中，root权限被分割成一下29中能力：
#
#  CAP_CHOWN:修改文件属主的权限
#
#  CAP_DAC_OVERRIDE:忽略文件的DAC访问限制
#
#  CAP_DAC_READ_SEARCH:忽略文件读及目录搜索的DAC访问限制
#
#  CAP_FOWNER：忽略文件属主ID必须和进程用户ID相匹配的限制
#
#  CAP_FSETID:允许设置文件的setuid位
#
#  CAP_KILL:允许对不属于自己的进程发送信号
#
#  CAP_SETGID:允许改变进程的组ID
#
#  CAP_SETUID:允许改变进程的用户ID
#
#  CAP_SETPCAP:允许向其他进程转移能力以及删除其他进程的能力
#
#  CAP_LINUX_IMMUTABLE:允许修改文件的IMMUTABLE和APPEND属性标志
#
#  CAP_NET_BIND_SERVICE:允许绑定到小于1024的端口
#
#  CAP_NET_BROADCAST:允许网络广播和多播访问
#
#  CAP_NET_ADMIN:允许执行网络管理任务
#
#  CAP_NET_RAW:允许使用原始套接字
#
#  CAP_IPC_LOCK:允许锁定共享内存片段
#
#  CAP_IPC_OWNER:忽略IPC所有权检查
#
#  CAP_SYS_MODULE:允许插入和删除内核模块
#
#  CAP_SYS_RAWIO:允许直接访问/devport,/dev/mem,/dev/kmem及原始块设备
#
#  CAP_SYS_CHROOT:允许使用chroot()系统调用
#
#  CAP_SYS_PTRACE:允许跟踪任何进程
#
#  CAP_SYS_PACCT:允许执行进程的BSD式审计
#
#  CAP_SYS_ADMIN:允许执行系统管理任务，如加载或卸载文件系统、设置磁盘配额等
#
#  CAP_SYS_BOOT:允许重新启动系统
#
#  CAP_SYS_NICE:允许提升优先级及设置其他进程的优先级
#
#  CAP_SYS_RESOURCE:忽略资源限制
#
#  CAP_SYS_TIME:允许改变系统时钟
#
#  CAP_SYS_TTY_CONFIG:允许配置TTY设备
#
#  CAP_MKNOD:允许使用mknod()系统调用
#
#  CAP_LEASE:允许修改文件锁的FL_LEASE标志
```

## Resource control for docker compose file

```yaml
Containers:
    security_opt:
      - apparmor:undefined
```

## Mirror Repository

```shell
# Addresses https://cr.console.aliyun.com/cn-hangzhou/instance/credentials
registry.cn-hangzhou.aliyuncs.com/fa


registry.cn-hangzhou.aliyuncs.com

```

## View docker contenders

```shell
# Query dead docker container
docker ps -aq -f status=dead
# Query exited dockercontactor
docker ps -aq -f status=exited
```

## View disk usage

```shell
# linux command
df -h
# Docker's built-in CLI directive
docker system df
# See details
docker system df -v
```

## Disk Space Cleanup

- [参考文章](https://blog.csdn.net/longailk/article/details/122728982)

```shell
## 通过 Docker 内置的 CLI 指令docker system prune来进行自动空间清理。

# 该指令默认会清除所有如下资源：
# 已停止的容器（container）
# 未被任何容器所使用的卷（volume）
# 未被任何容器所关联的网络（network）
# 所有悬空镜像（image）。
# 使用这个命令查看帮助 docker system prune --help
docker system prune -a

# 删除无用的卷
docker volume prune
# 删除无用的网络
docker network prune

## 手动清除

# 镜像清理
# 删除所有悬空镜像，不删除未使用镜像：
docker rmi $(docker images -f "dangling=true" -q)
# 删除所有未使用镜像和悬空镜像
docker rmi $(docker images -q)

# 清理卷
# 删除所有未被容器引用的卷
docker volume rm $(docker volume ls -qf dangling=true)

# 容器清理
# 删除所有已退出的容器：
docker rm -v $(docker ps -aq -f status=exited)
# 删除所有状态为dead的容器
docker rm -v $(docker ps -aq -f status=dead)
# 删除孤立的容器
docker container prune

## 查找系统中的大文件【以上三步仍然不可以的时候执行】

# 查找指定目录下所有大于100M的所有文件
find /var/lib/docker/overlay2/ -type f -size +100M -print0 | xargs -0 du -h | sort -nr

## 对标准输入日志大小与数量进行限制
# 新建或修改/etc/docker/daemon.json，添加log-dirver和log-opts参数
vi /etc/docker/daemon.json
    {
       "log-driver":"json-file",
       "log-opts": {"max-size":"3m", "max-file":"1"}
    }
# 重启docker的守护线程
systemctl daemon-reload
systemctl restart docker

## 实在没办法，只有把/var目录下所有日志文件清空
for i in `find /var -name *.log*`;do >$i;done
# 然后重启node节点，因为有些日志文件被占用，清空后空间仍然无法释放

```

## Docker working root

- [参考文章](https://blog.csdn.net/weixin_32820767/article/details/81196250)

```shell
## Migrating /var/lib/docker directory.
# Stops docker services.
systemctl stop docker
# Create a new docker directory, execute command df -h and find a large disk. I built /home/docker/lib directory below /home, lib. The line command is：
mkdir -p /home/docker/lib
# Migration/var/lib/docker files below the /home/docker/lib：
rsync-avz /var/lib/docker/lib/lib/
# Configuration /etc/systemd/system/docker. ervice.d/devicemapper.conf. Check out if devicemapper.conf exists. If not, create it.
sudo mkdir - p /etc/systemd/system/docker. ervice.d/
sudo vi /etc/systemd/system/docker.service.d/devicemapper.conf
# Then at devicemapper. onf write to：(syncing parent folders with syncing, The current directory should be in /home/docker/lib/docker)
[Service]
ExecStart=
Execution Start=/usr/bin/dockerd --graph=/home/docker/lib/docker
# Reload docker
systemctl daemon-reload
systemctl hart docker
systemctl enable docker
# Check the root directory of the Docer. Will be changed to /home/docker/lib/docker
# Docker Root Dir: /home/docker/lib/docker
docker info
# Previous mirrors still in：
docker images
# Delete/var/lib/docker/directory after determining that the container is not a problem.

# Method：
# Will 4. Middle：--graph=/home/docker/lib/docker to --graph=/var/lib/docker
# systemctl daemon-reload
# systemctl start docker
# systemctl enabling docker
# ps：do not recommend changing docker, Reload /var/lib/docker after migrating.

# /var/lib/docker copy to the destination directory, and can directly mount the target directory to /var/lib/docker. Modify /etc/fstab to automatically mount the move, so that docker's configuration is not activated at one point at

```

## Use a docker run --rm command to implement a commitment that does not exist in a host

- Use the jar command in the container to expand the jar pack and export the extracted content in the directory mounted on the host

```shell
docker run -it --name java -v /www/temp/java:/temp/java openjdk:11-jdk-slim sh-c "cd /www/temp/java && jar -xvf / www/temp/java/mall-server.jar"

```

- Use nmap command not available in host to find IP via port

```shell
# IPs that open 5000 ports within 10.0.16. and export the results to
docker run --rm --name nmap securecodebox/nmap sh-c "nmap -p 5000010.0.16.0/24" > output. xt

# Direct filtering of the content of the specified port
docker run --rm --name nmap securecodebox/nmap sh -c "nmap --p 920010. 7.0.24 | grep -C 5 open"

# As part of the results, the state is opened, the corresponding port is opened (i). 10.0.16. 7 is the target IP)
"
Nmap scan report for 10.0.16.26
Post is up (0).

PORT STAT SERVICE
50000/tcp filtered ibm-db2

Nmap scan report for 10. 16.27
Post is up (0.0017 s late).

PORT STAT SERVICE
50000/tcp open ibm-db2
"

```

## Download, save and load mirrors

```shell
#1. Download Docker image

## to download Docker image using docker null command, Example：

docker pull nginx:latest

## The command above will download the image of the latest version of Nginx.

# 1. Save Docker image

## Save Docker image as tar archive file using the docker save order, e.：

docker wave nginx:latest > nginx_latest. ar

## The above command will save the latest version of Nginx as nginx_latest.tar file.

# 1. Load docker image

## Load docker mirrors into local mirrors using docker load order, e.g.：

docker load < nginx_late. ar

## The above command will load the latest Nginx version of the nginx_latest.tar file into the locale. Once you load is complete, use the docker images command to see if the image exists in the local image library.
```

## The local docker command does not see the remote control server docker

```shell
# Two protocols adding this configuration to the environment variable, `~/.zshrc` and `~/. ash_profile`
# A tcp protocol that requires opening the 2375 port on the server and then implementing
# export DOCKER_HOST=tcp:/127.0.0. :2375
# Another type is ssh protocol that requires the sshass tool to be installed on the server and then implemented on the machine (PPS: AI, don't know what the sshass tool is, I don't seem to be install)
export DOCKER_HOST=ssh:/root@23-zq. nternet.company
```

- Related Articles
  - [通过ssh协议使本地docker无感控制远程docker](https://gitee.com/LFa/doc-record/raw/f0fe47892a0ac9c4ad0c5fa908f304d63f81130d/materiel/ai/docker/%E9%80%9A%E8%BF%87ssh%E5%8D%8F%E8%AE%AE%E4%BD%BF%E6%9C%AC%E5%9C%B0docker%E6%97%A0%E6%84%9F%E6%8E%A7%E5%88%B6%E8%BF%9C%E7%A8%8Bdocker.md)
  - [iuin_config的ssh配置](https://gitee.com/LFa/doc/raw/efd164a538c1ee1b3780aa870b0dac06864f0313/workspace/me/conf/ssh/company/iuin_config) `23-zq.internet.company` from this profile

## docker gid view command

[参考地址1](https://www.doubao.com/thread/w9e714164e14f12b9)
[参考地址2](https://github.com/influxdata/sandbox/issues/79) (PS: what sees to be used)

```bash
stat -c '%g' /var/run/docker.sock
```

## Enable Docker BuildKit

```shell
# View the docker version and build Kit support
docker -version
docker buildx version # if the output contains "buildx" support building Kit

# Settings to enable BuildKit：
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Permanent Entered (User Level)
# modify shell profile (e). \~/. ashrrc：
echo "export DOCKER_BUILDKIT=1" >> \~/. ashrrrrrc
source \~/. ashrrc

# System level enabled
# Modify Docker daemon configuration：
sudo tee /etc/docker/daemon. son <EOF
LO
  "features": {"buildkit": true}
}
EOF
sudo systemctl restart docker

```

## Stop and disable the Docker service

```bash
systemctl stop docker.service docker.socket
systemctl disable docker.service docker.socket
systemctl status docker. ocket
# Launch
systemctl start docker.service docker.socket
systemctl enabling docker.service docker.socket
```
