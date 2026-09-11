#!/usr/bin/env bash
# 通过 Weblate REST API 批量建立项目与组件，避免逐项手工配置。
#
# 前置条件：
#   - 已部署 Weblate 实例，且在「用户设置 - API 访问」中取得令牌；
#   - 仓库已授权给 Weblate（GitHub App 或部署密钥）。
#
# 用法：
#   export WEBLATE_URL=https://weblate.example.com
#   export WEBLATE_API_TOKEN=xxxx
#   ./scripts/weblate-create-components.sh
#
# 说明：组件建立后仍需在实例上确认两项设置（脚本会给出提示）：
#   1. 语言代码风格需为 BCP（连字符），否则译文会写入 zh_Hant 而非 zh-Hant 目录；
#   2. 文件格式的 front matter 字段需显式声明 title、description。

set -euo pipefail

: "${WEBLATE_URL:?需要设置 WEBLATE_URL，例如 https://weblate.example.com}"
: "${WEBLATE_API_TOKEN:?需要设置 WEBLATE_API_TOKEN}"

PROJECT_NAME="${PROJECT_NAME:-doc-record}"
PROJECT_SLUG="${PROJECT_SLUG:-doc-record}"
REPO="${REPO:-https://github.com/iuin8/doc-record.git}"
BRANCH="${BRANCH:-main}"
SOURCE_LANG="${SOURCE_LANG:-zh_Hans}"
TARGET_LANGS="${TARGET_LANGS:-en ja zh_Hant}"
CONTENT_DIRS="${CONTENT_DIRS:-AI TODOs blog books docker kubernetes lang materiel middleware network os test tools}"
SITE_URL="${SITE_URL:-https://doc-record.iuin888vip.icu}"

api() {
  curl -fsS \
    -H "Authorization: Token ${WEBLATE_API_TOKEN}" \
    -H 'Content-Type: application/json' \
    "$@"
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-|-$//g'
}

echo "==> 建立项目 ${PROJECT_SLUG}"
if api -X POST "${WEBLATE_URL}/api/projects/" -d @- <<EOF; then
{"name":"${PROJECT_NAME}","slug":"${PROJECT_SLUG}","web":"${SITE_URL}","source_language":"${WEBLATE_URL}/api/languages/${SOURCE_LANG}/"}
EOF
  echo "    项目已建立"
else
  echo "    项目建立失败：若已存在可忽略，否则请检查令牌与地址" >&2
fi

for dir in ${CONTENT_DIRS}; do
  slug="$(slugify "${dir}")"
  echo "==> 建立组件 ${slug}（源目录 ${dir}）"

  payload=$(
    cat <<EOF
{
  "name": "${dir} 文档",
  "slug": "${slug}",
  "repo": "${REPO}",
  "branch": "${BRANCH}",
  "vcs": "git",
  "file_format": "markdown",
  "template": "src/content/docs/${dir}/**/*.md",
  "filemask": "src/content/docs/*/${dir}/**/*.md",
  "language_code_style": "bcp"
}
EOF
  )

  # 部分实例的 API 不接受 language_code_style，失败时去掉该字段重试
  if ! api -X POST "${WEBLATE_URL}/api/projects/${PROJECT_SLUG}/components/" \
    -d "${payload}" >/dev/null; then
    echo "    首次创建失败，去掉 language_code_style 重试" >&2
    api -X POST "${WEBLATE_URL}/api/projects/${PROJECT_SLUG}/components/" \
      -d "$(echo "${payload}" | sed -E '/language_code_style/d; s/,\n}/}/')" >/dev/null
    echo "    请在组件设置中手动将语言代码风格调整为 BCP" >&2
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
