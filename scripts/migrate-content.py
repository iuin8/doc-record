#!/usr/bin/env python3
"""Docusaurus -> Astro Starlight 内容迁移。

将 docs/ 与 blog/ 下的 Markdown 及同目录图片资源迁移到 Starlight 的内容集合目录，
并为缺失 front matter 的文件补齐 title（取自首个 H1，回退为文件名）。
"""

from __future__ import annotations

import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DOCS_SRC = ROOT / "docs"
BLOG_SRC = ROOT / "blog"
DOCS_DST = ROOT / "src" / "content" / "docs"
BLOG_DST = ROOT / "src" / "content" / "blog"

H1_RE = re.compile(r"^#\s+(.+?)\s*$", re.MULTILINE)
FM_RE = re.compile(r"^---\r?\n(.*?)\r?\n---\r?\n?", re.DOTALL)


def git(*args: str) -> None:
    subprocess.run(["git", *args], cwd=ROOT, check=True, capture_output=True)


def tracked_files(base: Path) -> list[Path]:
    """返回 base 下所有受版本控制的文件（NUL 安全，兼容含空格与中文的路径）。"""
    out = subprocess.run(
        ["git", "ls-files", "-z", str(base.relative_to(ROOT))],
        cwd=ROOT,
        check=True,
        capture_output=True,
    ).stdout
    return [ROOT / p for p in out.decode("utf-8").split("\0") if p]


def move_tree(src_base: Path, dst_base: Path, index_name: str | None) -> int:
    dst_base.mkdir(parents=True, exist_ok=True)
    moved = 0
    for src in tracked_files(src_base):
        rel = src.relative_to(src_base)
        if index_name and rel.name == "README.md" and rel.parent == Path("."):
            rel = Path("index.md")
        dst = dst_base / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        git("mv", str(src.relative_to(ROOT)), str(dst.relative_to(ROOT)))
        moved += 1
    return moved


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="surrogateescape")


def write_text(path: Path, text: str) -> None:
    path.write_text(text, encoding="utf-8", errors="surrogateescape")


def normalize_title(raw: str) -> str:
    title = raw.strip().rstrip("#").strip()
    title = title.replace('"', '\\"')
    return title


def ensure_front_matter(path: Path) -> bool:
    """为缺少 front matter 的 Markdown 文件补 title。返回是否发生修改。"""
    if path.suffix.lower() != ".md":
        return False
    text = read_text(path)
    if FM_RE.match(text):
        return False

    match = H1_RE.search(text)
    if match:
        title = normalize_title(match.group(1))
    else:
        title = path.stem

    write_text(path, f'---\ntitle: "{title}"\n---\n\n{text}')
    return True


def main() -> int:
    docs_count = move_tree(DOCS_SRC, DOCS_DST, index_name="README.md")
    blog_count = move_tree(BLOG_SRC, BLOG_DST, index_name=None)
    print(f"已移动 docs: {docs_count}，blog: {blog_count}")

    patched = 0
    for base in (DOCS_DST, BLOG_DST):
        for path in sorted(base.rglob("*.md")):
            if ensure_front_matter(path):
                patched += 1
    print(f"已补齐 front matter: {patched}")

    for leftover in (DOCS_SRC, BLOG_SRC):
        if leftover.exists():
            shutil.rmtree(leftover)
            print(f"已移除空目录 {leftover.relative_to(ROOT)}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
