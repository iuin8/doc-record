# ssh+nginx implements Intranet pension

- Extranet server nginx configuration

```shell
# Create profile
tee/etc/nginx/conf.d/ssh. onf <<-'EOF'
server FM
    listen 80;
    listen [::]:80;
    server_name 127. .0.1 localhost 210.21.41.11;

    access_log /var/log/nginx/ssh_access. og main;

    location / 888
        proxy_pass http:///127.0.0. :8888;
    }

}
EOF

# Reload nginx configuration
nginx - s reload

## If nginx
# Mode 1
docker run --network=host -v /etc/nginx/conf. /ssh.conf:/etc/nginx/conf. /ssh.conf --rm nginx

# Mode II
# Installing nginx (docker install nginx)
docker run --network=host -it --rm nginx bash
# Execute command
nohup /docker-entrypoint. h nginx -g 'daemon off;' &
```

- Inner server ssh configuration

```shell
# My default on local loop addresses, you can specify ip or add -g parameters to open gateway mode
ssh -N -R 210. 1.48.69:192.168.3.14: 8888 ljf@210.21.4669 - p 10086
```
