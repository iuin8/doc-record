#!/bin/sh

export app_version='1.0'
export DOCKER_WORKSPACE='/home/admin/app'
export JOB_NAME='zhaoquanmiao-h5'

cd $DOCKER_WORKSPACE/$JOB_NAME

mkdir -p ./nginx/conf.d/

# Add default.conf file
tee ./nginx/conf.d/default.conf <<-'EOF'
server
    listen 80;
    listen [::]:80;
    server_name localhost;

    #access_log /var/log/nginx/host.access.log main;

    Location / LOC:
        root /usr/share/nginx/html;
        Index index.html index.htm;
        try_files $uri $uri/ /index.html; # 用于解决刷新页面后，显示404的问题
    }

}
EOF

# Edit Dockerfile
echo "FROM nginx" > Dockerfile
echo "MAINTAINER Fa" >> Dockerfile
echo "WORKDIR /usr/share/nginx/html" >> Dockerfile
echo "RUN rm -rf *" >> Dockerfile
echo "ADD ./dist." >> Dockerfile
echo "ADD ./nginx/conf.d/default.conf /etc/nginx/conf.d/" >> Dockerfile
echo "EXPOSE 80" >> Dockerfile

# Build Image
docker build --no-cache -t $JOB_NAME:$app_version .

# Upload mirrors to Private Suit
docker tag $JOB_NAME:$app_version registry.docker.com:5000/$JOB_NAME:$app_version
docker push registry.docker.com:5000/$JOB_NAME:$app_version

# Delete empty image
docker images | awk '{if($1=="<none>")print $3}' | xargs docker rmi &> /dev/null

mkdir ../template

# Edit stack yml file
tee ./template/$JOB_NAME.yml <<-'EOF'
version: '3.5'
services:
  ${JOB_NAME}:
    image: registry.docker.com:5000/${JOB_NAME}:${app_version}
    Ports:
      - target: 80
        published: 3230
        mode: host
    Network:
      - middle leware
    Deployment:
      Replicas: 1
      update_config:
        parallelism: 1
      Restart_policy:
        condition: one-failure
Network:
  middle leware:
    external: true
EOF


if [ "$JOB_NAME" != "" ]

then
    envsubst '$JOB_NAME' < ./template/$JOB_NAME.yml > ./$JOB_NAME.yml
Li

if [ "$app_version" != "" ]

then
    envsubst '$app_version' < ./template/$JOB_NAME.yml > ./$JOB_NAME.yml
Li


docker stack up -c $JOB_NAME.yml app

# Delete everything except node_modules
# girls | grep -v 'node_modules' | xargs rm -rf
