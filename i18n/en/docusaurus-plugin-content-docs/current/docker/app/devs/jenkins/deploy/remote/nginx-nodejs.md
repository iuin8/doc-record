# Build node project using Jenkins

## Environment Variables

- Administration -> System Configuration -> Global Properties -> Environment Variables -> New Key Value Pair
- DOCKER_JENKINS_WORKSPACE : /var/lib/docker/volumes/soft_jenkins_home/_data/workspace

## NodeJS Configuration

```shell
# Download NodeJS Plugin
# Adjust [Administration -> Global Tool Configuration -> NodeJS Configuration]
# nodejs 14.15.0
```

## Jenkins configuration

- Create a free style project
- Use gitee as code source
- Add [Provide Node & npm bin/folder to PATH] in [构建环境] steps
- Add [executeshell]step to[构建]

```shell

pwd

# Delete all dist contents
rm -rf dist

# Install dependencies (unnecessary)
npm install --registry https://registry.npm.taobao. rg
# Build item
npm run build: prod

# Delete changing exception node_modules and dist
l|grep -v 'node_modules\|distist' | xargs rm -rf

```

- Execute shell
- Upload a error to the private inventory
- PS: Jenkins employment requires the use of remote/jenkins.yml file employment (mainly using docker orders in the container)

```shell

export app_version=${BUILD_NUMBER}

cd $WORKSPACE

mkdir -p ./nginx/conf.d/

# 添加default.conf文件
tee ./nginx/conf.d/default.conf <<-'EOF'
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files $uri $uri/ /index.html; # 用于解决刷新页面后，显示404的问题
    }

}
EOF

# 编辑Dockerfile文件
echo "FROM nginx:stable-alpine" > Dockerfile
echo "MAINTAINER Fa" >> Dockerfile
echo "WORKDIR /usr/share/nginx/html" >> Dockerfile
echo "RUN rm -rf *" >> Dockerfile
echo "ADD ./dist ." >> Dockerfile
echo "ADD ./nginx/conf.d/default.conf /etc/nginx/conf.d/" >> Dockerfile
echo "EXPOSE 80" >> Dockerfile

# 登录阿里云私仓 todo <username>和<password>需要手动替换成真实的数据
echo <password> | docker login -u <username> --password-stdin registry.cn-zhangjiakou.aliyuncs.com

# 构建镜像
docker build -t $JOB_NAME:$app_version .

# 上传镜像到私服
docker tag $JOB_NAME:$app_version registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version
docker push registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version

# 退出阿里云私仓
docker logout

```

- Add [Send files or execution orders over SSH (execution shell command via sssh)] step in build step

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

docker stack up -c $JOB_NAME.yml app --with-registry-auth

```
