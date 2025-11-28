# Deploy docker-registration documentation

## Use Nginx proxy

- [参考文章](http://t.csdn.cn/36AL2)

```shell

upstream docker-registry {
    server registry:5000;
}

## Set a variable to help us decide if we need to add the
## 'Docker-Distribution-Api-Version' header.
## The registry always sets this header.
## In the case of nginx performing auth, the header is unset
## since nginx is auth-ing before proxying.
map $upstream_http_docker_distribution_api_version $docker_distribution_api_version {
'' 'registry/2.0';
}

server {
    listen 443 ssl;
    server_name hub.vic.com;

    # SSL
    ssl_certificate /etc/nginx/conf.d/ca.crt;
    ssl_certificate_key /etc/nginx/conf.d/ca.key;

    # Recommendations from https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
    ssl_protocols TLSv1.1 TLSv1.2;
    ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;

    # disable any limits to avoid HTTP 413 for large image uploads
    client_max_body_size 0;

    # required to avoid HTTP 411: see Issue #1486 (https://github.com/moby/moby/issues/1486)
    chunked_transfer_encoding on;

    location /v2/ {
        # Do not allow connections from docker 1.5 and earlier
        # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
        if ($http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {
            return 404;
        }

        # To add basic authentication to v2 use auth_basic setting.

        ## If $docker_distribution_api_version is empty, the header is not added.
        ## See the map directive above where this variable is defined.
        add_header 'Docker-Distribution-Api-Version' $docker_distribution_api_version always;

        proxy_pass                          http://docker-registry;
        proxy_set_header  Host              $http_host;   # required for docker client's sake
        proxy_set_header  X-Real-IP         $remote_addr; # pass on real client's IP
        proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header  X-Forwarded-Proto $scheme;
        proxy_read_timeout                  900;
    }
}
```

- Generate self-signed certificates

```shell
# Generate signatures to the conf.d directory for Nginx, execution of the following command in the conf. Directory at the parent directory with

# Create self-signed certificate keyfile
openssl genrsa - out conf. /ca. ey 2048
# Create a self-signed certificate crt note that in the docker-registry.iuin.xyz field the docker-registry. uin.xyz is changed to repository name
openl req -x509 - new -nodes -key conf. /ca.key -subj "Docker-registry.iuin.xyz" -days 5000 -out conf.d/ca. rt
# Set self-signed certificate
mkdir -p /etc/docker/certs/certs.d/docker-registry.iuin.xyz
cp conf.d/ca.crt /etc/docker/certs/certs.d/docker-registry.iuin.xyz

```

- Test

```shell
docker push busybox
docker tag busybox:latest docker-registry.iuin.xyz/busybox:1.0
docker push docker-registry.iuin.xyz/busybox:1.0

```
