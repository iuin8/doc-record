#!/usr/bin/env bash
# 通过 Weblate REST API 批量建立项目与组件，避免逐项手工配置。
#
# 自建实例与 Hosted Weblate 通用，区别仅在 WEBLATE_URL 与项目创建方式：
#   - 自建：WEBLATE_URL 指向自己的域名，脚本可一并创建项目；
#   - 托管：WEBLATE_URL 为 https://hosted.weblate.org，建议在网页端先建好项目
#          并完成 GitHub 授权，再用 CREATE_PROJECT=false 只建组件。
#
# 前置条件：
#   - 在「用户设置 - API 访问」中取得令牌；
#   - 仓库已授权给 Weblate（GitHub App 或部署密钥）。
#
# 用法：
#   export WEBLATE_API_TOKEN=xxxx
#   export WEBLATE_URL=https://hosted.weblate.org
#   ./scripts/weblate-create-components.sh
#
# 可用环境变量覆盖默认值：
#   WEBLATE_URL          实例地址，默认 https://hosted.weblate.org
#   WEBLATE_API_TOKEN    API 令牌
#   CREATE_PROJECT       是否创建项目，默认 true；托管场景可设为 false
#   PROJECT_SLUG         项目标识，默认 doc-record
#   REPO / BRANCH        仓库地址与分支
#   SOURCE_LANG          源语言，默认 zh_Hans
#   TARGET_LANGS         目标语言，默认 en ja zh_Hant
#   CONTENT_DIRS         需要建组件的一级目录
#   FILE_FORMAT          文件格式，默认 markdown（仓库当前无 .mdx 文件）
#
# 说明：组件建立后仍需在实例上确认两项设置（脚本会给出提示）：
#   1. 语言代码风格需为 BCP（连字符），否则译文会写入 zh_Hant 而非 zh-Hant 目录；
#   2. 文件格式的 front matter 字段需显式声明 title、description。

set -euo pipefail

: "${WEBLATE_API_TOKEN:?需要设置 WEBLATE_API_TOKEN}"

WEBLATE_URL="${WEBLATE_URL:-https://hosted.weblate.org}"
CREATE_PROJECT="${CREATE_PROJECT:-true}"
PROJECT_NAME="${PROJECT_NAME:-doc-record}"
PROJECT_SLUG="${PROJECT_SLUG:-doc-record}"
REPO="${REPO:-https://github.com/iuin8/doc-record.git}"
BRANCH="${BRANCH:-main}"
SOURCE_LANG="${SOURCE_LANG:-zh_Hans}"
TARGET_LANGS="${TARGET_LANGS:-en ja zh_Hant}"
CONTENT_DIRS="${CONTENT_DIRS:-AI TODOs blog books docker kubernetes lang materiel middleware network os test tools}"
SITE_URL="${SITE_URL:-https://doc-record.iuin888vip.icu}"
FILE_FORMAT="${FILE_FORMAT:-markdown}"

api() {
  curl -fsS \
    -H "Authorization: Token ${WEBLATE_API_TOKEN}" \
    -H 'Content-Type: application/json' \
    "$@"
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-|-$//g'
}

# with_style 为 yes 时附上 language_code_style；部分实例不接受该字段，失败后重试时去掉
component_payload() {
  local dir="$1" slug="$2" with_style="$3"
  local style_line=""
  if [ "${with_style}" = "yes" ]; then
    style_line=',
  "language_code_style": "bcp"'
  fi
  printf '{
  "name": "%s 文档",
  "slug": "%s",
  "repo": "%s",
  "branch": "%s",
  "vcs": "git",
  "file_format": "%s",
  "template": "src/content/docs/%s/**/*.md",
  "new_base": "src/content/docs/%s/**/*.md",
  "filemask": "src/content/docs/*/%s/**/*.md",
  "file_format_params": { "markdown_merge_duplicates": true }%s
}' "$dir" "$slug" "$REPO" "$BRANCH" "$FILE_FORMAT" "$dir" "$dir" "$dir" "$style_line"
}

echo "==> 实例地址：${WEBLATE_URL}"

if api "${WEBLATE_URL}/api/projects/${PROJECT_SLUG}/" >/dev/null 2>&1; then
  echo "==> 项目 ${PROJECT_SLUG} 已存在，跳过创建"
elif [ "${CREATE_PROJECT}" = "true" ]; then
  echo "==> 建立项目 ${PROJECT_SLUG}"
  if api -X POST "${WEBLATE_URL}/api/projects/" -d @- <<EOF >/dev/null; then
{"name":"${PROJECT_NAME}","slug":"${PROJECT_SLUG}","web":"${SITE_URL}","source_language":"${WEBLATE_URL}/api/languages/${SOURCE_LANG}/"}
EOF
    echo "    项目已建立"
  else
    echo "==> 项目建立失败。托管实例建议在网页端先创建项目并完成 GitHub 授权，" >&2
    echo "    然后以 CREATE_PROJECT=false 重新执行本脚本" >&2
    exit 1
  fi
else
  echo "==> 项目 ${PROJECT_SLUG} 不存在，且 CREATE_PROJECT=false，终止" >&2
  echo "    请先在网页端创建项目，或设置 CREATE_PROJECT=true" >&2
  exit 1
fi

for dir in ${CONTENT_DIRS}; do
  slug="$(slugify "${dir}")"
  echo "==> 建立组件 ${slug}（源目录 ${dir}）"

  if api -X POST "${WEBLATE_URL}/api/projects/${PROJECT_SLUG}/components/" \
    -d "$(component_payload "${dir}" "${slug}" yes)" >/dev/null 2>&1; then
    echo "    组件已建立（语言代码风格 BCP）"
  elif api -X POST "${WEBLATE_URL}/api/projects/${PROJECT_SLUG}/components/" \
    -d "$(component_payload "${dir}" "${slug}" no)" >/dev/null 2>&1; then
    echo "    组件已建立，但实例不接受 language_code_style 字段" >&2
    echo "    请在组件设置中手动将语言代码风格调整为 BCP（连字符）" >&2
  else
    echo "    组件建立失败：若已存在可忽略，否则请检查令牌、仓库授权与目录是否存在" >&2
    continue
  fi

  for lang in ${TARGET_LANGS}; do
    if api -X POST "${WEBLATE_URL}/api/components/${PROJECT_SLUG}/${slug}/translations/" \
      -d "{\"language_code\":\"${lang}\"}" >/dev/null 2>&1; then
      echo "    已添加语言 ${lang}"
    else
      echo "    语言 ${lang} 未自动添加，需在界面中启动该语言的翻译" >&2
    fi
  done
done

echo "==> 完成。请复核：语言代码风格、front matter 翻译字段、自动建议与质量检查插件。"
