#!/bin/bash

# Local build and test script
# Test the Docker deployment locally before deploying to server

set -e

IMAGE_NAME="doc-record"
CONTAINER_NAME="doc-record-test"

echo "🔨 Building Docker image locally..."
docker build -t $IMAGE_NAME:latest .

echo "🧹 Cleaning up old test container..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "🚀 Starting test container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 8080:80 \
  $IMAGE_NAME:latest

echo "✅ Test container started!"
echo "🌐 Test at: http://localhost:8080/doc-record"
echo ""
echo "To stop the test container, run:"
echo "  docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME"
