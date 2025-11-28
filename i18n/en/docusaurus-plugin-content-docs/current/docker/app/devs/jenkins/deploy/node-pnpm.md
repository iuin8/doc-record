# Build node project using Jenkins

## Jenkins configuration

- Create a free style project
- Use gitee as code source
- Add [executive shell]step to build step

```shell

pwd

# Installing pnpm
npm install -g pnpm

# Installing dependencies (unnecessary)
pnpm install
# Build Item
pnpm run build

# Delete all excrete_modules and dist
girls | grep v 'node_modules\|dismot' | xargs rm -rf


```

- Add [Senegal files or execution orders over SSH (implementation shell) step in building step

```shell

export app_version='1.0'

export docker_jenkins_workspace="/var/lib/docker/volumes/mng_jenkins_home/_data/workspace/"

cd $docker_jenkins_workspace/$JOB_NAME

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
echo "FROM nginx" > Dockerfile
echo "MAINTAINER Fa" >> Dockerfile
echo "WORKDIR /usr/share/nginx/html" >> Dockerfile
echo "RUN rm -rf *" >> Dockerfile
echo "ADD ./dist ." >> Dockerfile
echo "ADD ./nginx/conf.d/default.conf /etc/nginx/conf.d/" >> Dockerfile
echo "EXPOSE 80" >> Dockerfile

# 构建镜像
docker build --no-cache -t $JOB_NAME:$app_version .

# 上传镜像到私服
docker tag $JOB_NAME:$app_version registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version
docker push registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:$app_version

# 删除空镜像
docker images | awk '{if($1=="<none>")print $3}' | xargs docker rmi &> /dev/null

# 编辑stack yml文件
tee $JOB_NAME.yml <<-'EOF'
version: '3.5'
services:
  $JOB_NAME:
    image: registry.cn-zhangjiakou.aliyuncs.com/fa/$JOB_NAME:${app_version}
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

docker stack up -c $JOB_NAME.yml app

# 删除除 node_modules 以外的所有内容
ls | grep -v 'node_modules' | xargs  rm -rf

```

- Nginx Add Proxy Configuration

- Add mall-admin-web-demo.conf files to the conf.d directory

```shell
server {
    listen      80;
    server_name mall-admin-web-demo.iuin.xyz iuin.xyz;

    access_log /var/log/mall-admin-web-demo_access.log;
    error_log /var/log/mall-admin-web-demo_error.log;

    location / {
        include cors.conf;
        proxy_set_header Host $host;
        proxy_set_header X-real-ip $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://mall-admin-web-demo;
    }

}

```

## Employment

```shell
# 镜像下载问题，可试这添加--with-registry-auth看看
docker stack up -c $JOB_NAME.yml --with-registry-auth app

```
