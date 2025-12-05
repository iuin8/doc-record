#!/bin/bash

# Deploy by temporarily disabling broken docker proxy mirror

set -e

SERVER="fa.internet.tencent"
DEPLOY_DIR="/www/doc-record"

echo "🚀 Starting deployment..."

# Step 1: Sync files to server
echo "📤 Syncing files to server..."
rsync -avz --delete \
  --exclude 'node_modules' \
  --exclude 'build' \
  --exclude '.git' \
  --exclude '.cursor' \
  ./ $SERVER:$DEPLOY_DIR/

# Step 2: Deploy on server with temporary daemon.json fix
echo "🔧 Deploying on server..."
ssh $SERVER << 'EOF'
set -e
cd /www/doc-record

# Stop existing containers
echo "Stopping existing containers..."
docker compose down 2>/dev/null || true

# Backup current daemon.json
echo "Backing up daemon.json..."
sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.backup 2>/dev/null || true

# Temporarily remove broken mirror
echo "Temporarily removing dockerproxy.net mirror..."
echo '{}' | sudo tee /etc/docker/daemon.json > /dev/null
sudo systemctl restart docker
sleep 3

# Build and start
echo "Building and starting containers..."
docker compose up -d --build

# Restore daemon.json
echo "Restoring daemon.json..."
sudo mv /etc/docker/daemon.json.backup /etc/docker/daemon.json 2>/dev/null || true
sudo systemctl restart docker 2>/dev/null || echo "Skipping docker restart (container already running)"

echo "✅ Deployment completed!"
docker compose ps
EOF

echo "✨ Deployment finished successfully!"
echo "🌐 Visit: http://129.204.8.61/doc-record"
