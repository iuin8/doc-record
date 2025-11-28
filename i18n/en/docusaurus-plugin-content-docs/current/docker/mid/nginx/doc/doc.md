# Nginx

## Build nginx image

```shell
Docker build -t nginx:1.0.
```

## nginx default nginx.conf configuration path

```shell
cat etc/nginx/nginx.conf
cat etc/nginx/conf.d/default.conf
```

## Agent Jenkins

- [参考文章](http://t.csdn.cn/CUODV)

## Configure ssl Certificates

- nginx to see if http_ssl_module is installed

```shell
#Open nginx's sbin folder
cd /usr/local/nginx/sbin/nginx
#View whether to install
nginx -V

# If config arguments: --with-http_ssl_module, Installed (the next steps can skip and enter nginx. onf configuration)

```
