#!/bin/bash

# Deploy script with optional proxy support
# Usage: 
#   ./deploy-with-proxy.sh              # Deploy without proxy (default)
#   ./deploy-with-proxy.sh --use-proxy  # Deploy with proxy

set -e

SERVER="fa.internet.tencent"
DEPLOY_DIR="/www/doc-record"
USE_PROXY=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --use-proxy)
      USE_PROXY=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--use-proxy]"
      exit 1
      ;;
  esac
done

echo "🚀 Starting deployment to $SERVER..."
if [ "$USE_PROXY" = true ]; then
  echo "🌐 Using local proxy for Docker build"
else
  echo "📡 Using direct connection (no proxy)"
fi

# Step 1: Sync files to server
echo "📤 Syncing files to server..."
rsync -avz --delete \
  --exclude 'node_modules' \
  --exclude 'build' \
  --exclude '.git' \
  --exclude '.cursor' \
  ./ $SERVER:$DEPLOY_DIR/

# Step 2: Build and deploy on server
echo "🔧 Building and deploying on server..."
if [ "$USE_PROXY" = true ]; then
  # Deploy with proxy
  ssh $SERVER << 'EOF'
set -e
cd /www/doc-record

# Stop existing containers
echo "Stopping existing containers..."
docker compose down 2>/dev/null || true

# Build and start with proxy
echo "Building with proxy (127.0.0.1:19093)..."
export HTTP_PROXY=http://127.0.0.1:19093
export HTTPS_PROXY=http://127.0.0.1:19093
export NO_PROXY=localhost,127.0.0.1

docker compose build --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY
docker compose up -d

echo "✅ Deployment completed!"
docker compose ps
EOF
else
  # Deploy without proxy
  ssh $SERVER << 'EOF'
set -e
cd /www/doc-record

# Stop existing containers
echo "Stopping existing containers..."
docker compose down 2>/dev/null || true

# Build and start without proxy
echo "Building without proxy..."
docker compose up -d --build

echo "✅ Deployment completed!"
docker compose ps
EOF
fi

echo "✨ Deployment finished successfully!"
echo "🌐 Visit: http://129.204.8.61/doc-record"
