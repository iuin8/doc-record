# doc-record

[![zread](https://img.shields.io/badge/Ask_Zread-_.svg?style=flat&color=00b0aa&labelColor=000000&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB3aWR0aD0iMTYiIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNiAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTQuOTYxNTYgMS42MDAxSDIuMjQxNTZDMS44ODgxIDEuNjAwMSAxLjYwMTU2IDEuODg2NjQgMS42MDE1NiAyLjI0MDFWNC45NjAxQzEuNjAxNTYgNS4zMTM1NiAxLjg4ODEgNS42MDAxIDIuMjQxNTYgNS42MDAxSDQuOTYxNTZDNS4zMTUwMiA1LjYwMDEgNS42MDE1NiA1LjMxMzU2IDUuNjAxNTYgNC45NjAxVjIuMjQwMUM1LjYwMTU2IDEuODg2NjQgNS4zMTUwMiAxLjYwMDEgNC45NjE1NiAxLjYwMDFaIiBmaWxsPSIjZmZmIi8%2BCjxwYXRoIGQ9Ik00Ljk2MTU2IDEwLjM5OTlIMi4yNDE1NkMxLjg4ODEgMTAuMzk5OSAxLjYwMTU2IDEwLjY4NjQgMS42MDE1NiAxMS4wMzk5VjEzLjc1OTlDMS42MDE1NiAxNC4xMTM0IDEuODg4MSAxNC4zOTk5IDIuMjQxNTYgMTQuMzk5OUg0Ljk2MTU2QzUuMzE1MDIgMTQuMzk5OSA1LjYwMTU2IDE0LjExMzQgNS42MDE1NiAxMy43NTk5VjExLjAzOTlDNS42MDE1NiAxMC42ODY0IDUuMzE1MDIgMTAuMzk5OSA0Ljk2MTU2IDEwLjM5OTlaIiBmaWxsPSIjZmZmIi8%2BCjxwYXRoIGQ9Ik0xMy43NTg0IDEuNjAwMUgxMS4wMzg0QzEwLjY4NSAxLjYwMDEgMTAuMzk4NCAxLjg4NjY0IDEwLjM5ODQgMi4yNDAxVjQuOTYwMUMxMC4zOTg0IDUuMzEzNTYgMTAuNjg1IDUuNjAwMSAxMS4wMzg0IDUuNjAwMUgxMy43NTg0QzE0LjExMTkgNS42MDAxIDE0LjM5ODQgNS4zMTM1NiAxNC4zOTg0IDQuOTYwMVYyLjI0MDFDMTQuMzk4NCAxLjg4NjY0IDE0LjExMTkgMS42MDAxIDEzLjc1ODQgMS42MDAxWiIgZmlsbD0iI2ZmZiIvPgo8cGF0aCBkPSJNNCAxMkwxMiA0TDQgMTJaIiBmaWxsPSIjZmZmIi8%2BCjxwYXRoIGQ9Ik00IDEyTDEyIDQiIHN0cm9rZT0iI2ZmZiIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPgo8L3N2Zz4K&logoColor=ffffff)](https://zread.ai/iuin8/doc-record) [![DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/iuin8/doc-record)

> 提示：点击上方Zread徽章可跳转到本仓库的 AI 问答页（Zread），支持搜索与提问，快速获取结构化指引。
> [AI 问答入口(zread)](https://zread.ai/iuin8/doc-record)

## 介绍

记录一些文档, 关于docker, k8s, 以及一些其他工具的文档.

## Claude Code MCP

项目级 Claude Code 配置已接入 Cloudflare AI Search MCP，配置文件位于 `.claude/settings.json`。

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

用途：在 Claude Code 中把 Cloudflare AI Search 作为 MCP server 使用，直接搜索已接入该索引的内容。

相关文档：`src/content/docs/zh-cn/ai/mcp/modelcontextprotocol/servers/cloudflare-ai-search/doc.md`

## 安装

```bash
pnpm install
pnpm dev
```

- 侧边栏由 `src/content/docs/zh-cn/` 的目录结构自动推导，无需手动生成
- 目录结构、语言约定与全部命令见 `CLAUDE.md`

## 部署

推送 main 后由 `.github/workflows/ci.yml` 构建并部署到 GitHub Pages，
自定义域名 `https://doc-record.iuin888vip.icu`。

站点 URL 由内容目录推导，默认语言带 `/zh-cn/` 前缀。

## 使用到的vscode插件

- eliostruyf.vscode-front-matter-beta

## 人机协作指南

### 内容创作者（人类）

```bash
1. 在 src/content/docs/zh-cn/ 对应分类目录下编写 Markdown
2. 使用分类文件夹组织文档
3. Front Matter 保持简洁，title 未声明时由首个一级标题推导
```

### AI开发助手

```bash
1. 维护 src/content/docs/zh-cn/ 目录结构的稳定性
2. 自动优化知识呈现方式
3. 目录结构调整会改变 URL，需同步评估对已收录链接的影响
```

## 备注

- vscode搜索

```bash
# 需要排除的搜索项

# 如果只是想排除 所有以 . 开头的文件和目录，最简单的写法是：
**/.*
# 但如果某些 .xxx 文件需要保留，可以结合 ! 排除规则：
**/.*, !./.some-important-dot-file

## 写入项目的 .vscode/settings.json 文件，这样只有当前项目会应用这些排除规则，而不会影响其他项目或全局设置。
{
    "search.exclude": {
        "**/node_modules": true,
        "**/.*": true,  // 排除所有以 . 开头的文件和目录
        // 加了下面这个, temp目录下的文件还是不能被搜索到
        // "!**/temp/**": true,  // 允许搜索所有 temp 文件夹（默认允许）
    },
    "search.useIgnoreFiles": false  // 关闭忽略文件的影响
}

```

## 使用到的项目

- [Astro](https://astro.build/) — 静态站点生成
- [Starlight](https://starlight.astro.build/) — 文档主题、导航与搜索
- [starlight-blog](https://github.com/HiDeoo/starlight-blog) — 博客列表与 RSS
- [starlight-llms-txt](https://github.com/HiDeoo/starlight-llms-txt) — llms.txt 与分类分卷
- [Cloudflare AI Search](https://developers.cloudflare.com/ai-search/) — 检索增强问答，配置见 `cloudflare/README.md`

## 本地开发

依赖以 pnpm 管理（Node >= 22），`pnpm-lock.yaml` 入库存档：

```bash
pnpm install
pnpm dev            # 开发服务器
pnpm build          # 构建
pnpm check:content  # 内容门禁
pnpm test:e2e       # Playwright 端到端测试（自动构建后起 preview 服务）
```

`pnpm install` 在部分环境会被安全策略拦截，此时可用 `pnpm install --lockfile-only`
生成锁文件后用 `bun install` 装本地依赖；`bun.lock` 不入库，依赖树仍以 pnpm 锁文件为准。

## TODO

- 翻译工作流：托管 Weblate 的组件模板字段不接受 glob，暂缓实施，
  原因与恢复条件见 `adr/2026-09-10-翻译平台迁移至 Weblate.md`
