#!/usr/bin/env bash
# 配置 Cloudflare AI Search（原 AutoRAG）实例，为站点提供检索增强问答。
#
# 前置条件：
#   - API 令牌需具备 Account > AI Search:Edit 与 AI Search:Run 两项权限；
#   - 站点已发布且 sitemap 可访问。
#
# 用法：
#   export CLOUDFLARE_API_TOKEN=xxxx
#   ./scripts/cloudflare-ai-search-setup.sh
#
# 可用环境变量覆盖默认值：
#   CLOUDFLARE_ACCOUNT_ID  账户 ID
#   INSTANCE_ID            实例名，需与 NLWeb Worker 的 RAG_ID 绑定一致
#   SITEMAP_PATH           站点地图路径，默认 sitemap-ai.xml
#   RECREATE               设为 true 时先删除实例再重建，默认 false
#   RERANKING              是否启用重排，默认 false（免费额度下减少模型调用）
#   REWRITE_QUERY          是否启用查询改写，默认 false（同上）
#   EMBEDDING_MODEL        向量模型
#   AI_SEARCH_MODEL        生成模型
#
# RECREATE 的适用场景：已入队 URL 列表不会随 `specific_sitemaps` 变更而重置，
# 站点 URL 结构整体调整后，失效条目会继续占据检索名额，需删除实例后重建。
# 更新配置（默认行为）适用于模型、分块、排除项等不影响 URL 集合的调整。

set -euo pipefail

: "${CLOUDFLARE_API_TOKEN:?需要设置 CLOUDFLARE_API_TOKEN}"

CLOUDFLARE_ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:-1e41ba8d32af254e50ca2f65292adfe1}"
INSTANCE_ID="${INSTANCE_ID:-bold-union-4896}"
SITE_URL="${SITE_URL:-https://doc-record.iuin888vip.icu}"
# sitemap-ai.xml 由 src/pages/sitemap-ai.xml.ts 生成，仅含根语言页面，
# 不含 /en /ja /zh-Hant 回退副本，避免索引内容成倍重复。
SITEMAP_PATH="${SITEMAP_PATH:-sitemap-ai.xml}"
EMBEDDING_MODEL="${EMBEDDING_MODEL:-@cf/qwen/qwen3-embedding-0.6b}"
AI_SEARCH_MODEL="${AI_SEARCH_MODEL:-@cf/qwen/qwen3-30b-a3b-fp8}"
RERANKING="${RERANKING:-false}"
REWRITE_QUERY="${REWRITE_QUERY:-false}"

BASE="https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT_ID}/ai-search"
AUTH="Authorization: Bearer ${CLOUDFLARE_API_TOKEN}"

api() {
  curl -fsS -H "$AUTH" -H 'Content-Type: application/json' "$@"
}

json_field() {
  python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(1)
cursor = data
for key in '$1'.split('.'):
    if isinstance(cursor, dict):
        cursor = cursor.get(key)
    elif isinstance(cursor, list) and key.isdigit():
        cursor = cursor[int(key)]
    else:
        cursor = None
    if cursor is None:
        break
print(cursor if cursor is not None else '')
"
}

echo "==> 查询实例 ${INSTANCE_ID}"
existing="$(api "${BASE}/instances/${INSTANCE_ID}" 2>/dev/null || echo '')"
if [ -n "$existing" ]; then
  echo "    实例已存在，转为更新配置"
  method=PUT
  url="${BASE}/instances/${INSTANCE_ID}"
else
  echo "    实例不存在，将创建"
  method=POST
  url="${BASE}/instances"
fi

if [ "${RECREATE:-false}" = "true" ] && [ -n "$existing" ]; then
  echo "==> RECREATE=true，删除实例 ${INSTANCE_ID}（含已入队 URL 与向量索引）"
  if api -X DELETE "${BASE}/instances/${INSTANCE_ID}" >/dev/null 2>&1; then
    echo "    已提交删除，等待实例状态收敛后再创建"
    deleted=false
    for attempt in $(seq 1 30); do
      sleep 10
      if ! api "${BASE}/instances/${INSTANCE_ID}" >/dev/null 2>&1; then
        echo "    实例已消失（第 ${attempt} 次检查）"
        deleted=true
        break
      fi
    done
    if [ "$deleted" != "true" ]; then
      echo "    删除后实例仍可查询，可能为接口延迟；继续尝试创建" >&2
    fi
    method=POST
    url="${BASE}/instances"
  else
    echo "    删除失败，请确认令牌具备 AI Search:Edit 权限" >&2
    exit 1
  fi
fi

# 排除项说明：
#   /raw/** 与 /_llms-txt/** 是给 AI 直接取用的纯文本副本，与页面内容重复。
#   站点当前只声明存在译文的语言，未声明的语言不会生成回退副本，无需在此排除。
#   后续新增语言且译文不全时，需在此补上对应前缀的排除项。
body=$(
  cat <<EOF
{
  "id": "${INSTANCE_ID}",
  "type": "web-crawler",
  "source_params": {
    "web_crawler": {
      "parse_type": "sitemap",
      "parse_options": {
        "specific_sitemaps": ["${SITE_URL}/${SITEMAP_PATH}"]
      },
      "discover_options": {
        "source": "sitemaps",
        "depth": 1,
        "limit": 100000,
        "include_external_links": false,
        "include_subdomains": false
      }
    },
    "exclude_items": ["/raw/**", "/_llms-txt/**"]
  },
  "embedding_model": "${EMBEDDING_MODEL}",
  "ai_search_model": "${AI_SEARCH_MODEL}",
  "chunk": true,
  "chunk_size": 1024,
  "chunk_overlap": 10,
  "index_method": { "keyword": true, "vector": true },
  "max_num_results": 10,
  "reranking": ${RERANKING},
  "rewrite_query": ${REWRITE_QUERY},
  "sync_interval": 21600
}
EOF
)

echo "==> 写入配置（${method} ${url}）"
# 失败时输出接口返回体：AI Search 的错误细节只在响应里给出，
# 丢弃后只能看到 curl 的退出码，无法定位是字段名还是取值的问题。
if ! response="$(api -X "$method" "$url" -d "$body" 2>&1)"; then
  echo "    写入失败，接口返回：" >&2
  echo "$response" >&2
  exit 1
fi

echo "==> 触发同步任务"
job="$(api -X POST "${BASE}/instances/${INSTANCE_ID}/jobs" 2>/dev/null || echo '')"
job_id="$(echo "$job" | json_field result.id)"
echo "    任务 ID：${job_id:-（未返回，可在控制台查看）}"

echo "==> 等待索引完成"
for attempt in $(seq 1 30); do
  sleep 20
  status="$(api "${BASE}/instances/${INSTANCE_ID}/jobs" 2>/dev/null |
    python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    jobs = data.get('result') or []
    print(jobs[0].get('status', 'unknown') if jobs else 'unknown')
except Exception:
    print('unknown')
")"
  echo "    [${attempt}] 状态：${status}"
  case "$status" in
    completed | success) echo "    索引完成"; break ;;
    failed | error) echo "    索引失败，请在控制台查看任务日志" >&2; exit 1 ;;
  esac
done

echo "==> 索引统计"
api "${BASE}/instances/${INSTANCE_ID}/stats" 2>/dev/null | head -c 400 || true
echo
echo "==> 完成。可用以下地址验证问答："
echo "    https://${INSTANCE_ID}-nlweb.iuinin666.workers.dev/"
