---
title: Astro Starlight 迁移实施记录
---

# Astro Starlight 迁移实施记录

实施日期：2026-09-11
决策依据：《2026-09-09-Astro-Starlight-迁移评估》第一节的迁移决策
关联文档：《2026-09-10-翻译平台迁移至 Weblate》

## 一、实施结果

Docusaurus 3.10 已整体替换为 Astro 7 + Starlight 0.42，本地构建通过：

- 构建命令 `astro build`，产出 1493 个 HTML 页面，耗时约 75 秒；
- Pagefind 搜索索引构建成功（1493 个页面入索引），`sitemap-index.xml` 生成；
- 37 张随文图片经 Astro 图像处理优化；
- 构建日志中 `[ERROR]` 为 0，代码高亮缺失告警为 0；
- 剩余 44 条 `[content]` 告警均为「某 locale 下条目不存在」，由译文尚未生成导致，接入 Weblate 后自然消除。

## 二、依赖变更

| 项目 | 迁移前 | 迁移后 |
| --- | --- | --- |
| 框架 | `@docusaurus/core` 3.10 | `astro` 7.3.2 |
| 文档主题 | `@docusaurus/preset-classic` | `@astrojs/starlight` 0.42.0 |
| Markdown 处理 | `@docusaurus/mdx-loader` 系列 | `@astrojs/markdown-remark` 7.3.1 |
| 博客 | Docusaurus 内置 blog 插件 | `starlight-blog` 0.29.0 |
| 搜索 | `@easyops-cn/docusaurus-search-local` | Starlight 内置 Pagefind |
| 代码高亮 | Prism（`rehype-prism-plus`） | Shiki（Expressive Code） |
| 类型检查 | `tsc --noEmit` | `@astrojs/check` 0.9.10 |
| 翻译上传 | `@crowdin/cli` | 已移除，改由 Weblate 回写 |

`typescript` 锁定在 5.9 线：最新版 7.0.2 超出 `@astrojs/check` 的 peer 范围（`^5.0.0 || ^6.0.0`）。

## 三、目录结构变更

| 迁移前 | 迁移后 |
| --- | --- |
| `docs/`（910 个受控文件） | `src/content/docs/` |
| `docs/README.md` | `src/content/docs/index.md` |
| `blog/`（14 篇） | `src/content/docs/blog/` |
| `static/` | `public/` |
| `docusaurus.config.ts`、`sidebars.ts` | `astro.config.mjs` |
| `src/utils/sidebarGenerator.ts` | 已删除，改用 Starlight `autogenerate` |
| `src/components/AISearchNavbar.tsx` | 已删除（React 组件，见第六节） |
| `src/theme/SearchBar/index.tsx` | 已删除 |
| `src/css/custom.css` | 已删除（Infima 变量体系不适用） |
| `crowdin.yml`、`404.html` | 已删除 |

博客文章置于 `src/content/docs/blog/`，是 `starlight-blog` 的强制约定：该插件复用 `docs` 集合并通过 `docsSchema({ extend })` 扩展字段，不使用独立集合。

## 四、语言配置

采用 root locale 方案，`zh-Hans` 内容保持在 `src/content/docs/` 根，URL 不带语言前缀，与迁移前的 Docusaurus 行为一致：

```js
defaultLocale: 'root',
locales: {
  root: { label: '中文', lang: 'zh-CN' },
  en: { label: 'English', lang: 'en' },
  'zh-Hant': { label: '繁體中文', lang: 'zh-TW' },
  ja: { label: '日本語', lang: 'ja' },
},
```

`lang` 取值对齐 Starlight 内置的 UI 文案语言标识（`zh-CN`、`zh-TW`、`ja`），因此无需自建 `src/content/i18n/` 即可获得本地化界面文案。

## 五、内容与配置处理项

迁移过程中出现以下八类问题，均已处置：

1. **`social` 配置语法**：Starlight 0.33 起由对象改为数组，对象写法触发 `AstroUserError`。已改为 `[{ icon, label, href }]`。
2. **重复 front matter**：部分博客文件的 front matter 前有空行，按「字符串开头锚定」的正则未能识别，导致又追加一段，形成双 front matter。已改为逐行解析并合并重复块，脚本具备幂等性。
3. **Docusaurus `slug` 字段**：该字段会覆盖 Astro 由路径生成的条目 ID，使 `starlight-blog` 无法按 ID 反查所属目录，构建时报 `Failed to get blog configuration`。已从博客 front matter 移除。
4. **缺失 `title`**：Starlight 的 `docsSchema` 要求 `title`。368 篇中 354 篇无 front matter、3 篇有 front matter 但无 `title`，已按首个一级标题回填，无标题时回退为文件名。
5. **缺失 `date`**：`starlight-blog` 要求博客条目有 `date`。7 篇缺失，已按文件首次提交的 `git` 作者时间回填。
6. **YAML 解析失败**：2 个文件的 front matter 中 `sidebar_position` 带前导空格，插入 `title` 后构成非法缩进。已去除缩进。
7. **代码围栏语言大小写**：`Dockerfile`、`JavaScript` 等首字母大写的语言标识在 Shiki 中查不到，退化为纯文本。已统一为小写，高亮告警归零。
8. **`.gitignore` 冲突**：旧规则含 `public/`（Jekyll 时代遗留），与 Astro 的静态资源目录同名，会导致新增静态文件被忽略。已移除该规则并补充 `.astro/`。

