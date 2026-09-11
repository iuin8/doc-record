# Weblate 部署

本目录提供 Weblate 部署所需的配置与说明，用于承接站点内容的翻译工作流。
决策背景见《2026-09-10-翻译平台迁移至 Weblate》。

**当前采用 Hosted Weblate 的 Libre 计划**（2026-09-11 决定），步骤见第 0 节。
第 1 节及之后为自建部署路径，作为备用方案保留。

若不使用自建实例，可改用 Weblate 托管的 Libre 计划：免费、面向公开的自由软件项目，
本项目规模约为其额度上限的 9%。该方案的适用性与限制见 ADR 第 5.2.1 节，
本文档不再重复。

## 0. 托管方案（当前采用）

### 0.1 额度与资格

| 项目 | 数值 |
| --- | --- |
| Libre 计划托管字符串上限 | 160,000 |
| 本项目估算 | 约 14,600（约为上限的 9%） |
| 项目数上限 | 1 |
| 组件、译者、语言数 | 无限制 |
| 资格要求 | 公开仓库 + 自由软件许可 |

仓库 `iuin8/doc-record` 为公开仓库，许可证为 MIT，满足申请条件。

### 0.2 申请与建项

1. 在 <https://hosted.weblate.org/> 注册账户；
2. 在 <https://hosted.weblate.org/hosting/> 创建项目：
   - 名称与标识均为 `doc-record`；
   - 源语言选 **Chinese (Simplified)**（Weblate 代码 `zh_Hans`）；
   - 仓库地址 `https://github.com/iuin8/doc-record.git`，分支 `main`；
   - 通过 Weblate 的 GitHub App 完成授权，使译文能够回写；
3. 在项目设置的计费区域申请 **Libre 计划**，说明项目为公开的 MIT 许可文档站；
4. 在「用户设置 - API 访问」中生成 API 令牌。

**项目数仅允许 1 个**，请勿另建测试项目占用额度。

### 0.3 建立组件

```bash
export WEBLATE_API_TOKEN=xxxx
./scripts/weblate-create-components.sh
```

脚本默认指向 `https://hosted.weblate.org`，项目已在网页端创建时会自动跳过建项目步骤，
只建立组件。若需显式指定：

```bash
CREATE_PROJECT=false ./scripts/weblate-create-components.sh
```

### 0.4 建立后需手工确认的配置

1. 各组件的语言代码风格为 **BCP（连字符）**，否则译文落到 `zh_Hant` 目录而非 `zh-Hant`；
2. 文件格式的 front matter 字段显式声明 `title`、`description`；
3. 启用插件：清理过时的字符串、压缩 Git 提交、发现未翻译文件；
4. 启用机器翻译与 LLM 自动建议，用于生成译文初稿；
5. 导入 `glossary/` 下的术语表并启用术语表强制检查。

### 0.5 备份

托管实例的备份由 Weblate 负责。译文最终以提交形式回到 Git 仓库，
仓库本身即为可恢复副本，无需另行配置备份。

## 1. 自建部署（备用方案）

### 1.1 创建 Oracle Cloud Always Free 实例

| 配置项 | 取值 |
| --- | --- |
| 形状 | `VM.Standard.A1.Flex`（ARM） |
| 规格 | 2 OCPU + 12 GB 内存（免费额度上限为 4 OCPU + 24 GB，保留余量） |
| 镜像 | Ubuntu 24.04 Minimal aarch64（官方镜像提供 ARM 构建） |
| 启动卷 | 默认 46.8 GB 起，免费额度含 200 GB，可按需调大 |

注意事项：

- 注册需绑定信用卡用于身份验证，在免费额度内不产生费用；
- **不要使用 AMD 微型实例（1/8 OCPU + 1 GB 内存）**。Weblate 官方给出的单节点
  最低要求为 3 GB 内存与 2 核 CPU，该规格无法运行；
