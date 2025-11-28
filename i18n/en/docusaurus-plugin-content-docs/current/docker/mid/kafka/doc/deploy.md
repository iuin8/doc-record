# Start cluster

docker stack ploy -c kafka-compose.yml kafka

# Launch Cluster (two)

docker stack upload --compose-file=kafka-docker-compose.yml tools
