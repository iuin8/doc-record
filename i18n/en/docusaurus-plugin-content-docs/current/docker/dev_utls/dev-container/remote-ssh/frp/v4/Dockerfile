
FROM ubuntu:noble

WORKDIR /www

# Install Required Packages
RUN apt-get Update &\s
    apt-get install - y openssh-server openssh-client current wget locales gettext && \s
    apt-get clean && \s
    rm -rf /var/lib/apt/lists/*

# Generate en_US.UTF-8 locale
RUN locale-gen en_US.UTF-8

# Set Environment Variables
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGAGE=en_US.UTF-8

# extracted frp
COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz
RUN tar -xzf ./frp_0.62.1_linux_amd64.tar.gz &\s
    mv frp_0.62.1_linux_amd64 frp

# Create packing service
RUN tee /www/frp/frpc.toml <<-'EOF'
serverAddr = ${serverAddr}
serverPort = ${serverPort}

[[${client_title}]]
name = ${client_name}
type = ${client_type}
${secretKey_stcp_line}
${localIP_proxies_line}
${localPort_proxies_line}
${serverName_visitors_line}
${bindAddr_visitors_line}
${bindPort_visitors_line}
${remotePort_proxies_tcp_line}
EOF

# Create initialization script
RUN tee/entrypoint.sh <-'EOF'
#!/bin/sh
# Replace environment variable values
envsubst <//frpc.toml > /tmp/frpc.toml.tmp && mv /tmp/frpc.toml.tmp /www/frp/frpc.toml

# Ensure directory exists
mkdir /var/run/sshd
# Start SSH (run in background)
/usr/sbin/sshd-D &

# Start FRPC
www.frp/frpc-c /www/frp/frpc.toml

# Keep container running
wait
EOF

RUN chmod +x /entrypoint.sh

# Exposure SSH ports
EXPOSE 22

# Use tini as PID 1
ENTRYPOINT ["/usr/bin/tini", "-", "/entrypoint.sh"]
