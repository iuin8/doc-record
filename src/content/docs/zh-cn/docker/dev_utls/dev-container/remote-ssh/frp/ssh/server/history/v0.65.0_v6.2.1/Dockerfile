FROM ubuntu:noble

WORKDIR /www

# 安装必要的软件包
RUN apt-get update && \
    apt-get install -y locales tini && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 生成 en_US.UTF-8 locale
RUN locale-gen en_US.UTF-8
# 设置环境变量
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# 添加jumpbox
COPY ./jumpboxs ./jumpbox/
RUN chmod +x /www/jumpbox/jumpboxs

# 创建初始化脚本
RUN tee /entrypoint.sh <<-'EOF'
#!/bin/sh

# 将 CONFIG 环境变量写入 jumpboxs.json
printf "%s" "$CONFIG" > /www/jumpbox/jumpboxs.json

# 启动 jumpboxs
/www/jumpbox/jumpboxs -c ${jumpboxs_config_path:-/www/jumpbox/jumpboxs.json}

# 保持容器运行
tail -f /dev/null
EOF

RUN chmod +x /entrypoint.sh

# 使用 tini 作为 PID 1
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
