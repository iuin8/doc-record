
FROM ubuntu:noble

WORKDIR /www

# Install Required Packages
RUN apt-get Update &\s
    apt-get install - y openssh-server openssh-client passwd curl wget text && \s
    apt-get clean && \s
    rm -rf /var/lib/apt/lists/*

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


# Create packing service
RUN tee/etc/systemd/frpc.service <-'EOF'
[Unit]
# names, customizable
Description = frp customer
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
# Command to launch frpc, change the installation path to your frpc
Execart = /www/frp/frpc-c /www/frp/frpc.toml

[Install]
WantedBy = multi-user.target
EOF

# Enable wrapping services
RUN systemctl enable frpc.service

# Create initialization script
RUN tee /usr/local/bin/init-container.sh <-'EOF'
#!/bin/bash
# Replace environment variable values
envsubst <//frpc.toml > /tmp/frpc.toml.tmp && mv /tmp/frpc.toml.tmp /www/frp/frpc.toml

# Start init
exec /usr/sbin/init
EOF

RUN chmod +x /usr/local/bin/init-container.sh

# Exposure SSH ports
EXPOSE 22

# Use initialized script as entry point
ENTRYPOINT ["/usr/local/bin/init-container.sh"]
