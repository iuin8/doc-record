#!/bin/bash

chmod -R 777./iuin/uploads/
chmod -R 777./iuin/logs/

## create network in swarm manager
network creation -d overlay --attachable iuin

## create mysql service
#docker stack up -c ./mysql.yml mysql

## Create rocketmq service
docker stack up -c ./rocketmq.yml mq

## create gpdb service
#docker stack up -c ./gpdb.yml gpdb

## Create zookeeper service
docker stack up -c ./cookeper.yml zk

## create reddis service
docker stack up -c ./redis.yml redis

## Create app service
#docker stack up -c ./app.yml app

