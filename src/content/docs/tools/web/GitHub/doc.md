# GitHub

# gist

简单来说，GitHub Gist 是 GitHub 提供的一个“代码片段（Snippet）寄存站”。Gist 就像是一个便签本，专门用来随手记录和分享单份文件、代码片段或小工具配置。

```bash
# 指定版本(每修改一次就有一个版本)
https://gist.githubusercontent.com/用户名/GistID/raw/版本号/文件名
# 最新版
https://gist.githubusercontent.com/用户名/GistID/raw/文件名
```

刚更新的内容会有CDN 缓存延迟 (GitHub 的 Raw 内容缓存刷新时间通常在 5 分钟 左右。但在某些极端情况下或特定地区，可能会有更久的延迟。)
如果你急需立即生效，可以在 URL 后面加一个随机参数（Cache Buster）来骗过缓存，例如：

```bash
https://gist.githubusercontent.com/.../raw/config.yaml?v=20260416 
```
