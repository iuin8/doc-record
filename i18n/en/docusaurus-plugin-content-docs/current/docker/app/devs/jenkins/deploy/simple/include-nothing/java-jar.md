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

## Maven configuration

```shell
# Download Maven Integration Plugin in

# Custom settings.xml configuration
cd /var/lib/docker/volumes/soft_jenkins_home/_data && mkdir -p ./soft/maven
code settings.xml
# Copy./conf/settings. ml file content
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
clean package -D maven. est.skip=true -P prod help:active-profiles

# or use
cleanan package -D maven.test.skip=true -P prod -pl cn.facoder:mall-server -am
```

- Senegal build artifacts over SSH (Transfers Set -> Exec command)

```shell
# 第四版(swarm+私服)
# docker images | awk '{if($1=="$JOB_NAME") print $3}' | xargs docker rmi

export app_version='1.0'

if [ -z $DOCKER_JENKINS_WORKSPACE ]; then
  echo "环境变量 DOCKER_JENKINS_WORKSPACE:[$DOCKER_JENKINS_WORKSPACE] 缺失，需配置 DOCKER_JENKINS_WORKSPACE 环境变量(exit -1)"
  exit -1
fi

cd $DOCKER_JENKINS_WORKSPACE/$JOB_NAME

# 编辑Dockerfile文件
tee Dockerfile <<-'EOF'
FROM eclipse-temurin:11-jre-alpine
WORKDIR /workdir
ADD ./target/*.jar app.jar
ENV SPRING_PROFILES_ACTIVE=prod
ENV SERVER_PORT=8080
ENV JAVA_OPTS="-Xms512m -Xmx512m"
ENTRYPOINT java ${JAVA_OPTS} -Dloader.path="/www/java/lib" -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -Dserver.port=$SERVER_PORT -jar app.jar
EXPOSE 8080
EOF

# 构建镜像
docker build -t $JOB_NAME:$app_version .

# 上传镜像到私服
docker tag $JOB_NAME:$app_version registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version
docker push registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version

# 删除本地镜像
docker rmi registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version

# 编辑stack yml文件
tee $JOB_NAME.yml <<-'EOF'
version: '3.5'
services:
  $JOB_NAME:
    image: registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:${app_version}
    environment:
      TZ: "Asia/Shanghai"
    volumes:
      - "/www/temp/java/lib:/www/java/lib"
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

docker stack up -c $JOB_NAME.yml app --with-registry-auth

```
