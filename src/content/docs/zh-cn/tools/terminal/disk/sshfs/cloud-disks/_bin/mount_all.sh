#!/bin/zsh
set -u
umask 077

BASE_DIR="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
RUNNER="${BASE_DIR}/_bin/sshfs_mount.sh"

if [[ ! -r "$RUNNER" ]]; then
    print -r -- "runner not readable: $RUNNER" >&2
    exit 66
fi

failed=0
for conf in "$BASE_DIR"/*/cloud-disk.conf; do
    [[ -f "$conf" ]] || continue
    /bin/zsh "$RUNNER" "$conf" || failed=1
done

exit "$failed"
