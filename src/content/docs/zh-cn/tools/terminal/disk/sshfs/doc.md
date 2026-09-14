# SSHFS 多云端磁盘自动挂载

## 生产级目录设计

只保留一个 launchd 服务：`com.fa.cloud-disks`。`_bin/bootstrap.sh` 会按当前 `cloud-disks` 目录生成路径稳定的 `~/Library/LaunchAgents/com.fa.cloud-disks.plist`；该服务周期执行 `_bin/mount_all.sh`，每次扫描所有 `cloud-disks/*/cloud-disk.conf`，所以新增云盘只需要新增一个目录和配置文件，下一轮自动生效，不需要再新增服务。

```text
cloud-disks/
├── _bin/
│   ├── bootstrap.sh                 # 生成并加载 ~/Library/LaunchAgents/com.fa.cloud-disks.plist
│   ├── mount_all.sh                 # 扫描所有云盘配置
│   └── sshfs_mount.sh               # 单盘 one-shot runner
└── fa.intranet.company/
    └── cloud-disk.conf              # 单盘配置；新增云盘只复制这一类目录
```

- `cloud-disk.conf` 只需要配置 `REMOTE`；磁盘 ID、默认挂载点、默认日志名都从 SSH host 自动推导。
- `mount_all.sh` 每 60 秒扫描一次 `cloud-disks/*/cloud-disk.conf`。
- 新增云盘目录后无需新增 plist；下一轮扫描自动尝试挂载。

## 配置字段

最小配置：

```bash
REMOTE="fa.intranet.company:/data/nfs_share/dev"
```

可选覆盖项：

```bash
SSH_PORT="22"
IDENTITY_FILE="/Users/fa/.ssh/id_ed25519_sshfs_fa"
LOG_DIR="/Users/fa/Library/Logs/cloud-disks"
MOUNT_TIMEOUT="30"
PROBE_TIMEOUT="5"
UNMOUNT_TIMEOUT="10"
EXTRA_SSHFS_OPTS=""
```

配置由 runner 按严格 `KEY="VALUE"` 文本解析，不会被 `source` 执行；`DISK_ID` 从 `REMOTE` 的 SSH host 自动推导；默认挂载点为 `/Users/fa/mount/cloud-disks/${host}`，默认日志为 `/Users/fa/Library/Logs/cloud-disks/${host}.log`。

## 首次准备

```bash
# 1. 安装能提供 sshfs 命令的 macOS 实现
brew install macos-fuse-t/homebrew-cask/sshfs-fuse-t

# 2. 确认 sshfs 位于 runner 允许的绝对路径之一
ls /opt/homebrew/bin/sshfs /usr/local/bin/sshfs

# 3. 准备非交互 SSH key
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_sshfs_fa -C "cloud-disk-fa.intranet.company" -N ""
chmod 600 ~/.ssh/id_ed25519_sshfs_fa

# 4. 首次交互连接，接受并固定 host key；如果提示认证失败，先把公钥加入远端 authorized_keys
ssh -i ~/.ssh/id_ed25519_sshfs_fa -p 22 fa.intranet.company true

# 5. 最终认证检查：不得出现密码、passphrase、host key 交互提示
ssh -i ~/.ssh/id_ed25519_sshfs_fa -o BatchMode=yes -o NumberOfPasswordPrompts=0 -p 22 fa.intranet.company true
```

## 启用自动挂载

```bash
find ./cloud-disks -name cloud-disk.conf -exec chmod 600 {} \;
mkdir -p /Users/fa/mount/cloud-disks /Users/fa/Library/Logs/cloud-disks
chmod 700 /Users/fa/Library/Logs/cloud-disks

# 本地验证，不会挂载
/bin/zsh ./cloud-disks/_bin/sshfs_mount.sh ./cloud-disks/fa.intranet.company/cloud-disk.conf --self-test

# 只需要 bootstrap 一次；脚本会生成路径稳定的 ~/Library/LaunchAgents/com.fa.cloud-disks.plist
/bin/zsh ./cloud-disks/_bin/bootstrap.sh ./cloud-disks
launchctl print gui/$(id -u)/com.fa.cloud-disks
```

