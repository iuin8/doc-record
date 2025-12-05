#!/bin/bash

# Alternative deployment: Build locally and push image to server
# This avoids slow downloads on the server

set -e

SERVER="fa.internet.tencent"
IMAGE_NAME="doc-record"
IMAGE_TAG="latest"

echo "🚀 Building Docker image locally..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

echo "💾 Saving image to tar file..."
docker save -o /tmp/doc-record.tar $IMAGE_NAME:$IMAGE_TAG

echo "📤 Transferring image to server..."
scp /tmp/doc-record.tar $SERVER:/tmp/

echo "🔧 Loading and deploying on server..."
ssh $SERVER << 'EOF'
set -e

# Load the image
echo "Loading Docker image..."
docker load -i /tmp/doc-record.tar

# Stop and remove existing container
echo "Stopping existing containers..."
cd /www/doc-record
docker compose down 2>/dev/null || true

# Start new container
echo "Starting container..."
docker compose up -d

# Clean up
rm /tmp/doc-record.tar

echo "✅ Deployment completed!"
docker compose ps
EOF

# Clean up local tar file
echo "🧹 Cleaning up..."
rm /tmp/doc-record.tar

echo "✨ Deployment finished successfully!"
echo "🌐 Visit: http://129.204.8.61/doc-record"
