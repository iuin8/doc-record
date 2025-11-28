FROM debian:trixie-slim

WORKDIR /www

# Install Required Packages
RUN apt-get Update &\s
    apt-get install - y openssh-server openssh-client current wget locales gettext tini python3 &\s
    apt-get clean && \s
    rm -rf /var/lib/apt/lists/*

# Generate and configure locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen &&\s
    locale-gen && \s
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Set Environment Variables
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGAGE=en_US.UTF-8

# extracted frp
COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz
RUN tar -xzf ./frp_0.62.1_linux_amd64.tar.gz && rm -rf ./frp_0.62.1_linux_amd64.tar.gz &\\s
    mv frp_0.62.1_linux_amd64 frp

# Create packing service
RUN tee /www/frp/frpc.toml <<-'EOF'
serverAddr = ${serverAddr}
serverPort = ${serverPort}
${auth_token_line}

[[${client_title}]]
name = ${client_name}
type = ${client_type}
${secretKey_stcp_line}
${localIP_proxies_line}
${localPort_proxies_line}
${serverName_visitors_line}
${bindAddr_visitors_line}
${bindPort_visitors_line}
${keepTunnelOpen_visitors_line}
${remotePort_proxies_tcp_line}
EOF

# Create initialization script
RUN tee/entrypoint.sh <-'EOF'
#!/bin/sh
# Replace environment variable values
envsubst <//frpc.toml > /tmp/frpc.toml.tmp && mv /tmp/frpc.toml.tmp /www/frp/frpc.toml

# Ensure directory exists
[ ! -d "/var/run/sshd" ] && mkdir -p /var/run/sshd
# Start SSH (run in background)
/usr/sbin/sshd

# Start FRPC
/www/frp/frpc-c${frpc_config_path:-www/frp/frpc.toml}

# Keep container running
tail -f /dev/null
EOF

RUN chmod +x /entrypoint.sh

# Exposure SSH ports
EXPOSE 22

# Use tini as PID 1
ENTRYPOINT ["/usr/bin/tini", "-", "/entrypoint.sh"]
