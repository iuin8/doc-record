# yapi

## Deployment

- [参考地址](https://github.com/fjc0k/docker-YApi)

```shell
git clone https://github.com/fjc0k/docker-YApi.git
# of a domestic image：
git clone https://gitee.com/fjc0k/dock-YApi.git
# Next, go into the docker-YApi directory and modify docker-compose. mMr YAPI_ADMIN_ACCOUNT for your administrator email and YAPI_ADMIN_PASSWORD for your administrator.
# YAPI_CLOSE_REGISTER=false set to false, then enable normal user registration

# Finally, execute docker-compose up -d launch service.

# Then access YApi is available at http://localhost:4001.
```
