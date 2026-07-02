#!/bin/zsh

# ===================== 你的配置 ==========================
REMOTE="fa.intranet.company:/data/nfs_share/dev"
MOUNT_POINT="/Users/fa/mount/sshfs/fa.intranet.company"
SSH_HOST="fa.intranet.company"
SSHFS_PATH="/usr/local/bin/sshfs"  # 固定正确路径
SSHFS_OPTS="auto_cache,reconnect,defer_permissions,noappledouble,nolocalcaches"
# ========================================================

# 确保挂载目录存在
mkdir -p "${MOUNT_POINT}"

# 无限循环检测
while true; do
    # 1. 已经挂载 → 等待30秒再检查
    if mount | grep -q "${MOUNT_POINT}"; then
        sleep 30
        continue
    fi

    # 2. 网络没通 → 跳过
    if ! nc -z -w2 "${SSH_HOST}" 22; then
        sleep 3
        continue
    fi

    # ================ 核心挂载（带错误输出） ================
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络就绪，尝试挂载..."
    ${SSHFS_PATH} ${REMOTE} ${MOUNT_POINT} -o ${SSHFS_OPTS}

    # 检查是否挂载成功
    if mount | grep -q "${MOUNT_POINT}"; then
        echo "✅ 挂载成功！"
    else
        echo "❌ 挂载失败！请检查密码/密钥/权限"
        sleep 2
    fi
done