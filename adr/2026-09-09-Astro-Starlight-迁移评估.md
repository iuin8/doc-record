---
title: Astro Starlight 迁移评估
sidebar_label: Astro Starlight 迁移评估
---

# Astro Starlight 迁移评估

评估日期：2026-09-09
评估对象：`doc-record`（Docusaurus 3.10，367 篇 Markdown，四语言）

## 一、结论

> **结论更新（2026-09-10）**：项目已决定执行迁移至 Astro Starlight。原结论为「暂不迁移，
> 待 Docusaurus v4 发布后重新评估」，本次更新基于两项新事实：
>
> 1. 经核查，仓库中 i18n 译文文件数为 0（`git ls-files i18n` 返回空），译文从未进入版本
>    控制，因此第四节所列的「国际化与 Crowdin 重建」这一最高成本项实际不存在；
> 2. 翻译平台已决策由 Crowdin 迁移至 Weblate（见《2026-09-10-翻译平台迁移至 Weblate》），
>    而 Starlight 按 locale 分目录的内容结构与该 Git 原生工作流天然契合。
>
> 第七节「当前建议」相应失效，以本节的迁移决策为准。
>
> 迁移已于 2026-09-11 执行完成，实施过程与已知差异见《2026-09-11-Astro-Starlight-迁移实施记录》。

Starlight 在运行时架构、默认主题观感与搜索方案上具备客观优势。初始评估时认为当前项目处于跨端改造阶段，迁移不产生跨端收益，且主要成本集中在国际化与插件链重建。

## 二、版本与生态现状（2026-09-09）

| 项目 | 现状 |
| --- | --- |
| Starlight 稳定版 | 0.41.10（2026-08-28），MIT |
| Starlight 与 Astro 的耦合 | 0.41.x 要求 `astro ^7.0.2`；0.40.x 要求 `^6.4.5`；0.39.x 要求 `^6.0.0` |
| Astro 发布节奏 | 由半年一次转为月度；6.0（2026-02）、6.2 / 6.3（2026-04 至 05）、7 alpha（2026-04-30） |
| Astro 7 的 Node 要求 | `>= 22.12.0` |
| Docusaurus 稳定版 | 3.10.2（2026-07-10），官方明示为 v3 最后一个版本 |
| Docusaurus v4 | 尚未发布，无 4.x dist-tag；3.10 已提供 `future.v4` 开关供渐进适配 |
| 社区规模 | Starlight 约 8.4k stars；Docusaurus 约 65k stars |

Docusaurus 仓库保持活跃（提交持续至 2026-08-31），不存在维护停滞问题。

## 三、维度对比

| 维度 | Starlight | Docusaurus 3.10 | 说明 |
| --- | --- | --- | --- |
| 运行时架构 | Astro 岛屿架构，默认零 JS | React 运行时 + SPA 水合 | Starlight 客户端负载更低 |
| 默认主题 | 现代精致，开箱可用 | 基于 Infima，观感偏传统 | 差异主要影响首观感与改造量 |
| 搜索 | Pagefind 内置，构建期静态索引，无外部服务 | 需 Algolia DocSearch 或本地插件 | 本站点已配置本地搜索插件 |
| 国际化 | 内置，按 locale 分目录 | 内置，配套 Crowdin 工作流 | 本站点四语言 + Crowdin 已跑通 |
| 版本管理 | 无内置，依赖社区插件 | 内置 | 本站点未使用版本管理 |
| 内容目录 | `src/content/docs/` | `docs/` | 影响跨端脚本的内容路径 |
| 交互组件 | 任意框架，需 `client:*` 指令 | 仅 React | 本站点自定义组件极少 |
| 代码高亮 | Shiki | Prism | 均满足需求 |

## 四、迁移成本拆解

