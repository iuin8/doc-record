#!/bin/zsh
set -u
umask 077

BASE_DIR="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
PLIST_PATH="/Users/fa/Library/LaunchAgents/com.fa.cloud-disks.plist"
DOMAIN="gui/$(/usr/bin/id -u)"

fail() {
    print -r -- "$*" >&2
    exit 1
}

[[ -r "$BASE_DIR/_bin/mount_all.sh" ]] || fail "missing scanner: $BASE_DIR/_bin/mount_all.sh"
[[ -r "$BASE_DIR/_bin/sshfs_mount.sh" ]] || fail "missing runner: $BASE_DIR/_bin/sshfs_mount.sh"

/bin/mkdir -p "$(/usr/bin/dirname "$PLIST_PATH")" /Users/fa/Library/Logs/cloud-disks
/bin/chmod 700 /Users/fa/Library/Logs/cloud-disks
/bin/cat > "$PLIST_PATH" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.fa.cloud-disks</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>${BASE_DIR}/_bin/mount_all.sh</string>
        <string>${BASE_DIR}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartInterval</key>
    <integer>60</integer>
    <key>StandardOutPath</key>
    <string>/Users/fa/Library/Logs/cloud-disks/scanner.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/fa/Library/Logs/cloud-disks/scanner.err.log</string>
</dict>
</plist>
PLIST

/usr/bin/plutil -lint "$PLIST_PATH" >/dev/null || fail "invalid plist: $PLIST_PATH"
launchctl bootout "$DOMAIN" "$PLIST_PATH" >/dev/null 2>&1 || true
launchctl bootstrap "$DOMAIN" "$PLIST_PATH"
launchctl kickstart -k "$DOMAIN/com.fa.cloud-disks"
