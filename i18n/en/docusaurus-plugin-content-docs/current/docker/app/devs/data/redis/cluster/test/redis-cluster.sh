#!/bin/bash

# Defines the service name and network name of the Redis container
SERVICE_NAME_PREFIX="data_redis"
SERVICE_PORT_PREFIX=700
NETWORK_NAME="midleware"

# build redis-cli commands
CMD="redis-cli --cluster create"

for i in 1 3 4 5 6
do
    SERVICE_NAME=$SERVICE_NAME_PREFIX$i
    # Gets a list of IP addresses for Redis containers
    IP=$(docker service inspect --format='{{range .Endpoint.VirtualIPs}}{{.Addr}}{{end}}' $SERVICE_NAME | sed 's/\/24//g')
    # IP address and port of the Spelling Redis container
    CMD="$CMD $IP:$SERVICE_PORT_PREFIX$i"
    echo "$SERVICE_NAME IP: $IP"
done

CMD="yes yes | $CMD --cluster-replicas 1 -a foobared"

echo "CMD: $CMD"

# Execute remdis-cli command to create Redis Cluster
docker run --rm --network $NETWORK_NAME redis:6.0 bash -c "$CMD"