| 事项 | 工作量 | 说明 |
| --- | --- | --- |
| 内容平移 | 低 | 367 篇以纯 Markdown 为主，无 admonition 指令、无内联 HTML，可整体移动 |
| 目录结构调整 | 低 | `docs/` → `src/content/docs/`，需同步调整跨端预编译脚本的内容根路径 |
| 侧边栏 | 低 | Starlight 支持 `autogenerate`，可替代现有 `sidebarItemsGenerator` |
| 国际化与 Crowdin | **高** | 目录约定与翻译文件路径变化，Crowdin 配置需重建并重新校验四语言 |
| 搜索 | 中 | 本地搜索插件替换为 Pagefind；已接入的 Cloudflare AI Search 脚本需重新挂载 |
| Mermaid / KaTeX | 中 | 需改用 Astro 生态的 remark / rehype 方案重新接入 |
| 自定义组件 | 低 | `AISearchNavbar`、`SearchBar` 需改写为 Astro 组件或岛屿 |

成本集中在配置与插件链，内容本身不是障碍。

## 五、AI 生态专项

两者均依赖社区插件，无内置能力：

| 方案 | 插件 | 产出 |
| --- | --- | --- |
| Starlight | `starlight-llms-txt` | `llms.txt`、`llms-full.txt`、`llms-small.txt`（面向小上下文窗口） |
| Docusaurus | `docusaurus-plugin-llms` | `llms.txt`、`llms-full.txt`、逐页 Markdown |

Starlight 多一档 `llms-small.txt`，对上下文受限场景略有优势，但不足以构成迁移理由。

关于 llms.txt 的实际收益，需区分场景：

- 对技术文档与 API 文档有实际作用，AI 编码助手（Cursor、Copilot、Claude）会据此抓取对应页面；
- 对博客与营销页面基本无效；
- 截至 2026 年，尚无主流 AI 厂商公开承诺在生产环境读取该文件，公开研究显示 AI 爬虫访问量中约 0.1% 触及 llms.txt。

本站点属技术文档，llms.txt 具备实际价值，但两个框架均可满足，不构成选型差异。若暂不迁移，可在现有 Docusaurus 上直接接入 `docusaurus-plugin-llms`。

## 六、与跨端方案的关系

跨端方案的实质是「Markdown 单一事实来源 + 小程序端构建期预编译」（参见 `2026-09-09-跨端方案调研.md`）。该架构对 Web 端框架无依赖：

- 更换 Web 框架不改变小程序端方案；
- 但内容目录若由 `docs/` 改为 `src/content/docs/`，预编译脚本的内容根路径需同步调整；
- 因此若计划迁移，宜在跨端脚本落地前完成，避免二次调整。

## 七、建议与触发条件

### 更新后的执行顺序（2026-09-10）

1. 统一许可证声明（`package.json` 的 `license` 与 `LICENSE` 文件对齐）；
2. 迁移至 Astro Starlight，内容根目录改为 `src/content/docs/`；
3. 接入 Weblate，按 locale 目录建立组件，译文回写仓库；
4. 最后实施跨端预编译脚本，避免内容路径二次变更。

### 原建议（已由上述决策取代）

1. 跨端是当前主要目标，更换 Web 框架不产生跨端收益，反而占用改造窗口；
2. 现有站点的国际化、搜索、图表与公式均已跑通，重建收益低于成本；
3. Docusaurus v4 尚未发布，其 `future.v4.fasterByDefault` 等开关预示性能改进，待 v4 落地后对比更充分。

### 可立即执行的低成本改进

在维持 Docusaurus 的前提下：

1. 接入 `docusaurus-plugin-llms`，产出 `llms.txt` 与逐页 Markdown；
2. 在 CI 中补充构建前校验（死链、front matter）；
3. 评估是否开启 `future.v4` 开关，为后续 v4 升级摊薄成本。

### 触发重新评估的条件

1. Docusaurus v4 正式发布且改进幅度有限；
2. 站点出现明确的性能或观感诉求，且现有主题改造成本超过迁移成本；
3. 跨端改造完成后，进入以站点体验为主的阶段。

## 八、Node 版本管理

项目已新增 `.node-version`（内容 `22.23.2`），`fnm` 在 shell 中配置了 `--use-on-cd`，进入目录时自动切换。

- 该版本满足当前 Docusaurus 的 `>=20.18.1` 要求；
- 亦满足 Astro 7 的 `>=22.12.0` 要求，后续若迁移无需额外升级 Node；
- `package.json` 中的 `engines.node` 为 `>=20.18.1`，若迁移至 Astro 需上调至 `>=22.12.0`。
