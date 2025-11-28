#!/bin/bash
Set -x # Output All Executed Commands for Debugging
Set -euo pipetail # Strict Error Check

# Environment Variable Configuration
export REMOTE_SERVER="xx.dev.iuin"
export REMOTE_BASE_DIR="/data/xx"
LOCAL_BASE_DIR="" # Initialize local directory variables
declare -a SERVICES =() # array of storage service names

# Parse command line arguments
# Support -d/--dir specify local directory, --s/--service specify service name (multiple can be)
while [[ # -gt 0]]; do
    case "$1" in
        -d|--dir)
            # Process directory parameters
            if [ -n "$2" && ! "$2" =~^- ];then
                if [[ -d "$2" ]]; then
                    # Convert to Absolute Path
                    LOCAL_BASE_DIR=$(cd "$2" && pwd)
                    shift 2
                else
                    echo "Error: -d specified directory $2 does not exist" >&2
                    exit 1
                Li
            else
                echo "Error: -d options need to specify valid directory parameter" >&2
                echo "Use method: $0 [-d directory path]-s service name 1 [服务名2...]>&2
                exit 1
            Li
            ;;
        -s|--service)
            # Process Service Name Parameters (multiple services can be followed)
            shift # skipped - s options
            while [[ # -gt 0 && ! "$1" =~^- ]]; do
                SERVICES+=("$1") # add service names to array
                shift
            done
            ;;
        -h|--help)
            # Show Help Info
            echo "Use method: $0 [-d directory path]-s service name 1 [服务名2...]"
            echo "Options:"
            echo " -d, --dir specify local service directory (default：parent directory of current directory)"
            echo " -s, --service specify the service name to be updated (required, multiple services)"
            echo " -h, --help show help info"
            exit 0
            ;;
        -*)
            # Processing unknown options
            echo "Error: Unknown option $1" >&2
            echo "Use method: $0 [-d directory path]-s service name 1 [服务名2...]>&2
            exit 1
            ;;
        *)
            # Non-option parameters (unused -s specified service name)
            echo "Error: Service name must be specified by -s option" >&2
            echo "Use method: $0 [-d directory path]-s service name 1 [服务名2...]>&2
            exit 1
            ;;
    esac
done

# Set local directory default value (current directory top)
if [[ -z "$LOCAL_BASE_DIR" ]]; then
    LOCAL_BASE_DIR=$(cd "$(pwd)/.." && pwd)
    echo "未指定本地目录，使用默认值: $LOCAL_BASE_DIR"
fi

# Verify local directory exists
if [[ ! -d "$LOCAL_BASE_DIR" ]]; then
    echo "错误: 本地目录 $LOCAL_BASE_DIR 不存在" >&2
    exit 1
Li

export LOCAL_BASE_DIR="$LOCAL_BASE_DIR"

# Check if at least one service name is specified
if [[ ${#SERVICES[@]} -eq 0]]; then
    echo "Error: must specify at least one service name by -s option" >&2
    echo "Use method: $0 [-d directory path]-s service name 1 [服务名2...]>&2
    exit 1
Li

echo "===== 执行配置 ====="
echo "本地目录: $LOCAL_BASE_DIR"
echo "远程服务器: $REMOTE_SERVER"
echo "远程目录: $REMOTE_BASE_DIR"
echo "待处理服务: ${SERVICES[*]}"
echo "===================="

# Defines to update script path
UPDATE_SCRIPT="update-service.sh"

# Check if update script exists
if [[ ! -f "$UPDATE_SCRIPT" ]]; then
    echo "错误: 更新脚本 $UPDATE_SCRIPT 不存在，请检查文件名拼写" >&2
    exit 1
Li

# Add Permissions
chmod +x "$UPDATE_SCRIPT"

# Execute update script：to pass local directories and services list
echo "开始执行更新脚本: $UPDATE_SCRIPT"
#"./$UPDATE_SCRIPT" "$LOCAL_BASE_DIR" "${SERVICES[@]}"
"./$UPDATE_SCRIPT" "${SERVICES[@]}"
