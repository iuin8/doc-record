#!/bin/zsh
set -u
umask 077

CONFIG_FILE="${1:-}"
if [[ -z "$CONFIG_FILE" ]]; then
    print -r -- "usage: $0 /path/to/cloud-disk.conf" >&2
    exit 64
fi

fail_runtime() {
    local message="$1"
    print -r -- "$message" >&2
    exit 77
}

reject_symlink_path_components() {
    local path="$1"
    local current=""
    local part

    for part in ${(s:/:)${path#/}}; do
        [[ -n "$part" ]] || continue
        current="${current}/${part}"
        if [[ -L "$current" ]]; then
            fail_runtime "path component must not be a symlink: $current"
        fi
    done
}

reject_symlink_path_components "$CONFIG_FILE"

if [[ ! -f "$CONFIG_FILE" || -L "$CONFIG_FILE" || ! -r "$CONFIG_FILE" ]]; then
    print -r -- "invalid config: $CONFIG_FILE" >&2
    exit 66
fi

config_owner="$(/usr/bin/stat -f '%u' "$CONFIG_FILE")"
if [[ "$config_owner" != "$(/usr/bin/id -u)" ]]; then
    print -r -- "config owner mismatch: $CONFIG_FILE" >&2
    exit 77
fi

config_mode="$(/usr/bin/stat -f '%Lp' "$CONFIG_FILE")"
if (( config_mode > 600 )); then
    print -r -- "config permissions too open: $CONFIG_FILE" >&2
    exit 77
fi

load_config() {
    local line key value seen_keys=" "
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        if [[ ! "$line" =~ '^[A-Z_]+="[^"\\]*"$' ]]; then
            print -r -- "invalid config line, expected KEY=\"VALUE\": $line" >&2
            exit 78
        fi

        key="${line%%=*}"
        value="${line#*=}"
        value="${value%\"}"
        value="${value#\"}"

        case "$key" in
            REMOTE|MOUNT_POINT|SSH_PORT|IDENTITY_FILE|LOG_DIR|MOUNT_TIMEOUT|PROBE_TIMEOUT|UNMOUNT_TIMEOUT|EXTRA_SSHFS_OPTS)
                if [[ "$seen_keys" == *" $key "* ]]; then
                    print -r -- "duplicate config key: $key" >&2
                    exit 78
                fi
                seen_keys="${seen_keys}${key} "
                typeset -g "$key=$value"
                ;;
            *)
                print -r -- "unknown config key: $key" >&2
                exit 78
                ;;
        esac
    done < "$CONFIG_FILE"
}

die_config() {
    local message="$1"
    print -r -- "$message" >&2
    exit 78
}

require_no_control_chars() {
    local name="$1"
    local value="$2"
    if [[ "$value" == *$'\r'* || "$value" == *$'\n'* ]]; then
        die_config "invalid control character in ${name}"
    fi
}

require_no_commas() {
    local name="$1"
    local value="$2"
    if [[ "$value" == *,* ]]; then
        die_config "commas are not allowed in ${name}"
    fi
}

require_safe_argument() {
    local name="$1"
    local value="$2"
    require_no_control_chars "$name" "$value"
    if [[ -z "$value" || "$value" == -* ]]; then
        die_config "invalid argument: ${name}=${value}"
    fi
}

