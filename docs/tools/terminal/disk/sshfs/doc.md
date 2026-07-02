# sshfs使用记录

## 使用

```bash
# 挂载
sshfs xx@xx.intranet:/data/nfs_share/dev /Users/xx/mount/sshfs/xx.intranet
# 如果挂载失败，可以查看系统日志：
log show --predicate 'process == "mount_nfs"' --info --last 1m
# 或
cat /var/log/system.log | grep mount_nfs

# 卸载
fusermount -u /path/to/mountpoint
umount /path/to/mountpoint
# 强制卸载（如果普通方法无效）使用 fusermount -uz（懒卸载）
fusermount -uz /path/to/mountpoint
# 使用 umount -l（懒卸载）
umount -l /path/to/mountpoint
# 检查是否卸载成功
mount | grep sshfs

# 其他方式(umount(/path/to/mountpoint): Resource busy -- try 'diskutil unmount')
diskutil unmount /path/to/mountpoint
```

- 其他参数

```bash
# 前台操作
sshfs -f [user@]host:[dir] mountpoint
# 自动重连
sshfs -o reconnect [user@]host:[dir] mountpoint
# 延迟连接
sshfs -o delay_connect [user@]host:[dir] mountpoint
# 同步写入
sshfs -o sshfs_sync [user@]host:[dir] mountpoint
# 缓存设置
sshfs -o cache=yes -o kernel_cache -o auto_cache [user@]host:[dir] mountpoint
# 用户/组映射(-o idmap=user 确保只有当前用户的 UID/GID 被映射，适合单用户环境。)
sshfs -o idmap=user [user@]host:[dir] mountpoint
# 允许其他用户访问(-o allow_other 允许其他用户访问挂载的文件系统，但需要 root 权限，并且需要在 /etc/fuse.conf 中启用 user_allow_other。)
sshfs -o allow_other [user@]host:[dir] mountpoint
# SSH 配置(-F 选项可以指定自定义的 SSH 配置文件，方便管理 SSH 连接参数。)
sshfs -F /path/to/ssh_config [user@]host:[dir] mountpoint
# 最大连接数(-o max_conns=4 可以设置最大并行 SSH 连接数，适合高并发场景。)
sshfs -o max_conns=4 [user@]host:[dir] mountpoint
# 端口指定(-p 2222 指定 SSH 端口为 2222，适合非默认端口的情况。)
sshfs -p 2222 [user@]host:[dir] mountpoint

```

- 示例

```bash
sshfs -o reconnect -o cache=yes -o kernel_cache -o auto_cache  -o max_conns=4 example.com:/home/user/data /mnt/remote_data
```

## 永久挂载远程文件系统

```bash
# 编辑 automount 配置
sudo nano /etc/auto_master
# 在文件最后一行添加：
/System/Volumes/Data/Users/xx/mount/sshfs /etc/auto_sshfs

# 按 Ctrl+O 然后, 回车↩︎保存，Ctrl+X 退出。

# 创建 sshfs 挂载配置
sudo nano /etc/auto_sshfs
# 写入下面这一行内容（直接复制，把你自己的信息填好）：
xx.intranet.company -fstype=sshfs,allow_other,default_permissions,uid=$(id -u),gid=$(id -g) xx.intranet.company:/data/nfs_share/dev

# 说明（不用改）
# xx.intranet.company：最终本地路径的最后一级文件夹名
# 后面是你的远程服务器路径：xx.intranet.company:/data/nfs_share/dev

# 加载配置，立即生效
sudo automount -cv
# 执行完就已经永久挂载完成了！

# 测试是否成功. 直接访问路径即可自动挂载：
ls /Users/xx/mount/sshfs/xx.intranet.company

# 只要能列出文件，就说明：
# ✅ 永久挂载配置成功
# ✅ 开机自动挂载
# ✅ 断网重连自动恢复
```
