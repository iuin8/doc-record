# foodlink usage records (v2.1.8)

[下载地址](https://gitee.com/konyshe/goodlink/releases/download/v2.1.8/goodlink-linux-amd64-cmd.zip)

```bash
# Download
wget https://gitee.com/konyshe/goodlink/releases/download/v2.1.8/goodlink-amd64-cmd.zip
# Add executive permission
chmod +x. goodlink-amd64-cmd
# local
./goodlink-amd64-cmd --key=AIabJpEHIHIYHMDIA6NBgOBboYJ1 - local
# remote
. foodlink-linux-amd64-cmd --key=AIabJpEIYHMDIA6NBgOBboYJ1 --remote
# # # # # remote(Docker)
docker rm goodlink -f; docker run -d --name=goodlink --net=host --restoret=always registry.cn-shanghai.aliyuncs.com/kony/gooodlink -key=AIabJpMDIA6NBGOBboYJ1 - remote

```

```bash

Services:
  dev-jumpbox:
    image: registry.cn-shanghai.aliyuncs. om/kony/foodlink
    container_name: foodlink
    # network_mode: host
    command: foodlink --key=AIabJpEIYHMDIA6NBgOBboYJ1 --remote
    environment:
      TZ: "Asia/Shanghai"
    extra_hosts:
      - "me. os:host-gateway"
    restore: unless-stopped

```
