#!/bin/bash
#set -x # Output all executed commands
Set -euo pipetail # Strict Error Check

# Configuration Parameter - Prefer Environment Variable, Second Command Line Parameters
# Environmental variables: LOCAL_BASE_DIR, REMOTE_SERVER, REMOTE_BASE_DIR
if [ -z "$LOCAL_BASE_DIR" ]; then
    if [ # -lt 1 ]; then
        echo "Usage: $0 <Local Service Directory> [服务名1] [服务名2]..."
        echo "Environmental variable support: LOCAL_BASE_DIR, REMOTE_SERVER, REMOTE_BASE_DIR"
        echo "Example 1: Update all services under the specified directory"
        echo " 0 /path/to/services"
        echo "Example 2: only update specified services"
        echo " 0 /path/to/services pay-service order-service"
        exit 1
    Li
    LOCAL_BASE_DIR="$1"
    Shift # Remove directory parameters, all remaining service names to update
Li

# Processing remote server configuration
REMOTE_SERVER="${REMOTE_SERVER:-xxx.dev.iuin}"
REMOTE_BASE_DIR="${REMOTE_BA_DIR:-/data/xx}"

# Checks if local directory exists
if [ ! -d "$LOCAL_BASE_DIR" ]; then
    echo "错误: 本地目录 $LOCAL_BASE_DIR 不存在"
    exit 1
Li

SERVICES_TO_UPDATE=("$@")

# Check if there is a service that needs to be updated after being verified
if [ ${#SERVICES_TO_UPDATE[@]} -eq 0]; then
    echo "No valid service needs updating"
    exit 1
Li

echo "The following services will be updated:"
echo "-------------"
printf "%s\n" "${SERVICES_TO_UPDATE[@]}"
echo "----------"

# Processing services by one
for service in "${SERVICES_TO_UPDATE[@]}"; do
    SERVICE_DIR="$LOCAL_BASE_DIR/$service"
    echo "开始处理服务: $service"

    # Find the latest JAR files (sorted by version number)
    JAR_FILE=$(find "$SERVICE_DIR/build/libs" -maxdepth 1 -type f -name "$service-*.jar" | sort -V | tail -1)

    if [ -z "$JAR_FILE" ]; then
        echo "警告: 在 $SERVICE_DIR/build/libs 中未找到JAR文件，跳过该服务"
        to continue
    Li

    echo "找到JAR文件: $JAR_FILE"

    # Upload JAR file to Remote Server
    echo "正在上传文件到 $REMOTE_SERVER:$REMOTE_BASE_DIR/$service/..."
    scp "$JAR_FILE" "$REMOTE_SERVER:$REMOTE_BASE_DIR/$service/"

    if [ ? -ne 0 ]; then
        echo "Warning: File upload failed, skipping service"
        to continue
    Li

    # Remote boot service
    echo "Starting service remote..."
     ssh "$REMOTE_SERVER" "chown www:www $REMOTE_BASE_DIR/$service/$service-*.jar && su - www -c '$REMOTE_BASE_DIR/$service/$service-start.sh'"
    # ssh "$REMOTE_SERVER" "chown www:www $REMOTE_BASE_DIR/$service/$service-*.jar && sudo systemctl restart $service"
#    ssh "$REMOTE_SERVER" "chown www:www $REMOTE_BASE_DIR/$service/$service-*.jar && systemctl restart $service"

    echo "$service 处理完成"
    echo "-------------------------"
done

echo "All Specified Services Complete"