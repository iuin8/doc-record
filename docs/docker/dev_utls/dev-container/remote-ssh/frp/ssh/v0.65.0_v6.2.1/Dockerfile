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

# 添加jumpbox
COPY ./jumpboxc ./jumpbox/
RUN chmod +x /www/jumpbox/jumpboxc

# 创建 ~/.ssh 目录并设置权限
RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

# 创建初始化脚本
RUN tee /entrypoint.sh <<-'EOF'
#!/bin/sh

# 将 CONFIG 环境变量写入 jumpboxc.json
printf "%s" "$CONFIG" > /www/jumpbox/jumpboxc.json

# 确保目录存在
[ ! -d "/var/run/sshd" ] && mkdir -p /var/run/sshd
# 启动 SSH（后台运行）
/usr/sbin/sshd

# 生成ssh公私钥
ssh-keygen -t ed25519 -C "container" -f ~/.ssh/id_ed25519_container -N ""

# 添加默认公钥
cat ~/.ssh/id_ed25519_container.pub >> ~/.ssh/authorized_keys

# 启动 jumpboxC
/www/jumpbox/jumpboxc -c ${jumpboxc_config_path:-/www/jumpbox/jumpboxc.json}

# 保持容器运行
tail -f /dev/null
EOF

RUN chmod +x /entrypoint.sh

# 暴露 SSH 端口
EXPOSE 22

# 使用 tini 作为 PID 1
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
