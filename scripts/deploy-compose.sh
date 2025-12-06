#!/bin/bash

# Quick deployment script using docker-compose on server
# This script transfers files and uses docker-compose for deployment

set -e

SERVER="fa.internet.tencent"
DEPLOY_DIR="/www/doc-record"

echo "🚀 Starting deployment with docker-compose..."

# Step 1: Sync files to server (excluding build artifacts and node_modules)
echo "📤 Syncing files to server..."
rsync -avz --delete \
  --exclude 'node_modules' \
  --exclude '.git' \
  --exclude '.cursor' \
  ./ $SERVER:$DEPLOY_DIR/

# Step 2: Build and deploy on server
echo "🔧 Building and deploying on server..."
ssh $SERVER << EOF
set -e
cd $DEPLOY_DIR

# Stop existing containers
echo "Stopping existing containers..."
docker compose down 2>/dev/null || true

# Build and start
echo "Building and starting containers..."
docker compose up -d --build

echo "✅ Deployment completed!"
docker compose ps
EOF

echo "✨ Deployment finished successfully!"
echo "🌐 Visit: http://129.204.8.61/doc-record"
