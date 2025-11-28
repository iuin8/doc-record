# Builds records related to the tomcat app

## Environment Variables

- Administration -> System Configuration -> Global Properties -> Environment Variables -> New Key Value Pair
- DOCKER_JENKINS_WORKSPACE : /var/lib/docker/volumes/soft_jenkins_home/_data/workspace

## jdk configuration

```shell
# New directory
cd /var/lib/docker/volumes/soft_jenkins_home/_data && mkdir -p ./soft/jdks
# Download jdk
wget https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz
wget https://corretto. Ws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz
# Unpg
tar -zxvf amazon-corretto-8-x64-linux-jdk.tar.gz

# Administration -> Global Tool Configuration -> JDK
# JAVA_HOME(/var/jenkins_home/soft/jdks/amazon-corretto-8.332.08.1-linux-x64)
```

## maven configuration

```shell
# Download Maven Integration Plugin

# Custom settings.xml configuration
cd /var/lib/docker/volumes/soft_jenkins_home/_data && mkdir -p ./soft/maven
code settings.xml
# Copy ./conf/settings. ml file content
# Modify tag<localRepository>content
# Adjust [administration -> global tool configuration -> Maven configuration]
# Default (and global) settings provide -> settings file -> File path (/var/jenkins_home/soft/maven/settings). ml)
# maven v3.6.3
```

---

## Build Script

- maven build
- Builds -> Add Building Step -> Call Top Maven Target

```shell
# Target
clean install -Dmaven.test.skip=true -Pprivate -Djava.awt.headless=true

# can also be replaced with the following command
clean package -D maven.test.skip=true -P prod help:active-profiles
```

- Execute shell
- Upload a mirror to the private inventory

```shell

export app_version=${BUILD_NUMBER}

cd $WORKSPACE

# 编辑Dockerfile文件
tee Dockerfile <<-'EOF'
FROM openjdk:11-jre-slim
WORKDIR /workdir
ADD ./target/*.jar app.jar
ENV SPRING_PROFILES_ACTIVE=prod
ENV SERVER_PORT=8080
ENTRYPOINT java -jar -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -Dserver.port=$SERVER_PORT app.jar
EXPOSE 8080
EOF

# 登录阿里云私仓 todo <username>和<password>需要手动替换成真实的数据
echo <password> | docker login -u <username> --password-stdin registry.cn-zhangjiakou.aliyuncs.com

# 构建镜像
docker -H tcp://172.17.0.1:2375 build -t $JOB_NAME:$app_version .

# 上传镜像到私服
docker -H tcp://172.17.0.1:2375 tag $JOB_NAME:$app_version registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version
docker -H tcp://172.17.0.1:2375 push registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version

# 删除本地镜像
docker -H tcp://172.17.0.1:2375 rmi registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version

# 退出阿里云私仓
docker logout

```

- Send build artifacts over SSH (Transfers Set -> Exec command)
- Select a remote ssh server, start a docker container on a remote server
- Or, use remote access to docker directly
  - PS: Server docker requires remote access (validating：docker -H tcp://172.17.0.1:2375 version).
  - [参考文章](https://segmentfault.com/a/1190000024563734)

```shell

export app_version=${BUILD_NUMBER}

# 创建工作目录
mkdir -p /www/temp/jenkins/docker
cd /www/temp/jenkins/docker

# 编辑stack yml文件
tee $JOB_NAME.yml <<-'EOF'
version: '3.5'
services:
  $JOB_NAME:
    image: registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:${app_version}
    environment:
      TZ: "Asia/Shanghai"
    networks:
      - middleware
    deploy:
      replicas: 1
      update_config:
        parallelism: 1
      restart_policy:
        condition: on-failure

networks:
  middleware:
    external: true

EOF

docker -H tcp://172.17.0.1:2375 stack up -c $JOB_NAME.yml app --with-registry-auth

```
