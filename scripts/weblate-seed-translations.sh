#!/usr/bin/env bash
# 为 Weblate 生成译文种子文件。
#
# 用途：仓库当前没有 en / ja / zh-Hant 译文目录，组件的文件掩码匹配不到任何文件，
# 部分 Weblate 实例会拒绝创建组件。本脚本在每个一级目录下放置一个与源文同名、
# 内容为空的译文文件，使掩码至少有一个匹配项。组件创建成功、语言启动之后，
# Weblate 会按模板为其余源文件生成译文文件，种子文件即可删除。
#
# 用法：
#   ./scripts/weblate-seed-translations.sh <语言代码>
#   ./scripts/weblate-seed-translations.sh en
#
# 可用环境变量：
#   CONTENT_DIRS  一级目录清单，默认与组件脚本一致
#   SEED_COUNT    每个目录生成的种子文件数，默认 1

set -euo pipefail

LANG_CODE="${1:?需要指定语言代码，例如 en}"
CONTENT_DIRS="${CONTENT_DIRS:-AI TODOs blog books docker kubernetes lang materiel middleware network os tools}"
SEED_COUNT="${SEED_COUNT:-1}"

created=0
for dir in ${CONTENT_DIRS}; do
  # 取该目录下按字典序排列的前若干个 Markdown 源文作为种子
  mapfile -t sources < <(
    find "src/content/docs/${dir}" -name '*.md' -type f | sort | head -n "${SEED_COUNT}"
  )
  for src in "${sources[@]}"; do
    target="src/content/docs/${LANG_CODE}/${src#src/content/docs/}"
    mkdir -p "$(dirname "${target}")"
    if [ ! -e "${target}" ]; then
      : >"${target}"
      echo "已创建 ${target}"
      created=$((created + 1))
    else
      echo "已存在，跳过 ${target}"
    fi
  done
done

echo "==> 共创建 ${created} 个种子文件（语言 ${LANG_CODE}）"
echo "    提交并推送后再创建组件；组件创建完成后可删除这些空文件。"