require_absolute_path() {
    local name="$1"
    local value="$2"
    require_safe_argument "$name" "$value"
    if [[ "$value" != /* ]]; then
        die_config "path must be absolute: ${name}=${value}"
    fi
}

require_positive_integer() {
    local name="$1"
    local value="$2"
    if [[ ! "$value" =~ '^[1-9][0-9]*$' ]]; then
        die_config "invalid positive integer: ${name}=${value}"
    fi
}

require_tcp_port() {
    local name="$1"
    local value="$2"
    require_positive_integer "$name" "$value"
    if (( value < 1 || value > 65535 )); then
        die_config "invalid TCP port: ${name}=${value}"
    fi
}

validate_extra_sshfs_opts() {
    local opts="$1"
    local opt name value

    [[ -z "$opts" ]] && return 0
    if [[ ! "$opts" =~ '^[A-Za-z0-9_.,=:@%+/-]+$' ]]; then
        die_config "EXTRA_SSHFS_OPTS contains unsupported characters"
    fi

    for opt in ${(s:,:)opts}; do
        [[ -n "$opt" ]] || die_config "empty EXTRA_SSHFS_OPTS item"
        name="${opt%%=*}"
        value="${opt#*=}"

        case "$name" in
            allow_other|default_permissions|follow_symlinks|negative_vncache|noatime|ro)
                [[ "$opt" == "$name" ]] || die_config "EXTRA_SSHFS_OPTS option takes no value: $name"
                ;;
            idmap)
                [[ "$value" == "user" ]] || die_config "unsupported EXTRA_SSHFS_OPTS value: ${name}=${value}"
                ;;
            uid|gid|max_read|max_write|attr_timeout|entry_timeout|cache_timeout)
                require_positive_integer "EXTRA_SSHFS_OPTS.${name}" "$value"
                ;;
            umask)
                [[ "$value" =~ '^[0-7]{3,4}$' ]] || die_config "invalid EXTRA_SSHFS_OPTS umask: $value"
                ;;
            volname)
                [[ "$value" =~ '^[A-Za-z0-9._-]+$' ]] || die_config "invalid EXTRA_SSHFS_OPTS volname: $value"
                ;;
            workaround)
                [[ "$value" =~ '^[A-Za-z0-9:_-]+$' ]] || die_config "invalid EXTRA_SSHFS_OPTS workaround: $value"
                ;;
            *)
                die_config "unsupported EXTRA_SSHFS_OPTS option: $name"
                ;;
        esac
    done
}

validate_config() {
    [[ -n "${REMOTE:-}" ]] || die_config "missing config key: REMOTE"

    local remote_target="${REMOTE%%:*}"
    DISK_ID="${remote_target##*@}"
    [[ "$DISK_ID" =~ '^[A-Za-z0-9][A-Za-z0-9._-]*$' ]] || die_config "invalid derived DISK_ID: $DISK_ID"
    require_safe_argument REMOTE "$REMOTE"
    [[ "$REMOTE" == *:* ]] || die_config "REMOTE must look like host:/path"
    require_absolute_path MOUNT_POINT "$MOUNT_POINT"
    require_absolute_path IDENTITY_FILE "$IDENTITY_FILE"
    require_no_commas IDENTITY_FILE "$IDENTITY_FILE"
    require_absolute_path LOG_DIR "$LOG_DIR"
    require_no_commas LOG_DIR "$LOG_DIR"
    require_tcp_port SSH_PORT "$SSH_PORT"
    require_positive_integer MOUNT_TIMEOUT "$MOUNT_TIMEOUT"
    require_positive_integer PROBE_TIMEOUT "$PROBE_TIMEOUT"
    require_positive_integer UNMOUNT_TIMEOUT "$UNMOUNT_TIMEOUT"
    validate_extra_sshfs_opts "$EXTRA_SSHFS_OPTS"
}

SSH_PORT="22"
IDENTITY_FILE="/Users/fa/.ssh/id_ed25519_sshfs_fa"
LOG_DIR="/Users/fa/Library/Logs/cloud-disks"
MOUNT_TIMEOUT="30"
PROBE_TIMEOUT="5"
UNMOUNT_TIMEOUT="10"
EXTRA_SSHFS_OPTS=""

load_config
: "${REMOTE:?missing REMOTE}"
remote_target="${REMOTE%%:*}"
DISK_ID="${remote_target##*@}"
MOUNT_POINT="${MOUNT_POINT:-/Users/fa/mount/cloud-disks/${DISK_ID}}"
validate_config

SSHFS_OPTS="auto_cache,reconnect,defer_permissions,noappledouble,nolocalcaches,BatchMode=yes,NumberOfPasswordPrompts=0,ConnectTimeout=5,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=${IDENTITY_FILE},IdentitiesOnly=yes${EXTRA_SSHFS_OPTS:+,${EXTRA_SSHFS_OPTS}}"
LOG_FILE="${LOG_DIR}/${DISK_ID}.log"

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

prepare_logs() {
    reject_symlink_path_components "$LOG_DIR"
    /bin/mkdir -p "$LOG_DIR" || fail_runtime "failed to create log directory: $LOG_DIR"
    reject_symlink_path_components "$LOG_DIR"
    /bin/chmod 700 "$LOG_DIR" || fail_runtime "failed to chmod log directory: $LOG_DIR"
    if [[ -L "$LOG_FILE" ]]; then
        fail_runtime "log file must not be a symlink: $LOG_FILE"
    fi
    : > "$LOG_FILE" || fail_runtime "failed to create log file: $LOG_FILE"
    if [[ -L "$LOG_FILE" ]]; then
        fail_runtime "log file must not be a symlink: $LOG_FILE"
    fi
    /bin/chmod 600 "$LOG_FILE" || fail_runtime "failed to chmod log file: $LOG_FILE"
}

log() {
    print -r -- "[$(/bin/date '+%Y-%m-%d %H:%M:%S')] [$DISK_ID] $*" >> "$LOG_FILE"
}

run_with_timeout() {
    local seconds="$1"
    shift

    /usr/bin/perl -e '
        use strict;
        use warnings;
        use POSIX qw(setsid);

        my $seconds = shift @ARGV;
        die "missing timeout command\n" unless @ARGV;

        my $pid = fork();
        die "fork failed: $!\n" unless defined $pid;

        if ($pid == 0) {
            setsid() or die "setsid failed: $!\n";
            exec @ARGV;
            exit 127;
        }

        local $SIG{ALRM} = sub {
            kill "TERM", -$pid;
            sleep 2;
            kill "KILL", -$pid;
            waitpid($pid, 0);
            exit 124;
        };

        alarm $seconds;
        waitpid($pid, 0);
        my $status = $?;
        alarm 0;

        exit($status >> 8) if $status >= 0 && ($status & 127) == 0;
        exit(128 + ($status & 127));
    ' "$seconds" "$@"
}

resolve_sshfs() {
    local candidate
    for candidate in /opt/homebrew/bin/sshfs /usr/local/bin/sshfs; do
        if [[ -x "$candidate" ]]; then
            print -r -- "$candidate"
            return 0
        fi
    done

    return 1
}

mount_record() {
    /sbin/mount | /usr/bin/grep -F " on ${MOUNT_POINT} " | /usr/bin/head -n 1
}

is_expected_mount() {
    local record expected_fuse_source
    record="$(mount_record)"
    expected_fuse_source="fuse-t:/${DISK_ID}"
    [[ -n "$record" ]] || return 1
    [[ "$record" == "${REMOTE} on ${MOUNT_POINT} "* || "$record" == "${expected_fuse_source} on ${MOUNT_POINT} "* ]] || return 1
    [[ "$record" == *"sshfs"* || "$record" == *"fuse"* || "$record" == *"nfs"* ]] || return 1
}

is_mounted() {
    [[ -n "$(mount_record)" ]]
}

is_mount_healthy() {
    is_expected_mount && run_with_timeout "$PROBE_TIMEOUT" /usr/bin/stat "$MOUNT_POINT" >/dev/null 2>&1
}

unmount_stale_mount() {
    if ! is_mounted; then
        return 0
    fi

    if ! is_expected_mount; then
        log "挂载点已被非本配置的文件系统占用，拒绝自动卸载"
        return 1
    fi

    log "挂载点健康检查失败，自动路径只尝试普通卸载"
    run_with_timeout "$UNMOUNT_TIMEOUT" /usr/sbin/diskutil unmount "$MOUNT_POINT" >> "$LOG_FILE" 2>&1 && return 0

    log "普通卸载失败；为避免数据丢失，不在 launchd 自动路径执行强制卸载"
    run_with_timeout 5 /usr/sbin/lsof +f -- "$MOUNT_POINT" >> "$LOG_FILE" 2>&1 || true
    return 1
}

self_test() {
    run_with_timeout 2 /bin/sh -c 'exit 0' || return 1
    run_with_timeout 1 /bin/sleep 5
    [[ $? -eq 124 ]] || return 1

    local marker="/tmp/sshfs_mount_timeout_child_$$"
    /bin/rm -f "$marker"
    run_with_timeout 1 /bin/sh -c "/bin/sh -c 'sleep 3; touch $marker' & wait"
    [[ $? -eq 124 ]] || return 1
    /bin/sleep 4
    [[ ! -e "$marker" ]] || return 1
    return 0
}

main() {
    prepare_logs

    if is_mounted; then
        if is_mount_healthy; then
            log "挂载点已可用，跳过"
            return 0
        fi

        log "挂载点存在但健康检查失败"
        unmount_stale_mount || return 1
    fi

    reject_symlink_path_components "$MOUNT_POINT"
    /bin/mkdir -p "$MOUNT_POINT" || fail_runtime "failed to create mount point: $MOUNT_POINT"

    local sshfs_path
    sshfs_path="$(resolve_sshfs)"
    if [[ -z "$sshfs_path" ]]; then
        log "未找到 sshfs，请先安装 macOS 兼容的 sshfs-fuse-t"
        return 127
    fi

    log "开始挂载 ${REMOTE} -> ${MOUNT_POINT}"
    run_with_timeout "$MOUNT_TIMEOUT" "$sshfs_path" -p "$SSH_PORT" "$REMOTE" "$MOUNT_POINT" -o "$SSHFS_OPTS" >> "$LOG_FILE" 2>&1
    local mount_exit_code=$?

    if [[ $mount_exit_code -eq 0 ]] && is_expected_mount; then
        log "SSHFS 挂载成功"
        return 0
    fi

    log "SSHFS 挂载失败，exit=${mount_exit_code}"
    return 1
}

if [[ "${2:-}" == "--self-test" ]]; then
    self_test
    exit $?
fi

main "$@"
