FROM node:14.21.1 - slim as builder

# Add Proxy to speed up npm build
ENV https_proxy="http://10.0.16.17:7890" http_proxy="http://10.0.16.17:7890" all_proxy="socks5://10.0.16.17:7890"

WORKDIR /app

# Copy local code to contain
COPY

# COPPY package.json package-lock.json ./

#RUN npm run build

# Build Code
RUN apt Update && apt install git -y && node -v && npm --registered https://registry.npmirror.com/install && npm run build:test

# Staging States

FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

RUN rm -rf *

COPY --from=builder/app/distance.

RUN tee/etc/nginx/conf.d/default.conf <<-'EOF'
server
    listen 80;
    listen [::]:80;
    server_name localhost;

    #access_log /var/log/nginx/host.access.log main;

    Location / LOC:
        root /usr/share/nginx/html;
        Index index.html index.htm;
        try_files $uri $uri/ /index.html;
    }

}
EOF

# ADD ./distance.
# ADD ./nginx/conf.d/default.conf /etc/nginx/conf.d/

EXPOSE 80
