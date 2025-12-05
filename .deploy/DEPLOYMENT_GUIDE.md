# 部署手册

## 概览

"随猿Fa笔记" 使用Docker容器化部署，基于nginx提供静态文件服务。

**当前部署地址**: http://129.204.8.61:8080/doc-record/

---

## 系统架构

```
                    ┌─────────────────────┐
                    │  腾讯云服务器        │
                    │  129.204.8.61       │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │   端口 8080         │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  Docker Container   │
                    │    doc-record       │
                    │                     │
                    │  ┌───────────────┐  │
                    │  │  Nginx:80     │  │
                    │  └───────┬───────┘  │
                    │          │          │
                    │  ┌───────▼───────┐  │
                    │  │ Static Files  │  │
                    │  │ /usr/share/   │  │
                    │  │ nginx/html/   │  │
                    │  └───────────────┘  │
                    └─────────────────────┘
```

---

## 前置要求

### 本地环境
- Node.js 20+
- npm
- rsync

### 服务器环境
- Docker & Docker Compose v2
- SSH访问权限
- 端口8080已开放

---

## 配置说明

### 1. SSH配置

在 `~/.ssh/config` 中配置：

```
Host fa.internet.tencent
  HostName 129.204.8.61
  User root
  Port 2222
  IdentityFile ~/.ssh/id_ed25519_iu
  ForwardAgent yes
  RemoteForward 127.0.0.1:19093 10.0.5.61:9093
```

**重要**: `RemoteForward`用于Docker镜像下载代理，本地需运行代理服务。

### 2. Docker配置

#### Dockerfile
```dockerfile
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### docker-compose.yml
```yaml
version: '3.8'
services:
  doc-record:
    build: .
    container_name: doc-record
    ports:
      - "8080:80"
    restart: unless-stopped
    networks:
      - doc-network

networks:
  doc-network:
    driver: bridge
```

### 3. Nginx配置

关键配置点：

```nginx
# 使用 ^~ 修饰符确保优先级
location ^~ /doc-record/ {
    alias /usr/share/nginx/html/;
    index index.html;
    try_files $uri $uri/ $uri.html =404;
    error_page 404 = @docusaurus;
}

# SPA fallback
location @docusaurus {
    root /usr/share/nginx/html;
    try_files /index.html =404;
}
```

---

## 部署流程

### 标准部署（推荐）

```bash
# 1. 进入项目目录
cd /Users/fa/dev/projects/other/temp/doc-record

# 2. 安装依赖（如果需要）
npm install

# 3. 本地构建
npm run build

# 4. 使用部署脚本
bash scripts/deploy-compose.sh
```

### 手动部署

如果需要更细致的控制：

```bash
# 1. 本地构建
npm run build

# 2. 同步build目录到服务器
rsync -avz --delete build/ fa.internet.tencent:/www/doc-record/build/

# 3. 同步Docker配置文件
scp Dockerfile nginx.conf docker-compose.yml .dockerignore \
    fa.internet.tencent:/www/doc-record/

# 4. SSH到服务器重建容器
ssh fa.internet.tencent 'cd /www/doc-record && docker compose down && docker compose up -d --build'
```

### 使用代理部署（网络慢时）

如果服务器网络慢，需要使用本地代理：

```bash
# 1. 确保本地代理运行在 10.0.5.61:9093
# 2. 确保SSH RemoteForward配置正确
# 3. 运行带代理的部署脚本
bash scripts/deploy-with-proxy.sh --use-proxy
```

---

## 验证部署

### 1. 检查容器状态

```bash
ssh fa.internet.tencent 'docker ps | grep doc-record'
```

预期输出：
```
doc-record   Up X minutes   0.0.0.0:8080->80/tcp
```

### 2. 测试HTTP响应

```bash
# 测试首页
curl -I http://129.204.8.61:8080/doc-record/

# 测试CSS
curl -I http://129.204.8.61:8080/doc-record/assets/css/styles.3b62a49d.css

# 测试图片
curl -I http://129.204.8.61:8080/doc-record/img/logo.svg
```

所有请求应返回 `HTTP/1.1 200 OK`

### 3. 浏览器测试

访问 http://129.204.8.61:8080/doc-record/ 并验证：
- ✅ 页面样式正确
- ✅ 图片加载正常
- ✅ 导航工作正常
- ✅ 语言切换正常

---

## 故障排查

### 容器无法启动

```bash
# 查看容器日志
ssh fa.internet.tencent 'docker compose logs doc-record'

# 检查nginx配置
ssh fa.internet.tencent 'docker exec doc-record nginx -t'
```

### 静态资源404

检查文件是否正确复制：

```bash
ssh fa.internet.tencent 'docker exec doc-record ls -la /usr/share/nginx/html/'
```

### Docker镜像拉取超时

使用代理或预先拉取镜像：

```bash
ssh fa.internet.tencent 'export HTTP_PROXY=http://127.0.0.1:19093 && export HTTPS_PROXY=http://127.0.0.1:19093 && docker pull nginx:alpine'
```

---

## 回滚

如果新部署有问题，快速回滚：

```bash
# 使用之前的镜像
ssh fa.internet.tencent 'docker images | grep doc-record'
ssh fa.internet.tencent 'docker tag <old-image-id> doc-record-doc-record:latest'
ssh fa.internet.tencent 'cd /www/doc-record && docker compose up -d'
```

---

## 更新内容

更新网站内容：

```bash
# 1. 修改docs或blog内容
# 2. 本地预览
npm start

# 3. 确认无误后重新部署
bash scripts/deploy-compose.sh
```

---

## 安全建议

1. **定期更新**: 定期更新nginx和Node.js镜像
2. **备份**: 定期备份build目录和配置文件
3. **监控**: 使用Docker健康检查监控容器状态
4. **HTTPS**: 考虑添加SSL证书（使用Let's Encrypt）

---

## 相关链接

- [Docusaurus文档](https://docusaurus.io/)
- [Docker Compose文档](https://docs.docker.com/compose/)
- [Nginx配置文档](https://nginx.org/en/docs/)
