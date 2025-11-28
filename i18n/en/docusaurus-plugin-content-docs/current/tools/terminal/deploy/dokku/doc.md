# dokku

Feel not as good as it is, but record it

[github地址](https://github.com/dokku/dokku)

## Install

```bash
# download the installation script
wget -NP . https://dokku.com/bootstrap.sh
# run the installer
sudo DOKKU_TAG=v0.35.16 bash bootstrap.sh
# Configure your server domain
dokku domains:set-global dokku.me
# and your ssh key to the dokku user
PUBLIC_KEY="your-public-key-contents-here"
echo "$PUBLIC_KEY" | dokku ssh-keys:add admin
# create your first app and you're off!
dokku apps:create test-app
```

- Docker Installation

[参考地址](https://dokku.com/docs/getting-started/install/docker/)

```bash
docker container run -d \
  --env DOKKU_HOSTNAME=dokku.me \
  --env DOKKU_HOST_ROOT=/var/lib/dokku/home/dokku \
  --env DOKKU_LIB_HOST_ROOT=/var/lib/dokku/var/lib/dokku \
  --name dokku \
  --publish 3022:22 \
  --publish 8080:80 \
  --publish 8443:443 \
  --volume /var/lib/dokku:/mnt/dokku \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  dokku/dokku:0.35.16
```

- docker-composer installation

[参考地址](https://dokku.com/docs/getting-started/install/docker/)

## ssh connection

[参考地址](https://dokku.com/docs/getting-started/install/docker/)

```bash
docker exec -it dokku bash
echo "$CONTENTS_OF_YOUR_PUBLIC_SSH_KEY_HERE" | dokku ssh-keys:add KEY_NAME

# Host dokku.docker
#   HostName 127.0.0.1
#   Port 3022
```

## Use

```bash
# Create app
dokku apps:create my-first-app 
# View information
dokku apps:report my-first-app
# Deployment
dokku git:sync --build my-first-app https://github. om/dokku/smoke-test-app.git 
# Extend to
dokku ps:scale my-first-app web=2
```
