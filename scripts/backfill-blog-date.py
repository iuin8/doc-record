#!/usr/bin/env python3
"""为缺少 date 字段的博客文章按 Git 提交时间回填。

优先取文件的首次提交时间（--diff-filter=A），取不到时回退到最后一次提交时间。
"""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BLOG = ROOT / "src" / "content" / "docs" / "blog"

FM_RE = re.compile(r"^---\r?\n(.*?)\r?\n---[ \t]*\r?\n?", re.DOTALL)
DATE_RE = re.compile(r"^date\s*:", re.MULTILINE)


def commit_date(path: Path) -> str:
    rel = path.relative_to(ROOT)
    for args in (
        ["git", "log", "--follow", "--diff-filter=A", "--format=%aI", "--", str(rel)],
        ["git", "log", "--format=%aI", "--", str(rel)],
    ):
        out = subprocess.run(args, cwd=ROOT, capture_output=True, text=True).stdout.strip()
        if out:
            return out.splitlines()[-1][:10]
    return "1970-01-01"


def main() -> int:
    patched = 0
    for path in sorted(BLOG.rglob("*.md")):
        text = path.read_text(encoding="utf-8", errors="surrogateescape")
        match = FM_RE.match(text)
        if not match or DATE_RE.search(match.group(1)):
            continue
        date = commit_date(path)
        body = f"date: {date}\n{match.group(1)}"
        path.write_text(
            f"---\n{body}\n---\n" + text[match.end() :],
            encoding="utf-8",
            errors="surrogateescape",
        )
        print(f"  {date}  {path.relative_to(BLOG)}")
        patched += 1
    print(f"回填 date: {patched}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
