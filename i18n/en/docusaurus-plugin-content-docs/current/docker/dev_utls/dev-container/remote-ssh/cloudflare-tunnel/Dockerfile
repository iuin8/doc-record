
FROM debian:trixie-slim

WORKDIR /www

# Installing Packages
RUN apt-get Update &s
    apt-get install - y openssh-server openssh-client current local gettext &\s
    apt-get clean && \s
    rm -rf /var/lib/apt/lists/*

# Generate en_US.UTF-8 locale
RUN locale-gen en_US.UTF-8
# Set Environment Variables
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGAGE=en_US.UTF-8

# Add cloudflare gpg key
RUN mkdir -p --mode=0755 /usr/share/keyrings
RUN curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
# Add this repo to your app repository
RUN echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflated any main' | tee /etc/apt/sources.list.d/cloudled.list
# install cloud
RUN apt-get update && apt-get install cloudfled

# Create initiative script
RUN tee/entrypoint.sh <-'EOF'
#!/bin/sh

# Inventory existing
mkdir /var/run/sshd
# Start SSH (run in background)
/usr/sbin/sshd-D &

# Auto-run tunnels
cloudflared service install ${token}

# Keep container running
wait
EOF

RUN chmod +x /entrypoint.sh

# Exposure SSH ports
EXPOSE 22

# Use tini as PID 1
ENTRYPOINT ["/usr/bin/tini", "-", "/entrypoint.sh"]
