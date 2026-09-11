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
| URL 发现 | `parse_type: sitemap` + `sitemap-ai.xml` | 仅含根语言页面，避免回退副本成倍重复 |
| 向量模型 | `@cf/qwen/qwen3-embedding-0.6b` | 轻量多语言模型，索引成本低 |
| 生成模型 | `@cf/qwen/qwen3-30b-a3b-fp8` | 中文表现较好，可用环境变量覆盖 |
| 索引方式 | 关键词 + 向量双路 | 混合检索对技术文档中的命令与配置名更友好 |
| 分块 | 1024 字符，重叠 10 | 接口限制 `chunk_overlap ≤ 30` |
| 同步间隔 | 21600 秒 | 与 GitHub Pages 的发布节奏匹配 |

排除项：

- `/raw/**`、`/_llms-txt/**`：面向 AI 的纯文本副本，与页面内容重复；
- `/en/**`、`/ja/**`、`/zh-Hant/**`：译文尚未产生，这些路径当前是回退内容，
  与根语言页面完全一致。译文上线后需要从排除项中移除。
  排除项对已入队的 URL 不生效，主要去重手段是 `sitemap-ai.xml`。

### 3.1 为什么需要独立的站点地图

`sitemap-index.xml` 指向的 `sitemap-0.xml` 含 1492 条 URL，其中约四分之三是
`/en`、`/ja`、`/zh-Hant` 前缀的回退副本，正文与根语言页面完全一致。全量索引会带来
两个问题：向量写入量放大约四倍，且 `max_num_results` 的返回名额被近义重复块占满，
实际可提供的独立来源显著减少。

`src/pages/sitemap-ai.xml.ts` 只收集根语言条目，构建产物为 367 条 URL。

### 3.2 更换内容源需要重建实例

修改 `specific_sitemaps` 不会重置已经入队的 URL 列表，正在进行的同步任务会继续
消费旧队列。切换到新站点地图的可靠做法是删除实例后按新配置重新创建。

## 4. 额度说明

Workers AI 的免费额度为每日 **10,000 Neurons**，每日 **00:00 UTC** 重置。
Workers Paid 计划同样只含这 10,000 Neurons，超出部分按 $0.011 / 1,000 Neurons 计费。
用尽后推理接口返回 `code 4006`，AI Search 侧表现为
`workers_ai_out_of_capacity_error`，索引任务持续失败、检索接口返回空结果。

已确认的现象：

- 2026-09-11 08:30 UTC 直接调用 `@cf/qwen/qwen3-embedding-0.6b` 返回
  `you have used up your daily free allocation of 10,000 neurons`；
- 同期索引任务出现 87 次 `workers_ai_out_of_capacity_error`，`completed` 为 0。

用尽的原因是此前的失控爬取：`sitemap-0.xml` 含 1492 条 URL，且实例被反复重建与重试，
同一批内容多次进入嵌入流程。切换到 367 条的根语言站点地图后，单次全量索引的成本为：

| 项目 | 取值 |
| --- | --- |
| 根语言文档 | 368 篇，合计约 49.7 万字符 |
| 估算 token | 约 0.20 M |
| 嵌入单价 | 1075 neurons / M input tokens |
| 全量索引成本 | 约 214 neurons，占每日额度约 2% |
| 单次问答成本 | 约 60 neurons（8 段上下文 + 800 token 输出） |

因此**免费额度足够支撑日常索引与问答**，不必升级 Workers Paid。
需要注意的反而是避免重复索引：内容源只用 `sitemap-ai.xml`，
且不要频繁手动触发同步。

应对方式：

- 同步任务安排在额度重置之后执行，见 `.github/workflows/ai-search-sync.yml`
  （每日 01:17 UTC，可手动触发）；
- 仓库需要在 Settings → Secrets 中配置 `CLOUDFLARE_API_TOKEN`，
  权限为 Account > AI Search:Edit 与 AI Search:Run。未配置时工作流跳过而不失败。

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
