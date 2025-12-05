#!/bin/bash

# Deploy using systemd proxy configuration for Docker daemon
# This makes Docker daemon use the SSH-forwarded proxy

set -e

SERVER="fa.internet.tencent"
DEPLOY_DIR="/www/doc-record"

echo "🚀 Starting deployment with daemon proxy..."

# Sync files
echo "📤 Syncing files..."
rsync -avz --delete \
  --exclude 'node_modules' --exclude 'build' --exclude '.git' --exclude '.cursor' \
  ./ $SERVER:$DEPLOY_DIR/

echo "🔧 Configuring Docker daemon proxy and deploying..."
ssh $SERVER bash << 'ENDSSH'
set -e
cd /www/doc-record

# Stop existing containers
docker compose down 2>/dev/null || true

# Configure Docker daemon to use proxy via systemd
echo "Configuring Docker daemon proxy..."
sudo mkdir -p /etc/systemd/system/docker.service.d

sudo cat > /tmp/http-proxy.conf << 'EOF'
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:19093"
Environment="HTTPS_PROXY=http://127.0.0.1:19093"
Environment="NO_PROXY=localhost,127.0.0.1"
EOF

sudo mv /tmp/http-proxy.conf /etc/systemd/system/docker.service.d/http-proxy.conf

# Reload and restart Docker
echo "Restarting Docker daemon..."
sudo systemctl daemon-reload
sudo systemctl restart docker
sleep 3

# Clear broken daemon.json
echo '{}' | sudo tee /etc/docker/daemon.json > /dev/null

# Build and start
echo "Building with daemon proxy..."
docker compose up -d --build

echo "✅ Deployment completed!"
docker compose ps
ENDSSH

echo "✨ Deployment successful!"
echo "🌐 Visit: http://129.204.8.61/doc-record"
