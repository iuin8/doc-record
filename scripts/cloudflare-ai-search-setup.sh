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
#   SITE_URL               站点根地址
#   EMBEDDING_MODEL        向量模型
#   AI_SEARCH_MODEL        生成模型

set -euo pipefail

: "${CLOUDFLARE_API_TOKEN:?需要设置 CLOUDFLARE_API_TOKEN}"

CLOUDFLARE_ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:-1e41ba8d32af254e50ca2f65292adfe1}"
INSTANCE_ID="${INSTANCE_ID:-bold-union-4896}"
SITE_URL="${SITE_URL:-https://doc-record.iuin888vip.icu}"
EMBEDDING_MODEL="${EMBEDDING_MODEL:-@cf/baai/bge-m3}"
AI_SEARCH_MODEL="${AI_SEARCH_MODEL:-@cf/qwen/qwen3-30b-a3b-fp8}"

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

# 排除项说明：
#   /raw/** 与 /_llms-txt/** 是给 AI 直接取用的纯文本副本，与页面内容重复；
#   /en /ja /zh-Hant 目前是回退内容，与根语言页面一致，索引会成倍放大重复度。
body=$(
  cat <<EOF
{
  "id": "${INSTANCE_ID}",
  "type": "web-crawler",
  "source_params": {
    "web_crawler": {
      "parse_type": "sitemap",
      "parse_options": {
        "specific_sitemaps": ["${SITE_URL}/sitemap-index.xml"]
      },
      "discover_options": {
        "source": "sitemaps",
        "depth": 3,
        "limit": 2000,
        "include_external_links": false,
        "include_subdomains": false
      }
    },
    "exclude_items": ["/raw/**", "/_llms-txt/**", "/en/**", "/ja/**", "/zh-Hant/**"]
  },
  "embedding_model": "${EMBEDDING_MODEL}",
  "ai_search_model": "${AI_SEARCH_MODEL}",
  "chunk": true,
  "chunk_size": 1200,
  "chunk_overlap": 100,
  "index_method": { "keyword": true, "vector": true },
  "max_num_results": 8,
  "reranking": true,
  "rewrite_query": true,
  "sync_interval": 3600
}
EOF
)

echo "==> 写入配置"
if [ "$method" = "PUT" ]; then
  api -X PUT "$url" -d "$body" >/dev/null
else
  api -X POST "$url" -d "$body" >/dev/null
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