## 新增云盘

```bash
NEW_HOST="aliyun.example.com"
mkdir -p "./cloud-disks/${NEW_HOST}"
nano "./cloud-disks/${NEW_HOST}/cloud-disk.conf"
chmod 600 "./cloud-disks/${NEW_HOST}/cloud-disk.conf"
```

`cloud-disk.conf` 最少只写：

```bash
REMOTE="aliyun.example.com:/data"
```

保存后不需要再 bootstrap；`com.fa.cloud-disks` 下一轮运行时会自动扫描到它。

## 运维与调试

```bash
# 查看全局扫描服务是否已加载，以及上次退出状态
launchctl print gui/$(id -u)/com.fa.cloud-disks

# 立即触发一次扫描；新云盘无需重新 bootstrap，用这个命令加速下一轮
launchctl kickstart -k gui/$(id -u)/com.fa.cloud-disks

# 卸载全局服务
launchctl bootout gui/$(id -u)/com.fa.cloud-disks

# 查看扫描器本身输出；如果没有任何单盘日志，先看这里
mkdir -p /Users/fa/Library/Logs/cloud-disks
tail -f /Users/fa/Library/Logs/cloud-disks/scanner.log

# 查看单盘日志；文件名默认等于 REMOTE 的 SSH host
tail -f /Users/fa/Library/Logs/cloud-disks/fa.intranet.company.log

# 手动跑一次扫描，直接看 stderr；适合排查 plist 路径、配置权限、runner 不可读
/bin/zsh ./cloud-disks/_bin/mount_all.sh ./cloud-disks

# 手动跑单盘，适合排查 REMOTE、SSH key、sshfs、挂载点和权限问题
/bin/zsh ./cloud-disks/_bin/sshfs_mount.sh ./cloud-disks/fa.intranet.company/cloud-disk.conf

# 查看挂载状态
mount | grep cloud-disks
```

如果 `kickstart` 后没有挂载也没有单盘日志，按顺序查：`launchctl print` 是否显示服务存在、`scanner.log` 是否有 launchd/stdout/stderr 输出、`mount_all.sh` 手动扫描是否能读到配置、`cloud-disk.conf` 是否为当前用户所有且权限不超过 `600`。

## 手动卸载

```bash
# 普通卸载
/usr/sbin/diskutil unmount /Users/fa/mount/cloud-disks/fa.intranet.company

# 仍然失败时再手动强制卸载；自动 runner 不会执行强制卸载，避免数据丢失
/usr/sbin/diskutil unmount force /Users/fa/mount/cloud-disks/fa.intranet.company
/sbin/umount -f /Users/fa/mount/cloud-disks/fa.intranet.company
```

## 设计要点

- 只有一个 launchd 服务：`com.fa.cloud-disks`。
- 新增云盘只新增 `cloud-disks/${ssh-host}/cloud-disk.conf`。
- 目录名、挂载点、日志名默认由 `REMOTE` 的 SSH host 推导，不让用户再自定义 `DISK_ID`。
- `mount_all.sh` 负责扫描所有云盘配置；`sshfs_mount.sh` 负责单盘挂载。
- runner 是 one-shot：已挂载且远端来源匹配才退出；未挂载才尝试挂载一次。
- 自动路径只执行普通卸载；普通卸载失败时记录占用进程，不自动强制卸载。
- 日志目录权限为 `700`，日志文件权限为 `600`，且日志目录、日志文件和挂载点路径中不允许出现软链接。
- `allow_other` 不在默认自动路径里；只有明确需要本机其他用户访问挂载目录时才在 `EXTRA_SSHFS_OPTS` 中显式追加。
