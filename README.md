# doc-record

[![zread](https://img.shields.io/badge/Ask_Zread-_.svg?style=flat&color=00b0aa&labelColor=000000&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB3aWR0aD0iMTYiIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNiAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTQuOTYxNTYgMS42MDAxSDIuMjQxNTZDMS44ODgxIDEuNjAwMSAxLjYwMTU2IDEuODg2NjQgMS42MDE1NiAyLjI0MDFWNC45NjAxQzEuNjAxNTYgNS4zMTM1NiAxLjg4ODEgNS42MDAxIDIuMjQxNTYgNS42MDAxSDQuOTYxNTZDNS4zMTUwMiA1LjYwMDEgNS42MDE1NiA1LjMxMzU2IDUuNjAxNTYgNC45NjAxVjIuMjQwMUM1LjYwMTU2IDEuODg2NjQgNS4zMTUwMiAxLjYwMDEgNC45NjE1NiAxLjYwMDFaIiBmaWxsPSIjZmZmIi8%2BCjxwYXRoIGQ9Ik00Ljk2MTU2IDEwLjM5OTlIMi4yNDE1NkMxLjg4ODEgMTAuMzk5OSAxLjYwMTU2IDEwLjY4NjQgMS42MDE1NiAxMS4wMzk5VjEzLjc1OTlDMS42MDE1NiAxNC4xMTM0IDEuODg4MSAxNC4zOTk5IDIuMjQxNTYgMTQuMzk5OUg0Ljk2MTU2QzUuMzE1MDIgMTQuMzk5OSA1LjYwMTU2IDE0LjExMzQgNS42MDE1NiAxMy43NTk5VjExLjAzOTlDNS42MDE1NiAxMC42ODY0IDUuMzE1MDIgMTAuMzk5OSA0Ljk2MTU2IDEwLjM5OTlaIiBmaWxsPSIjZmZmIi8%2BCjxwYXRoIGQ9Ik0xMy43NTg0IDEuNjAwMUgxMS4wMzg0QzEwLjY4NSAxLjYwMDEgMTAuMzk4NCAxLjg4NjY0IDEwLjM5ODQgMi4yNDAxVjQuOTYwMUMxMC4zOTg0IDUuMzEzNTYgMTAuNjg1IDUuNjAwMSAxMS4wMzg0IDUuNjAwMUgxMy43NTg0QzE0LjExMTkgNS42MDAxIDE0LjM5ODQgNS4zMTM1NiAxNC4zOTg0IDQuOTYwMVYyLjI0MDFDMTQuMzk4NCAxLjg4NjY0IDE0LjExMTkgMS42MDAxIDEzLjc1ODQgMS42MDAxWiIgZmlsbD0iI2ZmZiIvPgo8cGF0aCBkPSJNNCAxMkwxMiA0TDQgMTJaIiBmaWxsPSIjZmZmIi8%2BCjxwYXRoIGQ9Ik00IDEyTDEyIDQiIHN0cm9rZT0iI2ZmZiIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPgo8L3N2Zz4K&logoColor=ffffff)](https://zread.ai/iuin8/doc-record) [![Crowdin](https://badges.crowdin.net/doc-record/localized.svg)](https://crowdin.com/project/doc-record)

> 提示：点击上方Zread徽章可跳转到本仓库的 AI 问答页（Zread），支持搜索与提问，快速获取结构化指引。
> [AI 问答入口(zread)](https://zread.ai/iuin8/doc-record)

## 介绍

记录一些文档, 关于docker, k8s, 以及一些其他工具的文档.

## 安装

```bash
npx create-docusaurus@latest doc-record classic
cd doc-record
npm install
npm run start
```

- 生成侧边栏
  - [相关文档](./generate_sidebar.md)
    - 目前使用方法三

```bash
# 启动项目
npm run start
```

## github pages

### 自定义host

[github设置路径](https://github.com/183461750/doc-record/settings/actions/runners/new?arch=arm64&os=osx)

> PS: 以下命令均在项目根目录下操作的(别再根目录操作了, 文件太多, 系统都要卡住了...)

Download

```bash
# Create a folder
$ mkdir actions-runner && cd actions-runner
Copied!# Download the latest runner package
$ curl -o actions-runner-osx-arm64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-osx-arm64-2.320.0.tar.gz
Copied! # Optional: Validate the hash
$ echo "14e2600c07ad76a1c9f6d9e498edf14f1c63f7f7f8d55de0653e450f64caa854  actions-runner-osx-arm64-2.320.0.tar.gz" | shasum -a 256 -c
Copied! # Extract the installer
$ tar xzf ./actions-runner-osx-arm64-2.320.0.tar.gz
```

Configure

```bash
# Create the runner and start the configuration experience
$ ./config.sh --url https://github.com/183461750/doc-record --token AJCNPVOFCKIXJHNU4XPGEX3HCO3O4
Copied!# Last step, run it!
$ ./run.sh
```

Using your self-hosted runner

```bash
# Use this YAML in your workflow file for each job
runs-on: self-hosted
```

## 使用到的vscode插件

- eliostruyf.vscode-front-matter-beta

## 人机协作指南

### 内容创作者（人类）

```bash
1. 专注在_docs目录编写Markdown
2. 使用分类文件夹组织文档
3. 保持Front Matter简洁
```

### AI开发助手

```bash
1. 维护_docs目录结构稳定性
2. 自动优化知识呈现方式
3. 确保所有文档URL永久可用
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

- [docusaurus](https://docusaurus.io/)

## TODO

- 接入AI搜索
  - [官方搜索相关文档](https://docusaurus.io/docs/search)
  - [参考页面](https://docs.orama.com/cloud/data-sources/native-integrations/docusaurus)
- 接入AI翻译能力
  - crowdin.com
