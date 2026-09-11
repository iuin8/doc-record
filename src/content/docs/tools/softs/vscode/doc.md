# vscode

## claude code

- 配置 VS Code 插件设置(可视化界面中也可以设置, 搜`claudecode`就行)
打开 VS Code 的 settings.json 文件（可通过 Ctrl+, 打开设置，点击右上角图标选择 "Open Settings (JSON)"），添加以下配置：

```bash
{
  "claudecode.initialpermissionmode": "bypasspermissions",
  "claudecode.allowdangerouslyskippermissions": true
}
```

- 配置 Claude Code 的权限规则

在项目根目录或用户全局配置目录（~/.claude/settings.json）中，编辑 settings.json 文件，添加以下内容：

```bash
{
  "permissions": {
    "defaultmode": "bypasspermissions",
    "ask": [
      "bash(rm -rf *)",
      "bash(rm *)",
      "bash(git push --force*)",
      "bash(sudo *)"
    ]
  }
}
```

> 此配置将所有操作默认设为 bypass，但通过 ask 列表明确列出高风险命令（如删除文件、强制推送 Git 提交、使用 sudo 等），这些命令仍会弹窗确认。
