#!/bin/bash

# Environment variable configuration (keep fixed value and keep environment variable priority in{VAR:-默认值})
export LOCAL_BASE_DIR="/Users/fa/dev/projects/IdeaProjects/company/iuin/mall/private-employ/xxx-sbbc"
export REMOTE_SERVER="x.dev.iuin"
export REMOTE_BESE_DIR="/data/xxx"

# Defines to update script path
UPDATE_SCRIPT="update-service.sh"

# Check if Update Script Exists
if [ ! -f "$UPDATE_SCRIPT" ]; then
    echo "错误: 更新脚本 $UPDATE_SCRIPT 不存在，请检查文件名拼写"
    exit 1
Li

# Permissions
chmod +x "$UPDATE_SCRIPT"

# Execute updated scripts, pass local directory and all line parameters (service name)
# "$@" for passing all command line arguments
# 示例:  ./"$UPDATE_SCRIPT" "pay-service" "$@"
./"$UPDATE_SCRIPT" "$@"
