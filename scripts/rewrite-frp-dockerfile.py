#!/usr/bin/env python3
"""将 frp Dockerfile 中的本地 COPY 改为官方 URL 下载。预演模式：--dry-run"""
import sys
from pathlib import Path

FRP_URL = "https://github.com/fatedier/frp/releases/download/v0.62.1/frp_0.62.1_linux_amd64.tar.gz"

NEW_BLOCK = (
    "RUN wget -O ./frp_0.62.1_linux_amd64.tar.gz " + FRP_URL + " && \\\n"
    "    tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && \\\n"
    "    mv frp_0.62.1_linux_amd64 frp && \\\n"
    "    rm -rf ./frp_0.62.1_linux_amd64.tar.gz"
)

COPY_LINE = "COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz"

# 各模式：COPY 行 + 紧随的 RUN 块（按续行聚合）
PATTERNS = [
    [
        "COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz",
        "RUN tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && rm -rf ./frp_0.62.1_linux_amd64.tar.gz && \\",
        "    mv frp_0.62.1_linux_amd64 frp",
    ],
    [
        "COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz",
        "RUN tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && \\",
        "    mv frp_0.62.1_linux_amd64 frp",
    ],
    [
        "COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz",
        "RUN tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && \\",
        "    mv frp_0.62.1_linux_amd64 frp && \\",
        "    rm -rf ./frp_0.62.1_linux_amd64.tar.gz",
    ],
]


def strip_leading_comment_block(lines, idx):
    """删除位于 idx 之前、紧邻的 frp 相关注释块，返回 (新行列表, 新 idx)"""
    start = idx
    while start > 0 and lines[start - 1].lstrip().startswith("#"):
        if "frp" in lines[start - 1].lower() or lines[start - 1].rstrip().endswith("\\"):
            start -= 1
        else:
            break
    removed = lines[start:idx]
    # 仅当移除内容确实与 frp 相关时才移除
    if any("frp" in l.lower() for l in removed):
        del lines[start:idx]
        return lines, start
    return lines, idx


def process(path: Path, dry_run: bool):
    text = path.read_text(encoding="utf-8")
    lines = text.split("\n")
    changed = False

    for pattern in PATTERNS:
        plen = len(pattern)
        i = 0
        while i + plen <= len(lines):
            if [l.rstrip() for l in lines[i:i + plen]] == pattern:
                lines, i = strip_leading_comment_block(lines, i)
                lines[i:i + plen] = NEW_BLOCK.split("\n")
                changed = True
                i += len(NEW_BLOCK.split("\n"))
            else:
                i += 1
        if changed:
            break

    if COPY_LINE in [l.rstrip() for l in lines]:
        print(f"  [未处理·残留 COPY] {path}")
        return False

    if changed:
        if not dry_run:
            path.write_text("\n".join(lines), encoding="utf-8")
        print(f"  [已改写] {path}")
    else:
        print(f"  [无匹配] {path}")
    return changed


def main():
    dry_run = "--dry-run" in sys.argv
    root = Path(__file__).resolve().parents[1]
    targets = sorted(
        p for p in (root / "docs").rglob("Dockerfile")
        if p.is_file()
        and COPY_LINE in [l.rstrip() for l in p.read_text(encoding="utf-8", errors="ignore").split("\n")]
    )
    print(f"{'预演' if dry_run else '执行'}：命中 {len(targets)} 个 Dockerfile\n")
    ok = 0
    for t in targets:
        if process(t, dry_run):
            ok += 1
    print(f"\n成功 {ok} / {len(targets)}")


if __name__ == "__main__":
    main()
