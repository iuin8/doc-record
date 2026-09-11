# Cloudflare AI Search MCP 使用记录

[官方文档](https://developers.cloudflare.com/ai-search/api/search/mcp/)

## 项目级配置

当前项目已在 `.claude/settings.json` 中接入 Cloudflare AI Search MCP：

```json
{
  "mcpServers": {
    "cloudflare-ai-search": {
      "type": "http",
      "url": "https://b9b71958-6156-440e-a28f-b4105ff6a50c.search.ai.cloudflare.com/mcp"
    }
  }
}
```

## 用途

把 Cloudflare AI Search 作为 Claude Code 的 MCP server 使用，让 Claude 可以直接通过 MCP 调用远端搜索能力。

当前 endpoint：

```text
https://b9b71958-6156-440e-a28f-b4105ff6a50c.search.ai.cloudflare.com/mcp
```

## 前提

1. 先在 Cloudflare 中创建 AI Search 实例
2. 给实例导入或同步需要搜索的内容
3. 在实例设置中开启 Public Endpoint
4. 拿到实例对应的 MCP endpoint

## 调用方式

该 endpoint 暴露 MCP tool，核心是 `search`。

JSON-RPC 调用示例：

```bash
curl https://b9b71958-6156-440e-a28f-b4105ff6a50c.search.ai.cloudflare.com/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "search",
      "arguments": {
        "query": "How do I configure AI Search?"
      }
    }
  }'
```

## 在 Claude Code 中使用

项目打开后，Claude Code 会读取项目级 `.claude/settings.json`，把 `cloudflare-ai-search` 注册为 MCP server。

后续可以直接让 Claude：

- 搜索 Cloudflare AI Search 索引内容
- 用 MCP tool 查询指定主题
- 结合本地仓库内容一起回答问题

## 备注

- 当前文档页记录的是项目内固定接入的 endpoint
- 如果后续更换 Cloudflare AI Search 实例，只需要同步更新 `.claude/settings.json`
- 如果该索引内容是公开可访问内容，启用 Public Endpoint 会更方便；如果内容涉及私有数据，要先确认暴露范围
