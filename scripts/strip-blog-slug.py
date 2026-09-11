#!/usr/bin/env python3
"""移除博客文章的 Docusaurus slug 字段。

starlight-blog 依据条目 ID 反查所属 blog 目录，而 slug 会覆盖 Astro 由路径生成的 ID，
导致插件无法定位配置。移除后 ID 回归路径形式。
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BLOG = ROOT / "src" / "content" / "docs" / "blog"

FM_RE = re.compile(r"^---\r?\n(.*?)\r?\n---[ \t]*\r?\n?", re.DOTALL)
SLUG_RE = re.compile(r"^slug\s*:.*\r?\n", re.MULTILINE)


def main() -> int:
    removed = 0
    for path in sorted(BLOG.rglob("*.md")):
        text = path.read_text(encoding="utf-8", errors="surrogateescape")
        match = FM_RE.match(text)
        if not match or not SLUG_RE.search(match.group(1)):
            continue
        body = SLUG_RE.sub("", match.group(1))
        path.write_text(
            f"---\n{body}---\n" + text[match.end() :],
            encoding="utf-8",
            errors="surrogateescape",
        )
        print(f"移除 slug: {path.relative_to(BLOG)}")
        removed += 1
    print(f"共移除: {removed}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
