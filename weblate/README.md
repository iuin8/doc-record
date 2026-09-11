# Weblate 部署

本目录提供 Weblate 自建部署所需的配置与说明，用于承接站点内容的翻译工作流。
决策背景见《2026-09-10-翻译平台迁移至 Weblate》。

## 1. 准备环境

在一台具备 Docker 与 Docker Compose 的主机上（Oracle Cloud Always Free 的 ARM 实例、
既有 x86 服务器或本机均可）执行：

```bash
cd weblate
cp weblate.env.example .env
# 填写 .env 中的域名、管理员账户、PostgreSQL 密码与邮件服务
```

`.env` 包含凭据，已在 `.gitignore` 中排除，不要提交。

## 2. 启动实例

```bash
docker compose up -d
docker compose logs -f weblate
```

实例默认监听 `127.0.0.1:8080`，需由反向代理终止 TLS 并转发。启用 HTTPS 时，
在 `.env` 中放开 `WEBLATE_ENABLE_HTTPS` 与 `WEBLATE_SECURE_PROXY_SSL_HEADER` 两项。

## 3. 连接仓库

在 Weblate 中通过 GitHub App 授权 `doc-record` 仓库，或添加部署密钥。
仓库以浅克隆拉取，历史中的大对象不会被下载。

## 4. 建立项目与组件

取得 API 令牌后执行仓库根目录的脚本：

```bash
export WEBLATE_URL=https://weblate.example.com
export WEBLATE_API_TOKEN=xxxx
./scripts/weblate-create-components.sh
```

脚本按 `src/content/docs/` 下的一级目录逐个建立组件：

| 配置项 | 取值 |
| --- | --- |
| 文件格式 | Markdown file |
| 源文模板 | `src/content/docs/<目录>/**/*.md` |
| 译文掩码 | `src/content/docs/*/<目录>/**/*.md` |
| 源语言 | `zh_Hans` |
| 目标语言 | `en`、`ja`、`zh_Hant` |

掩码中的 `*` 对应语言代码。Starlight 的译文目录名为 `en`、`ja`、`zh-Hant`，
因此组件的**语言代码风格必须设为 BCP（连字符）**，否则译文会落到 `zh_Hant` 目录。

## 5. 组件建立后的配置

以下内容需在实例中确认，脚本无法覆盖：

1. 文件格式的 front matter 字段：显式声明 `title`、`description`；
2. 启用插件：清理过时的字符串、压缩 Git 提交、发现未翻译文件；
3. 自动建议：启用机器翻译与 LLM 自动建议，用于生成译文初稿；
4. 质量检查：启用术语表强制检查。

## 6. 导入术语表

`glossary/` 下按目标语言提供初始术语，在项目的术语表中逐个导入：

```text
glossary/en.csv        # 中文 → English
glossary/ja.csv        # 中文 → 日本語
glossary/zh-Hant.csv   # 中文 → 繁體中文
```

## 7. 界面文案

界面文案位于 `src/content/i18n/`，文件名使用 Starlight 的语言标记：
`zh-CN.json`（源语言）、`en.json`、`ja.json`、`zh-TW.json`。

该目录的命名与 Weblate 的语言代码不一致（Weblate 使用 `zh_Hant` 之类的形式），
因此界面文案未纳入上述自动组件，需要单独建立组件并指定文件名映射。
当前条目较少，建议人工维护。

## 8. 验证闭环

修改一处源文并提交，确认 Weblate 检测到变更；在 Weblate 中完成翻译后，
译文应以提交或合并请求的形式回到仓库，且变更可追溯。
