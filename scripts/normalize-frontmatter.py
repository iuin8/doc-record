#!/usr/bin/env python3
"""规范化 src/content 下所有 Markdown 的 front matter。

处理迁移过程中产生的三类问题：
1. 文件开头存在空行导致 front matter 未被识别，被重复追加，形成双 front matter 块；
2. Docusaurus 遗留的 slug 字段（starlight-blog 依据条目 ID 反查目录，slug 会破坏该映射）；
3. 插入 title 时把闭合分隔符挤到同一行，造成 YAML 解析失败。

合并策略：保留首个块之后的重复块字段，后者覆盖前者；删除 slug；保证 title 存在。
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTENT = ROOT / "src" / "content"

KEY_RE = re.compile(r"^([A-Za-z_][\w.\-]*)\s*:(.*)$")
H1_RE = re.compile(r"^#\s+(.+?)\s*$")
DROP_KEYS = {"slug"}


def split_front_matter(lines: list[str]) -> tuple[list[list[str]], list[str]]:
    """切分文件开头连续的 front matter 块，返回 (块列表, 正文行)。"""
    i = 0
    while i < len(lines) and lines[i].strip() == "":
        i += 1

    blocks: list[list[str]] = []
    rest_start = i
    while i < len(lines) and lines[i].strip() == "---":
        j = i + 1
        while j < len(lines) and lines[j].strip() != "---":
            j += 1
        if j >= len(lines):  # 未闭合，不当作 front matter
            break
        blocks.append(lines[i + 1 : j])
        i = j + 1
        rest_start = i

        k = i
        while k < len(lines) and lines[k].strip() == "":
            k += 1
        if k < len(lines) and lines[k].strip() == "---":
            i = k
        else:
            break

    return blocks, lines[rest_start:]


def merge_blocks(blocks: list[list[str]]) -> list[tuple[str, list[str]]]:
    """按顺序合并多个 front matter 块，后者覆盖同名键，忽略 slug。"""
    merged: dict[str, list[str]] = {}
    order: list[str] = []
    for block in blocks:
        current: str | None = None
        for line in block:
            match = KEY_RE.match(line)
            if match:
                key, value = match.group(1), match.group(2)
                if key in DROP_KEYS:
                    current = None
                    continue
                if key not in merged:
                    order.append(key)
                merged[key] = [value]
                current = key
            elif current is not None:
                merged[current].append(line)
    return [(key, merged[key]) for key in order]


def has_key(fields: list[tuple[str, list[str]]], name: str) -> bool:
    return any(key == name for key, _ in fields)


def main() -> int:
    changed = 0
    total = 0
    for path in sorted(CONTENT.rglob("*.md")):
        if not path.is_file():
            continue
        total += 1
        text = path.read_text(encoding="utf-8", errors="surrogateescape")
        lines = text.replace("\r\n", "\n").split("\n")

        blocks, rest = split_front_matter(lines)
        if not blocks:
            continue

        fields = merge_blocks(blocks)
        if not has_key(fields, "title"):
            title = path.stem
            for line in rest:
                match = H1_RE.match(line)
                if match:
                    title = match.group(1).strip().rstrip("#").strip()
                    break
            title = title.replace("\\", "\\\\").replace('"', '\\"')
            fields.insert(0, ("title", [f'"{title}"']))

        body: list[str] = []
        for key, value_lines in fields:
            if not value_lines:
                body.append(f"{key}:")
                continue
            first = value_lines[0]
            if first.strip() == "":
                # 值在后续行（嵌套映射或列表），键名单独成行以保留缩进结构
                body.append(f"{key}:")
                body.extend(value_lines[1:])
            else:
                body.append(f"{key}: {first.strip()}")
                body.extend(value_lines[1:])

        new_text = "---\n" + "\n".join(body) + "\n---\n\n" + "\n".join(rest).lstrip("\n")
        new_text = new_text.rstrip("\n") + "\n"

        if new_text != text:
            path.write_text(new_text, encoding="utf-8", errors="surrogateescape")
            changed += 1

    print(f"扫描 {total} 个 Markdown，规范化 {changed} 个")
    return 0


if __name__ == "__main__":
    sys.exit(main())
