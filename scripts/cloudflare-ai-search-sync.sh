#!/usr/bin/env bash
# 触发 Cloudflare AI Search 同步任务，并输出索引统计。
#
# 与 cloudflare-ai-search-setup.sh 的区别：本脚本只触发同步与查询统计，
# 不修改实例配置，可安全地在 CI 中按计划重复执行。
#
# 前置条件：
#   - API 令牌需具备 Account > AI Search:Edit 与 AI Search:Run 两项权限；
#   - 令牌通过 CLOUDFLARE_API_TOKEN 环境变量传入，不写入仓库。
#
# 用法：
#   export CLOUDFLARE_API_TOKEN=xxxx
#   ./scripts/cloudflare-ai-search-sync.sh

set -euo pipefail

: "${CLOUDFLARE_API_TOKEN:?需要设置 CLOUDFLARE_API_TOKEN}"

CLOUDFLARE_ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:-1e41ba8d32af254e50ca2f65292adfe1}"
INSTANCE_ID="${INSTANCE_ID:-bold-union-4896}"

BASE="https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT_ID}/ai-search/instances/${INSTANCE_ID}"
AUTH="Authorization: Bearer ${CLOUDFLARE_API_TOKEN}"

echo "==> 触发同步任务"
job_id="$(
  curl -fsS -X POST "${BASE}/jobs" -H "$AUTH" -H 'Content-Type: application/json' |
    python3 -c 'import sys, json; print(json.load(sys.stdin)["result"]["id"])' 2>/dev/null || echo ''
)"
echo "    任务 ID：${job_id:-（未返回）}"

echo "==> 索引统计"
curl -fsS "${BASE}/stats" -H "$AUTH" |
  python3 -c '
import sys, json

data = json.load(sys.stdin)["result"]
engine = data.get("engine") or {}
print("    队列:   ", data.get("queued"))
print("    进行中: ", data.get("running"))
print("    完成:   ", data.get("completed"))
print("    失败:   ", data.get("error"), data.get("file_embed_errors") or "")
print("    向量数: ", (engine.get("vectorize") or {}).get("vectorsCount"))
'

echo "==> 完成。问答入口：https://${INSTANCE_ID}-nlweb.iuinin666.workers.dev/"
