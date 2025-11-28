## maven buildings with dockerfile plugins

- Reference project [https://gitee.com/LFa/demo-test.git]

#### Jenkins configuration

- Create maven project
- Build[Goals and options -> clean install -Dmaven.test.skip=true]
- Post Steps[Run only if build such]
- ad post-build step [Senegal files or executive orders over SSH]

```shell

cd $DOCKER_WORKSPACE/$JOB_NAME

export app_version='1.0'

# 编辑Dockerfile文件
tee Dockerfile <<-'EOF'

FROM hub.c.163.com/dwyane/openjdk:8
WORKDIR /workdir
ADD target/$JOB_NAME.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
EXPOSE 8080

EOF

# 构建镜像
docker build -t $JOB_NAME:$app_version .

# 上传镜像到私服
docker tag $JOB_NAME:$app_version registry.docker.com:5000/$JOB_NAME:$app_version
docker push registry.docker.com:5000/$JOB_NAME:$app_version

# 编辑stack yml文件
tee $JOB_NAME.yml <<-'EOF'
version: '3.5'
services:
  $JOB_NAME:
    image: registry.docker.com:5000/$JOB_NAME:${app_version}
    ports:
      - target: 8880
        published: 8880
        mode: host
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

# 启动app容器 
docker stack up -c $JOB_NAME.yml app

```
