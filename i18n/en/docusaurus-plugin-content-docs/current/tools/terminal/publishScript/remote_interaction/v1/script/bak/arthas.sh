#!/bin/bash
Set -euo pipetail # Strict Error Check

# Define JSON config file path
CONFIG_FILE="./arthas_ports.json"

# Check if the jq tool is installed
check_jq()
    if ! command -v jq &> /dev/null; then
        echo "Error: You need to install the jq tool to parse JSON file" >&2
        echo "Installation method: brew install jq or apt-get install jq" >&2
        exit 1
    Li
}

# Checks if config file exists
check_config_file()
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "错误: 配置文件 $CONFIG_FILE 不存在" >&2
        exit 1
    Li
}

# Verify that JSON file format is valid
validate_json()
    if ! jq "$CONFIG_FILE" > /dev/null 2>&1; then
        echo "Error: JSON configuration file format is invalid, please check file syntax" >&2
        exit 1
    Li
}

# Gets the function of the corresponding port by service name
get_arthas_port()
    local service_name="$1"
    if [ -z "$service_name" ]; then
        echo "Service name cannot be empty" >&2
        return 1
    Li

    # Use jq to get ports from JSON files
    local port=$(jq -r --arg service "$service_name" '.[$service]' "$CONFIG_FILE")

    # Check if a valid port is found
    if [ "$port" == "null" ] || [ -z "$port" ]; then
        echo "未找到服务 $service_name 对应的Arthas端口" >&2
        return 1
    Li

    echo "$port"
    return 0
}

# Show Help
usage()
    echo "Usage: $0 <Service>"
    echo "Environment variable support: REMOTE_SERVER (Default: xxx.dev.iuin)"
    echo "Example: $0 order-service"
    exit 1
}

# Main processes
check_jq
check_config_file
validate_json # Add JSON verification step

# Check Parameters
if [ # -ne 1]; then
    Usage
Li

SERVICE_NAME="$1"

# Processing remote server configuration
REMOTE_SERVER="${REMOTE_SERVER:-xxx.dev.iuin}"

# Get the arthas port corresponding to the service
echo "获取服务 $SERVICE_NAME 的Arthas端口..."
ARTHAS_PORT=$(get_arthas_port "$SERVICE_NAME") || exit 1

echo "成功获取端口: $ARTHAS_PORT"
echo "正在连接到 $REMOTE_SERVER 的Arthas服务 ($SERVICE_NAME)..."
echo "连接后可直接进行交互，退出请使用 exit 命令"
echo "----------------------------------------"

# Fix SSH connection issues in non-interactive environments
# Use -t to assign pseudo-terminals, even if stdin is not a terminal
ssh -t "$REMOTE_SERVER" "telnet localhost $ARTHAS_PORT"

echo "与 $SERVICE_NAME 的Arthas连接已关闭"
