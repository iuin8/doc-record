#!/bin/bash

# Deploy script for 随猿Fa笔记 to Tencent Cloud Server
# This script deploys the Docker container to the remote server

set -e

SERVER="fa.internet.tencent"
DEPLOY_DIR="/www/doc-record"
IMAGE_NAME="doc-record"
CONTAINER_NAME="doc-record"

echo "🚀 Starting deployment to $SERVER..."

# Step 1: Build Docker image locally
echo "📦 Building Docker image..."
docker build -t $IMAGE_NAME:latest .

# Step 2: Save image as tar file
echo "💾 Saving image as tar file..."
docker save -o /tmp/doc-record.tar $IMAGE_NAME:latest

# Step 3: Transfer image to server
echo "📤 Transferring image to server..."
scp /tmp/doc-record.tar $SERVER:/tmp/

# Step 4: Deploy on server
echo "🔧 Deploying on server..."
ssh $SERVER << 'EOF'
set -e

# Load the image
echo "Loading Docker image..."
docker load -i /tmp/doc-record.tar

# Stop and remove existing container
echo "Stopping existing container..."
docker stop doc-record 2>/dev/null || true
docker rm doc-record 2>/dev/null || true

# Run new container
echo "Starting new container..."
docker run -d \
  --name doc-record \
  --restart unless-stopped \
  -p 80:80 \
  doc-record:latest

# Clean up
rm /tmp/doc-record.tar

echo "✅ Container started successfully!"
docker ps | grep doc-record
EOF

# Step 5: Clean up local tar file
echo "🧹 Cleaning up..."
rm /tmp/doc-record.tar

echo "✨ Deployment completed successfully!"
echo "🌐 Visit: http://129.204.8.61/doc-record"
