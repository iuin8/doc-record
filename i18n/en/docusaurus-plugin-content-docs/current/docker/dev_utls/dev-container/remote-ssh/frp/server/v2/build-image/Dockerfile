FROM ubuntu:noble

WORKDIR /www

# Install Required Packages
RUN apt-get Update &\s
    apt-get install - y openssh-server openssh-client current wget text && \s
    apt-get clean && \s
    rm -rf /var/lib/apt/lists/*

COPY ./frp_0.62.1_linux_amd64.tar.gz ./frp_0.62.1_linux_amd64.tar.gz
RUN tar -xzf ./frp_0.62.1_linux_amd64.tar.gz &\s
    mv frp_0.62.1_linux_amd64 frp

# Create packing service
RUN tee /www/frp/frps.toml <<-'EOF'
bindPort = 7000

sshTunnelGateway.bindPort = 2222
# sshnelGateway.privateKeyFile = ""
# sshTunnelGateway.autoGenPrivateKeyPath = ""
# sshnelGateway.authorizedKeysFile = "~/.ssh/authorized_keys"

# auth.token = "xxxx"
${auth_token_line}
EOF


# Create initialization script
RUN tee/entrypoint.sh <-'EOF'
#!/bin/sh
# Replace environment variable values
envsubst <//frps.toml > /tmp/frps.toml.tmp && mv /tmp/frps.toml.tmp /www/frp/frps.toml

# Ensure directory exists
[ ! -d "/var/run/sshd" ] && mkdir -p /var/run/sshd
# Start SSH (run in background)
/usr/sbin/sshd

# Start FRPC
/www/frp/frps-c /www/frp/frps.toml

# Keep container running
tail -f /dev/null
EOF

RUN chmod +x /entrypoint.sh

# Exposure SSH ports
EXPOOSE 7000

# Use tini as PID 1
ENTRYPOINT ["/usr/bin/tini", "-", "/entrypoint.sh"]