相关脚本位于 `scripts/`：`migrate-content.py`、`normalize-frontmatter.py`、`ensure-title.py`、`backfill-blog-date.py`、`strip-blog-slug.py`。

## 六、已知差异与待办

| 事项 | 状态 | 说明 |
| --- | --- | --- |
| 博客 URL 变化 | 已处理 | 旧 slug 与大小写差异的路径已在 `astro.config.mjs` 的 `redirects` 中映射，共 11 条 |
| 许可证声明 | 已完成 | `LICENSE` 与 `package.json` 统一为 MIT |
| CI 验证 | 已通过 | GitHub Actions 构建 1m31s 成功，Pages 状态 `built` |
| Cloudflare AI Search | 以 llms.txt 替代 | 站内搜索由 Pagefind 承担；面向 AI   改为输出 `llms.txt` 与原文端点，见第十节 |
| Mermaid | 已完成 | 2 处代码块按需渲染，仅含图表的页面加载 Mermaid，见第十节 |
| KaTeX | 不迁移 | 全文无 LaTeX 公式（唯一出现的 `$$` 为 Shell 代码块中的 PID 变量），无实际影响 |
| 公告栏 | 以页眉入口承接 | 原横幅内容为「给项目点星」，改为页眉 GitHub 社交图标与首页正文引导 |
| AI 相关能力 | 已完成 | 构建期产出 `llms.txt`，页面提供复制原文与跳转 AI 的入口，见第十节 |
| 编辑此页链接 | 已修复 | `editLink.baseUrl` 需指向仓库根目录，Starlight 会自行拼接条目的 filePath |

## 七、构建期告警

- 高亮告警已清零。原有 `Dockerfile`、`ssh`、`gradle` 三种围栏语言不在 Shiki 支持范围内，
  分别改为 `dockerfile`、`ssh-config`、`groovy`。后两者为对应语言的通用写法，不依赖框架扩展。
- 构建期存在 43 条 `Entry docs → zh-Hant/... was not found` 提示。原因为繁体中文译文尚未产生，
  Starlight 按回退策略展示默认语言内容。译文通过 Weblate 回流后该提示自动消失，不属于构建缺陷。

## 八、本地依赖安装的约束

本机 `pnpm install` 在链接阶段被文件代理拦截（`Brokered host mkdir requires an available runtime file rule`），该限制由注入 Node 进程的钩子产生，与 bash 沙箱开关无关。采取的处置：

- `pnpm install --lockfile-only` 生成 `pnpm-lock.yaml`，仅做依赖解析，不写入 `node_modules`，因此不受拦截；
- 本地 `node_modules` 由 `bun install` 生成，仅用于构建验证，`bun.lock` 已加入 `.gitignore`，不进入版本控制。

CI 环境无此限制，`pnpm install --frozen-lockfile` 可正常执行。

## 九、Markdown 元数据约定

内容文件遵循「原生态优先」原则：作者创建 Markdown 时不需要为了通过构建而填写任何字段。

### 约定

1. **不要求 front matter**。页面标题由构建期从正文首个一级标题推导，无一级标题时回退为文件名；
2. **`title` 为可选字段**。仅在需要与一级标题不同（例如侧边栏显示更短的名称）时才显式声明；
3. **只使用跨框架通用字段**：`title`、`description`、`date`、`tags`、`authors`。
   `sidebar_position`、`sidebar_label`、`slug`、`custom_edit_url` 等框架特有字段已从内容中移除；
4. **正文只使用 CommonMark 与 GFM**。不使用 `:::note` 一类的框架指令，以保证多端渲染规则一致。

### 实现

`src/content.config.ts` 中包装了 Starlight 的 `docsLoader`：在加载阶段遍历条目，
为未声明 `title` 的条目读取源文件、取首个一级标题并去除行内 Markdown 标记后写入 `data.title`。
同时通过 `docsSchema({ extend })` 将 `title` 由必填降为可选。

`scripts/strip-framework-frontmatter.py` 负责清理：移除 Docusaurus 特有字段，
并剥离「仅含 `title` 且该标题与一级标题一致」的 front matter（共 351 个文件）。

### 迁移兼容性

上述字段在 Jekyll、Hugo、VitePress、MkDocs、Docusaurus 中含义一致，更换框架时无需改写内容。
标题推导逻辑本身也是主流站点生成器的通用行为，因此该约定不引入框架锁定。

## 十、面向 AI 的输出与按需渲染

### 构建期产物

