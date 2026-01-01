
FROM ubuntu:noble

WORKDIR /www

# 安装必要的软件包
RUN apt-get update && \
    apt-get install -y openssh-server openssh-client curl wget net-tools locales gettext tini && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 生成 en_US.UTF-8 locale
RUN locale-gen en_US.UTF-8
# 设置环境变量
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# Add cloudflare gpg key
RUN mkdir -p --mode=0755 /usr/share/keyrings
RUN curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null
# Add this repo to your apt repositories
RUN echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | tee /etc/apt/sources.list.d/cloudflared.list
# install cloudflared
RUN apt-get update && apt-get install cloudflared

# 创建初始化脚本
RUN tee /entrypoint.sh <<-'EOF'
#!/bin/sh

# 设置默认值
# export token=${token:-'token'}

# 确保目录存在
[ ! -d "/var/run/sshd" ] && mkdir -p /var/run/sshd
# 启动 SSH（后台运行）
/usr/sbin/sshd

# 生成ssh公私钥
ssh-keygen -t ed25519 -C "container" -f ~/.ssh/id_ed25519_container -N ""

# 设置authorized_keys
cat ~/.ssh/id_ed25519_container.pub > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 自动运行隧道
# 服务方式运行
# 先卸载再安装，避免重复安装, 导致服务启动失败, 例如: 容器重启
cloudflared service uninstall
cloudflared service install ${token}
# 前台运行
# cloudflared --no-autoupdate tunnel --no-autoupdate run --protocol auto --token ${token}

# 保持容器运行
tail -f /dev/null
EOF

RUN chmod +x /entrypoint.sh

# 暴露 SSH 端口
EXPOSE 22

# 使用 tini 作为 PID 1
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
