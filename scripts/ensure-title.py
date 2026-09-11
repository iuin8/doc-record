#!/usr/bin/env python3
"""确保 src/content 下所有 Markdown 的 front matter 都带 title。

覆盖两种情况：
1. 完全没有 front matter —— 追加一段；
2. 已有 front matter 但缺 title —— 在 front matter 首行插入 title。
title 取自首个 H1，无 H1 时回退为文件名。
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTENT = ROOT / "src" / "content"

H1_RE = re.compile(r"^#\s+(.+?)\s*$", re.MULTILINE)
FM_RE = re.compile(r"^---\r?\n(.*?)\r?\n---[ \t]*\r?\n?", re.DOTALL)
TITLE_KEY_RE = re.compile(r"^title\s*:", re.MULTILINE)


def normalize(raw: str) -> str:
    title = raw.strip().rstrip("#").strip()
    return title.replace("\\", "\\\\").replace('"', '\\"')


def ensure_title(path: Path) -> bool:
    text = path.read_text(encoding="utf-8", errors="surrogateescape")
    match = H1_RE.search(text)
    fallback = path.stem
    title = normalize(match.group(1)) if match else fallback

    fm = FM_RE.match(text)
    if fm:
        body = fm.group(1)
        if TITLE_KEY_RE.search(body):
            return False
        new_body = f'title: "{title}"\n{body}'
        patched = f"---\n{new_body}\n---\n" + text[fm.end() :]
    else:
        patched = f'---\ntitle: "{title}"\n---\n\n{text}'

    path.write_text(patched, encoding="utf-8", errors="surrogateescape")
    return True


def main() -> int:
    patched = 0
    total = 0
    for path in sorted(CONTENT.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in {".md", ".mdx"}:
            continue
        total += 1
        if ensure_title(path):
            patched += 1
    print(f"扫描 {total} 个 Markdown，补齐/修正 title: {patched}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
