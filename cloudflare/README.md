# Cloudflare 配置

本文档记录站点在 Cloudflare 上的既有资源与配置步骤。

## 1. 既有资源

| 项目 | 值 |
| --- | --- |
| 账户 ID | `1e41ba8d32af254e50ca2f65292adfe1` |
| Workers 子域 | `iuinin666` |
| DNS 区域 | `iuin888vip.icu`（站点域名的上级域，已托管在 Cloudflare） |
| NLWeb Worker | `bold-union-4896-nlweb`，对外地址 `https://bold-union-4896-nlweb.iuinin666.workers.dev/` |
| AI Search 实例 | `bold-union-4896`（由 NLWeb 的 `RAG_ID` 绑定决定，改名需同步改绑定） |

NLWeb 自带聊天界面、`/ask` 接口与 MCP 支持，实例已在线但**索引为空**，
需要先为 AI Search 实例配置内容源并触发同步。

## 2. 创建 API 令牌

AI Search 的接口要求令牌具备 **AI Search:Edit** 与 **AI Search:Run** 两项权限，
通用令牌默认不包含。

1. 进入 <https://dash.cloudflare.com/profile/api-tokens>；
2. 选择 **Create Token** → **Create Custom Token**；
3. Permissions 中添加两项：
   - Account > **AI Search** > Edit
   - Account > **AI Search** > Run
4. 其余权限保持默认（不需要 Zone 权限即可完成索引配置）；
5. 创建后复制令牌值。

令牌只在执行脚本时通过环境变量传入，不要写入仓库。

## 3. 配置 AI Search 索引

```bash
export CLOUDFLARE_API_TOKEN=xxxx
./scripts/cloudflare-ai-search-setup.sh
```

脚本完成三件事：写入实例配置、触发同步任务、轮询任务状态直到完成。

配置项说明：

| 配置 | 取值 | 原因 |
| --- | --- | --- |
| 数据源类型 | `web-crawler` | 站点为静态站，无对象存储清单可用 |
| URL 发现 | `parse_type: sitemap` + `sitemap-index.xml` | 站点已在构建期产出 sitemap |
| 向量模型 | `@cf/baai/bge-m3` | 支持中文的多语言模型 |
| 生成模型 | `@cf/qwen/qwen3-30b-a3b-fp8` | 中文表现较好，可用环境变量覆盖 |
| 索引方式 | 关键词 + 向量双路 | 混合检索对技术文档中的命令与配置名更友好 |
| 同步间隔 | 3600 秒 | 与 GitHub Pages 的发布节奏匹配 |

排除项：

- `/raw/**`、`/_llms-txt/**`：面向 AI 的纯文本副本，与页面内容重复；
- `/en/**`、`/ja/**`、`/zh-Hant/**`：译文尚未产生，这些路径当前是回退内容，
  与根语言页面完全一致。译文上线后需要从排除项中移除。

## 4. 额度说明

Workers AI 的免费额度为每日 10,000 neurons，直接调用推理接口会在用尽后返回
`code 4006`。AI Search 的爬取与问答同样依赖 Workers AI，因此：

- 索引 370 篇文档与日常问答大概率需要 **Workers Paid** 计划（每月 5 美元起）；
- 未升级时，同步任务与问答可能失败或返回空结果，这属于额度问题而非配置错误。

## 5. 站点接入

索引验证通过后，在页面 AI 操作区增加一个「AI 问答」入口，
跳转到 NLWeb 聊天界面并预填当前页地址作为上下文。
该入口沿用现有 i18n 文案机制，需同步补充四种语言的文案。

## 6. Weblate 与 Cloudflare 的分工

Weblate 是重状态应用，需要持久文件系统、PostgreSQL、Valkey 与常驻任务队列，
**不适合部署在 Cloudflare**（Containers 的磁盘全部为临时盘，且无持久卷与 shell）。

Cloudflare 在这个方案里承担的是外围能力：

- **Cloudflare Tunnel**：发布自建 Weblate，无需开放任何入站端口，可叠加 Zero Trust 访问控制；
- **R2**：存放 `DATA_DIR` 与数据库备份，可配置生命周期规则；
- **DNS**：域名已托管在 Cloudflare，解析直接可用。

具体部署步骤见 `weblate/README.md`。
