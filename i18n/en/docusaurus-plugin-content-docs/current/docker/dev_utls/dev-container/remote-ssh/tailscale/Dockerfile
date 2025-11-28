FROM ubuntu:noble

WORKDIR /www

# Installing Packages
RUN apt-get Update &s
    apt-get install - y openssh-server openssh-client passwd curl wget text && \s
    # Install tailscale
    curl -fsSL https://tailscale.com/install.sh | sh && \s
    apt-get clean && \s
    rm -rf /var/lib/apt/lists/*

# Configure SSH (optional)
RUN mkdir /var/run/sshd &&\s
    echo 'root:password' | chpasswd && \s
    sed-i 's/#PermitRootLogin Prohibit-password/PermitRoot Login yes/'/etc/ssh/sshd_config &&&&\s
    Identified -i 's/#PasswordAuthentication no/PasswordAuthentication yes/'/etc/ssh/sshd_config


# Create Startup Script
RUN tee /usr/local/bin/start-tailscale.sh <-'EOF'
#!/bin/bash
tailscale up --accept-dns=true --accept-routes --login-server=${login_server} --hostname=${hostname} --force-reauth  --authkey ${authkey}
EOF

# Create Packing Service
RUN tee/etc/systemd/system/tailscale.service <-'EOF'
[Unit]
# names, customizable
Description = tailscale
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
# Command to launch, change the installation path to your tailscale
ExecStart=/usr/local/bin/start-tailscale.sh

[Install]
WantedBy = multi-user.target
EOF

# Enable wrapping services
RUN systemctl enable tailscale.service


# Exposure SSH ports
EXPOSE 22
# Start ssh and polar services
# ENTRYPOINT [ "/usr/sbin/init" ]


# Create initiative script
RUN tee /usr/local/bin/init-container.sh <-'EOF'
#!/bin/bash
# Replace environment variable values
envsubst < /usr/local/bin/start-tailscale.sh > /tmp/start-tailscale.tmp &&&&\s
    mv /tmp/start-tailscale.tmp /usr/local/bin/start-tailscale.sh &\s
    chmod +x /usr/local/bin/start-tailscale.sh

# Start Init
exec /usr/sbin/init
EOF

RUN chmod +x /usr/local/bin/init-container.sh

# Use initialized scripts as entry point
ENTRYPOINT ["/usr/local/bin/init-container.sh"]
