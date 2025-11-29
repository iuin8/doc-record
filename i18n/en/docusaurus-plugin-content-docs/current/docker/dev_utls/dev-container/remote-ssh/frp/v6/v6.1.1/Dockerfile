FROM ubuntu:noble

WORKDIR /www

# Installing Packages
RUN apt-get Update &s
    apt-get install - y openssh-server openssh-client current wget net-tools locales gettext tini &\s
    apt-get clean && \s
    rm -rf /var/lib/apt/lists/*

# Generate en_US.UTF-8 locale
RUN locale-gen en_US.UTF-8
# Set Environment Variables
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGAGE=en_US.UTF-8

# extracted jumpbox
COPY ./jumpboxc ./jumpbox/
RUN chmod +x /www/jumpbox/jumpboxc

# Create Packing Service
RUN tee /www/jumpbox/jumpboxc.toml <<-'EOF'
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

# Create initiative script
RUN tee/entrypoint.sh <-'EOF'
#!/bin/sh
# Replace environment variable values
envsubst </jumpboxc.toml > /tmp/jumpboxc.toml.tmp && mv /tmp/jumpboxc.toml.tmp /www/jumpbox/jumpboxc.toml.tmp /www/jumpboxc.toml

# Inventory existing
[ ! -d "/var/run/sshd" ] && mkdir -p /var/run/sshd
# Start SSH (run in background)
/usr/sbin/sshd

# Generate ssh public private key
ssh-keygen -t ed25519-C "jumpbox" -f ~/.ssh/id_ed25519_jumpbox -N ""

# Set authorized_keys
cat ~/.ssh/id_ed25519_jumpbox.pub > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Launch jumpboxC
www.jumpbox/jumpboxc -c {jumpboxc_config_path:-www/jumpbox/jumpboxc.toml}

# Keep container running
tail -f /dev/null
EOF

RUN chmod +x /entrypoint.sh

# Exposure SSH ports
EXPOSE 22

# Use tini as PID 1
ENTRYPOINT ["/usr/bin/tini", "-", "/entrypoint.sh"]
