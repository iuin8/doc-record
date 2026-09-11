#!/usr/bin/env python3
"""移除框架特有的 front matter 字段，并剥离冗余的 title。

处理两类内容：
1. Docusaurus 特有字段（sidebar_position、sidebar_label、id、custom_edit_url、
   slug、draft）——在 Starlight 中无效，且会束缚多端渲染规则，统一移除；
2. 仅含 title 且该 title 与正文首个一级标题（或文件名）一致的 front matter
   ——属于构建期可推导的冗余信息，移除后 Markdown 回归原生态。
   若 title 与一级标题不一致，视为作者的有意覆盖，予以保留。
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTENT = ROOT / "src" / "content"

FM_RE = re.compile(r"^---\r?\n(.*?)\r?\n---[ \t]*\r?\n?", re.DOTALL)
KEY_RE = re.compile(r"^([A-Za-z_][\w.\-]*)\s*:(.*)$")
FIRST_H1 = re.compile(r"^#[ \t]+(.+?)[ \t]*$", re.MULTILINE)
DROP_KEYS = {
    "sidebar_position",
    "sidebar_label",
    "id",
    "custom_edit_url",
    "slug",
    "draft",
}


def strip_inline_markdown(value: str) -> str:
    value = re.sub(r"`([^`]*)`", r"\1", value)
    value = re.sub(r"\*\*([^*]*)\*\*", r"\1", value)
    value = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", value)
    return value.strip()


def derived_title(path: Path, body: str) -> str:
    match = FIRST_H1.search(body)
    if match:
        return strip_inline_markdown(match.group(1))
    return path.stem


def normalize(value: str) -> str:
    return re.sub(r"\s+", "", value).strip('"').strip("'").lower()


def process(path: Path) -> bool:
    text = path.read_text(encoding="utf-8", errors="surrogateescape")
    match = FM_RE.match(text)
    if not match:
        return False

    body_lines = match.group(1).split("\n")
    kept: list[str] = []
    title: str | None = None
    current_key: str | None = None

    for line in body_lines:
        key_match = KEY_RE.match(line)
        if key_match:
            current_key = key_match.group(1)
            if current_key in DROP_KEYS:
                continue
            if current_key == "title":
                title = strip_inline_markdown(key_match.group(2))
            kept.append(line)
        elif current_key in DROP_KEYS:
            continue
        else:
            kept.append(line)

    rest = text[match.end() :]
    remaining_keys = {KEY_RE.match(l).group(1) for l in kept if KEY_RE.match(l)}

    # 仅剩 title 且与正文推导结果一致时，整块移除
    if remaining_keys == {"title"} and title is not None:
        if normalize(title) == normalize(derived_title(path, rest)):
            new_text = rest.lstrip("\n")
            if new_text != text:
                path.write_text(new_text, encoding="utf-8", errors="surrogateescape")
                return True
            return False

    new_body = "\n".join(kept).strip("\n")
    new_text = f"---\n{new_body}\n---\n\n{rest.lstrip(chr(10))}" if new_body else rest.lstrip("\n")
    if new_text != text:
        path.write_text(new_text, encoding="utf-8", errors="surrogateescape")
        return True
    return False


def main() -> int:
    changed = 0
    for path in sorted(CONTENT.rglob("*.md")):
        if path.is_file() and process(path):
            changed += 1
    print(f"清理 front matter: {changed}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
