FROM ubuntu:noble

WORKDIR /www/.jumpboxc

# 安装必要的软件包
RUN apt-get update && \
    apt-get install -y openssh-server openssh-client curl wget locales tini && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 生成 en_US.UTF-8 locale
RUN locale-gen en_US.UTF-8
# 设置环境变量
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# 添加jumpboxc
COPY ./jumpboxc /www/.jumpboxc/bin/
RUN chmod +x /www/.jumpboxc/bin/jumpboxc

# 创建 ~/.ssh 目录并设置权限
RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

# 创建初始化脚本
RUN tee /entrypoint.sh <<-'EOF'
#!/bin/sh

# 确保目录存在
[ ! -d "/var/run/sshd" ] && mkdir -p /var/run/sshd
# 启动 SSH（后台运行）
/usr/sbin/sshd

# 生成ssh公私钥
ssh-keygen -t ed25519 -C "jumpboxc" -f ~/.ssh/id_ed25519_jumpboxc -N ""

# 添加默认公钥
cat ~/.ssh/id_ed25519_jumpboxc.pub >> ~/.ssh/authorized_keys

# 将 CONFIG 环境变量写入配置文件
printf "%s" "$CONFIG" > /www/.jumpboxc/jumpboxc.yml

# 启动客户端
/www/.jumpboxc/bin/jumpboxc start-all -config=/www/.jumpboxc/jumpboxc.yml

# 保持容器运行
tail -f /dev/null
EOF

RUN chmod +x /entrypoint.sh

# 暴露 SSH 端口
EXPOSE 22

# 使用 tini 作为 PID 1
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
