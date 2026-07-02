#!/bin/zsh
# ===================== 配置区 ==========================
REMOTE="fa.intranet.company:/data/nfs_share/dev"
MOUNT_POINT="/Users/fa/mount/sshfs/fa.intranet.company"
SSH_HOST="fa.intranet.company"
SSHFS_PATH="/usr/local/bin/sshfs"
# 剔除全部不兼容参数：noowners/soft/nonempty/large_read
SSHFS_OPTS="auto_cache,reconnect,defer_permissions,workaround=rename:truncate:buflimit,noatime,allow_other,max_read=65536,max_write=131072,negative_vncache,attr_timeout=3,entry_timeout=3,ServerAliveInterval=15,ServerAliveCountMax=3,Ciphers=aes128-gcm@openssh.com,Compression=no,noappledouble,nolocalcaches"
# ========================================================

mkdir -p "${MOUNT_POINT}"

while true; do
    # 已挂载则休眠30秒再检测
    if mount | grep -q "${MOUNT_POINT}"; then
        sleep 30
        continue
    fi

    # 检测SSH 22端口连通
    if ! nc -z -w2 "${SSH_HOST}" 22; then
        sleep 3
        continue
    fi

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络就绪，尝试挂载..."
    # 合并stderr，所有报错直接输出日志
    ${SSHFS_PATH} ${REMOTE} ${MOUNT_POINT} -o ${SSHFS_OPTS} 2>&1
    ret=$?

    if mount | grep -q "${MOUNT_POINT}"; then
        echo "✅ 挂载成功，进入静默监控"
    else
        echo "❌ 挂载失败，sshfs exit code: $ret，3秒后重试"
        sleep 3
    fi
done