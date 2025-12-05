# 操作手册

日常运维和维护指南。

---

## 日常操作

### 查看容器状态

```bash
ssh fa.internet.tencent 'docker ps -a | grep doc-record'
```

### 查看实时日志

```bash
ssh fa.internet.tencent 'docker compose -f /www/doc-record/docker-compose.yml logs -f doc-record'
```

### 重启容器

```bash
ssh fa.internet.tencent 'cd /www/doc-record && docker compose restart'
```

### 停止容器

```bash
ssh fa.internet.tencent 'cd /www/doc-record && docker compose stop'
```

### 启动容器

```bash
ssh fa.internet.tencent 'cd /www/doc-record && docker compose start'
```

### 完全重建

```bash
ssh fa.internet.tencent 'cd /www/doc-record && docker compose down && docker compose up -d --build'
```

---

## 监控

### 检查资源使用

```bash
# 容器资源使用
ssh fa.internet.tencent 'docker stats doc-record --no-stream'

# 磁盘使用
ssh fa.internet.tencent 'df -h /www/doc-record'
```

### 检查网络连接

```bash
# 测试端口
curl -I http://129.204.8.61:8080/doc-record/

# 从服务器内部测试
ssh fa.internet.tencent 'curl -I http://localhost:8080/doc-record/'
```

---

## 维护任务

### 清理旧镜像

Docker会积累旧镜像，定期清理：

```bash
ssh fa.internet.tencent 'docker image prune -a -f'
```

### 清理构建缓存

```bash
ssh fa.internet.tencent 'docker builder prune -a -f'
```

### 备份配置

```bash
# 备份配置文件到本地
scp fa.internet.tencent:/www/doc-record/nginx.conf ./backup/nginx.conf.$(date +%Y%m%d)
scp fa.internet.tencent:/www/doc-record/docker-compose.yml ./backup/docker-compose.yml.$(date +%Y%m%d)
```

---

## 故障排查

### 问题1: 网站无法访问

**症状**: 浏览器显示无法连接

**排查步骤**:
```bash
# 1. 检查容器是否运行
ssh fa.internet.tencent 'docker ps | grep doc-record'

# 2. 检查端口监听
ssh fa.internet.tencent 'ss -tlnp | grep 8080'

# 3. 检查nginx状态
ssh fa.internet.tencent 'docker exec doc-record nginx -t'

# 4. 查看日志
ssh fa.internet.tencent 'docker logs doc-record --tail 50'
```

### 问题2: 静态资源加载失败

**症状**: 页面无样式，控制台显示404

**排查步骤**:
```bash
# 1. 检查文件是否存在
ssh fa.internet.tencent 'docker exec doc-record ls -la /usr/share/nginx/html/assets/css/'

# 2. 检查nginx配置
ssh fa.internet.tencent 'docker exec doc-record cat /etc/nginx/conf.d/default.conf'

# 3. 测试具体文件
curl -I http://129.204.8.61:8080/doc-record/assets/css/styles.3b62a49d.css
```

**解决方案**: 重新构建并部署
```bash
npm run build
bash scripts/deploy-compose.sh
```

### 问题3: 容器频繁重启

**排查步骤**:
```bash
# 查看重启次数
ssh fa.internet.tencent 'docker ps -a | grep doc-record'

# 查看日志找���原因
ssh fa.internet.tencent 'docker logs doc-record --tail 100'
```

### 问题4: 内存/CPU占用过高

**排查步骤**:
```bash
# 查看资源使用
ssh fa.internet.tencent 'docker stats doc-record --no-stream'

# 如果nginx进程多
# 检查nginx worker配置
ssh fa.internet.tencent 'docker exec doc-record cat /etc/nginx/nginx.conf | grep worker'
```

---

## 性能优化

### 启用HTTP/2

编辑 `nginx.conf`:
```nginx
listen 80 http2;
```

### 调整Gzip压缩级别

编辑 `nginx.conf`:
```nginx
gzip_comp_level 6;  # 1-9，数字越大压缩率越高但CPU占用越高
```

### 增加缓存时间

编辑 `nginx.conf`:
```nginx
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
    expires 1y;  # 可以增加到更长时间
    add_header Cache-Control "public, immutable";
}
```

---

## 应急处理

### 紧急停止服务

```bash
ssh fa.internet.tencent 'docker stop doc-record'
```

### 快速恢复服务

```bash
ssh fa.internet.tencent 'docker start doc-record'
```

### 使用备用镜像

```bash
ssh fa.internet.tencent 'docker run -d -p 8080:80 --name doc-record-backup nginx:alpine'
```

---

## 定期检查清单

**每周**:
- [ ] 检查容器运行状态
- [ ] 检查日志是否有异常
- [ ] 测试网站可访问性

**每月**:
- [ ] 更新Docker镜像
- [ ] 清理旧镜像和缓存
- [ ] 备份配置文件

**每季度**:
- [ ] 审查nginx配置优化
- [ ] 检查安全更新
- [ ] 性能测试和优化

---

## 联系方式

- 仓库: `/Users/fa/dev/projects/other/temp/doc-record`
- 服务器: `fa.internet.tencent` (129.204.8.61:2222)
- 部署目录: `/www/doc-record`