- 热门区域常出现 `Out of host capacity`，处理顺序为：更换可用性域 → 更换区域 →
  将账户升级为 Pay As You Go（仍享免费额度，但 ARM 容量成功率更高）→ 用 OCI CLI
  循环重试；
- 长期空闲的实例存在被回收的可能，因此第 8 节的备份是必需的，不是可选项。

### 1.2 安全组

通过 Cloudflare Tunnel 发布时**不需要开放任何入站端口**，仅保留 SSH（22）用于运维。
在 VCN 的安全列表中只放行 22 端口即可。

### 1.3 安装 Docker

```bash
sudo apt update && sudo apt install -y docker-compose-plugin
sudo usermod -aG docker "$USER"   # 重新登录后生效
```

### 1.4 部署文件

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

实例默认监听 `127.0.0.1:8080`，不对外暴露，由 Cloudflare Tunnel 发布。

## 3. 通过 Cloudflare Tunnel 发布

在主机上安装 cloudflared 并建立隧道，无需开放入站端口，也无需在公网暴露源站 IP：

```bash
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
  | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" \
  | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt update && sudo apt install -y cloudflared

cloudflared tunnel login
cloudflared tunnel create weblate
cloudflared tunnel route dns weblate weblate.iuin888vip.icu
```

写入 `/etc/cloudflared/config.yml`：

```yaml
url: http://127.0.0.1:8080
tunnel: weblate
credentials-file: /root/.cloudflared/<隧道ID>.json
```

注册为系统服务：

```bash
sudo cloudflared service install
sudo systemctl start cloudflared
```

建议在 Zero Trust 中为 `weblate.iuin888vip.icu` 配置访问策略，
仅允许指定邮箱登录，避免管理界面直接暴露在公网。

## 4. 连接仓库

在 Weblate 中通过 GitHub App 授权 `doc-record` 仓库，或添加部署密钥。
仓库以浅克隆拉取，历史中的大对象不会被下载。

## 5. 建立项目与组件

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

## 6. 组件建立后的配置

以下内容需在实例中确认，脚本无法覆盖：

1. 文件格式的 front matter 字段：显式声明 `title`、`description`；
2. 启用插件：清理过时的字符串、压缩 Git 提交、发现未翻译文件；
3. 自动建议：启用机器翻译与 LLM 自动建议，用于生成译文初稿；
4. 质量检查：启用术语表强制检查。

## 7. 导入术语表

`glossary/` 下按目标语言提供初始术语，在项目的术语表中逐个导入：

```text
glossary/en.csv        # 中文 → English
glossary/ja.csv        # 中文 → 日本語
glossary/zh-Hant.csv   # 中文 → 繁體中文
```

## 8. 界面文案

界面文案位于 `src/content/i18n/`，文件名使用 Starlight 的语言标记：
`zh-CN.json`（源语言）、`en.json`、`ja.json`、`zh-TW.json`。

该目录的命名与 Weblate 的语言代码不一致（Weblate 使用 `zh_Hant` 之类的形式），
因此界面文案未纳入上述自动组件，需要单独建立组件并指定文件名映射。
当前条目较少，建议人工维护。

## 9. 备份

免费实例存在被回收的可能，备份是必需的。在主机上按日执行：

```bash
# 数据库
docker compose exec -T database pg_dump -U weblate weblate | gzip > /backup/weblate-$(date +%F).sql.gz

# 数据目录（含译文仓库与配置）
docker compose stop weblate
tar -czf /backup/weblate-data-$(date +%F).tar.gz /var/lib/docker/volumes/weblate_weblate-data
docker compose start weblate
```

将 `/backup` 下的文件同步到 R2：

```bash
rclone sync /backup r2:doc-record-backup/weblate
```

R2 中可配置生命周期规则，30 天后转入低频访问存储。恢复时先还原数据目录，再导入数据库转储。

## 10. 验证闭环

修改一处源文并提交，确认 Weblate 检测到变更；在 Weblate 中完成翻译后，
译文应以提交或合并请求的形式回到仓库，且变更可追溯。
