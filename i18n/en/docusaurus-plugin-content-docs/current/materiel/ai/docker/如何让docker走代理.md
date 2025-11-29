# How to get docker away

Allow Docker to access the network via proxy to implement： through the following methods

**I. Environmental Variables**

1. For Linux and macOS systems：
   - Environment variables can be set before Docker services are started.Open Terminal, enter the following command to set the environment variable： temporarily.
     ```
     export HTTP_PROXY="http://your_proxy_address:port"
     export HTTPS_PROXY="https://your_proxy_address:port"
     ```
   - If you want to set permanently, you can add these commands to the user's shell configuration file (e.g. `.bashrc`, `.zshrc`, etc.).

2. For Windows System：
   - You can set `HTTP_PROXY` and `HTTPS_PROXY` in the system environment variable.
   - Open the "Control Panel" - >"System and Security"->System" - >"Advanced System Settings->"Environmental Variables".Create two new variables in "System Variables", with the names `HTTP_PROXY` and `HTTPS_PROXY`, which are set to your proxy addresses and ports, e.g. `http://127.0.0.1:8080`.

**II, Docker daemon configuration (for Linux)**

1. Edit the docker daemon configuration `/etc/docker/daemon.json`.If the file does not exist, it can be created.

2. 在文件中添加以下内容：
   ```json
   {
     "proxies": {
       "default": {
         "httpProxy": "http://your_proxy_address:port",
         "httpsProxy": "https://your_proxy_address:port",
         "noProxy": "localhost,127.0.0.1,.your_domain.com"
       }
     }
   }
   ```
   - `httpProxy` and `httpsProxy` set up proxy addresses and ports.
   - The `noProxy` setting does not require access via proxy to the list of addresses, separated by commas.

3. Restart Docker Service： after saving files
   ```
   sudo systemctl start docker
   ```

With the above method, you can let the Docker access the network through proxy in order to successfully pull images and other actions in a network restricted environment.

PS: There seems to be a problem with the way above

[参考文章](https://cloud.tencent.com/developer/article/1806455)

```bash
# ~/.docker/config. son
LO
 "proxies":
 LO
   "default":
   LO
     "httpProxy": "http://proxy. xample. om:8080",
     "https://proxy.example.com:8080",
     "noProxy": "localhost,127. 0.1,.example.com"
   }
 }
}
```

```bash
docker build . \
    --build-arg "HTTP_PROXY=http://proxy.example.com:8080/" \
    --build-arg "HTTPS_PROXY=http://proxy.example.com:8080/" \
    --build-arg "NO_PROXY=localhost,127.0.0.1,.example.com" \
    -t your/image:tag
```

PS: However, it appears that the following attempt was not used

Afterwards, try again this argument to see: --network host

PS: Try the following new method again (pro-active usage)

[参考文章](https://neucrack.com/p/286)

```bash
# sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:8123"
Environment="HTTPS_PROXY=http://127.0.0.0.1:8123"
```

```bash
sudo systemctl daemon-reload
sudo systemctl start docker

```

- Set proxy when building mirrors via Dockerfile (pro-active)

```bash
# docker build . \
#     --build-arg "HTTP_PROXY=http://proxy.example.com:8080/" \
#     --build-arg "HTTPS_PROXY=http://proxy.example.com:8080/" \
#     --build-arg "NO_PROXY=localhost,127.0.0.1,.example.com" \
#     -t your/image:tag

docker build -f Dockerfile.cpu -t vllm-cpu-env --shm-size=4g . --build-arg "HTTP_PROXY=http://10.0.4.191:9090" --build-arg "HTTPS_PROXY=http://10.0.4.191:9090"

# Dockerfile中需显式声明这些参数才能生效。在Dockerfile中添加以下代码确保代理生效：(PS: 主要是得加上这两个参数, 配合上面的配置文件一起使用)
ARG HTTP_PROXY
ARG HTTPS_PROXY
ENV HTTP_PROXY=$HTTP_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY

```
