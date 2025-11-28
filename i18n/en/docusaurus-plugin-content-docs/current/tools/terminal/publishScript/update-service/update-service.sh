#!/bin/bash

# Configuration Parameter - Prefer Environment Variable, Second Command Line Parameters
# Environmental variables: LOCAL_BASE_DIR, REMOTE_SERVER, REMOTE_BASE_DIR
if [ -z "$LOCAL_BASE_DIR" ]; then
    if [ # -lt 1 ]; then
        echo "Usage: $0 <Local Service Directory> [服务名1] [服务名2].."
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
REMOTE_BASSE_DIR="${REMOTE_BA_DIR:-/data/x}"

# Checks if local directories exist
if [ ! -d "$LOCAL_BASE_DIR" ]; then
    echo "错误: 本地目录 $LOCAL_BASE_DIR 不存在"
    exit 1
Li

# Find all subdirectories with -service end and exact service names
ALL_SERVICE_DIRS=$(find "$LOCAL_BASE_DIR" -maxdepth 1 -type d -name "*-service")
ALL_SERVICES=$(basename -a $ALL_SERVICE_DIRS)

# Check if service directory is found
if [ -z "$ALL_SERVICE_DIRS" ]; then
    echo "在 $LOCAL_BASE_DIR 中未找到以-service结尾的目录"
    exit 1
Li

# Show all available services
echo "List of Available Services:"
echo "-----------"
printf "%s\n" "${ALL_SERVICES[@]}"
echo "-------"

# Are you sure you want to update, all if not specified
if [ # -eq 0]; then
    SERVICES_TO_UPDATE=($ALL_SERVICES)
    echo "No services specified, all services will be updated"
else
    SERVICES_TO_UPDATE=("$@")
    
    # Verify that the specified service exists
    for service in "${SERVICES_TO_UPDATE[@]}"; do
        if ! echo "${ALL_SERVICES[@]}" | grep -q -w "$service"; then
            echo "警告: 服务 $service 不存在，将跳过"
            SERVICES_TO_UPDATE=("${SERVICES_TO_UPDATE[@]/$service}")
        Li
    done
    
    # Check if there is a service that needs to be updated after being authenticated
    if [ ${#SERVICES_TO_UPDATE[@]} -eq 0]; then
        echo "No valid service needs updating"
        exit 1
    Li
    
    echo "Will Update the following services:"
    echo "_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________ _______ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ________ ___________________________________________________________________________ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______ _______
    printf "%s\n" "${SERVICES_TO_UPDATE[@]}"
    echo "-------------------------"
fi

# Processing services by one
for service in "${SERVICES_TO_UPDATE[@]}"; do
    SERVICE_DIR="$LOCAL_BASE_DIR/$service"
    echo "开始处理服务: $service"
    
    # Finish the latest JAR files (sorted by version number)
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
    echo "Starting service mode..."
    # ssh "$REMOTE_SERVER" "cd $REMOTE_BASE_DIR/$service && chown www:www $REMOTE_BASE_DIR/$service/$service-*.jar && su www -c './$service-start.sh'"
    # ssh "$REMOTE_SERVER" "cd $REMOTE_BASE_DIR/$service && chown www:www $service-*.jar && su www && ./$service-start.sh"
    ssh "$REMOTE_SERVER" "chown www:www $REMOTE_BASE_DIR/$service/$service-*.jar && su - www -c '$REMOTE_BASE_DIR/$service/$service-start.sh'"
    
    echo "$service 处理完成"
    echo "-------------------------"
done

echo "All Specified Services Complete"