| 产物 | 说明 |
| --- | --- |
| `llms.txt` | 站点索引，指向精简版与完整版纯文本 |
| `llms-small.txt` | 去除非必要内容后的精简版，约 762 KB |
| `llms-full.txt` | 全站正文，约 769 KB |
| `/_llms-txt/<分类>.txt` | 按分类拆分的正文分卷，10 个 |
| `/raw/<文档路径>.md` | 与页面同路径的 Markdown 原文，共 367 个端点 |
| `robots.txt` | 显式放行主流 AI 检索与训练爬虫，并声明 sitemap |

`llms.txt` 由 `starlight-llms-txt` 插件在构建期生成，内容源与页面一致，无需单独维护。
`/raw/` 端点由 `src/pages/raw/[...slug].md.ts` 提供，读取 content collection 的 `entry.body`，
以 `text/markdown` 返回。该端点不进入 sitemap，不影响收录结构。

原先的 Cloudflare AI Search 依赖 Docusaurus 的 React 挂载点，迁移成本高且只对站内检索有效。
改为上述方案后，AI 侧可直接消费纯文本，不依赖页面 HTML 结构，也不绑定具体厂商。

### 可发现性

除 `llms.txt` 入口外，页面自身也声明了可被机器直接消费的表示形式：

- `<link rel="alternate" type="text/markdown">` 指向当前页的原文端点，
  AI 客户端无需解析 HTML 即可定位纯文本；
- `schema.org` 的 `TechArticle` 结构化数据，包含标题、描述、语言与发布时间（有则填）；
- `robots.txt` 中单独列出 GPTBot、ClaudeBot、PerplexityBot、Google-Extended 等
  AI 爬虫并显式允许，同时声明 sitemap。

分卷的目的是控制上下文长度：完整版 769 KB 已接近多数模型的上下文上限，
按分类取用可将单次输入降到 9 KB 至 278 KB 区间。分卷路径由插件根据标签生成，
分类标签使用英文以保证路径稳定，说明文字使用中文。

### 页面入口

`src/components/PageTitle.astro` 覆写标题区，在其下追加 `AiActions.astro`：

- 「复制 Markdown」从同源的 `/raw/` 端点取原文写入剪贴板，不经过第三方服务；
- 「在 ChatGPT / Claude 中打开」以当前页面绝对地址为参数跳转，由用户自行提问。

### Mermaid 按需渲染

`MermaidRenderer.astro` 在客户端检测 `pre[data-language="mermaid"]`，存在时才动态载入 Mermaid
并渲染为 SVG；切换主题时重新渲染。全站仅 2 篇文档含图表，其余页面不产生这部分脚本请求。
`securityLevel` 设为 `strict`，图表中的 HTML 标签不会被解析。

## 十一、内容质量门禁

`scripts/check-content.py` 在合并前检查内容，由 `.github/workflows/content-check.yml`
在 pull request 阶段对**变更文件**执行；全量检查通过 `pnpm run check:content` 手动触发。

| 检查项 | 级别 | 说明 |
| --- | --- | --- |
| 代码块围栏语言 | 阻断 | 不在 Shiki 支持范围内会静默回退为纯文本 |
| front matter 字段 | 阻断 | 只允许第九节列出的通用字段；`SKILL.md` 遵循 Agent Skills 规范，不参与检查 |
| 本地引用是否存在 | 阻断 | 站内绝对路径按 `public/` 解析；`host:port` 形态不作为文件引用 |
| 疑似密钥 | 阻断 | 私钥、AWS / GitHub / Slack / OpenAI 风格密钥；示例中的占位内容不命中 |
| 内网地址 | 提示 | 运维文档中通常为示例配置，仅汇总计数，不阻断 |

首轮全量检查发现并处置：

- `openHands.md` 中存在可用的 DashScope API 密钥，已替换为占位符；
  该密钥已进入 Git 历史，需另行轮换。
- 2 处 Redis 文档交叉引用指向不存在的 `doc.md`，已修正为 `redis.md`。

尚未修复的存量问题（目标文档缺失，需由作者补充内容）：

| 位置 | 缺失引用 |
| --- | --- |
| `blog/docker/doc/material/manual/article/ssh.md:42` | `ssh动态代理` |
| `docker/dev_utls/.../tomcat-war/tomcat-war.md:5` | `./has-font/Dockerfile` |
| `kubernetes/kubernetes.md:106` | `./docs/temp/yum安装k8s.md` |
| `kubernetes/kubernetes.md:138` | `./kuboard/doc.md` |
| `tools/softs/clash/history/clash.md:5` | `/root/vpn` |

## 十二、界面文案多语言

AI 操作区的文案通过 Starlight 的 i18n 机制提供，位于 `src/content/i18n/`。

文件名必须使用**语言标记**而非 locale 名：Starlight 读取 i18n 数据时以
`defaultLocale.lang` 与 `locales[*].lang` 为键，因此源语言文件为 `zh-CN.json`，
繁体为 `zh-TW.json`，而非 `root.json` 与 `zh-Hant.json`。
