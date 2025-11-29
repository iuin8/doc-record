# foodlink usage records (v2.1.8)

[下载地址](https://gitee.com/konyshe/goodlink/releases/download/v2.1.8/goodlink-linux-amd64-cmd.zip)

```bash
# Download
wget https://gitee.com/konyshe/goodlink/releases/download/v2.1.8/goodlink-amd64-cmd.zip
# Add executive permission
chmod +x. goodlink-amd64-cmd
# local
./goodlink-amd64-cmd --key=AIabJpEHHIHHIYHMDIA6NBgOBboYJ1 - local
# remote
foodlink-linux-amd64-cmd --key=AIabJpEIYHMDIA6NBgOBboYJ1 --remote
# # # # # # # # # # # remote
docker rm foodlink -f; docker run -d --name=goodlink --net=host --restoreret=always registry. n-shanghai.aliyuncs.com/kony/gooodlink -key=AabJpMDIA6NBGOBboYJ1 - remote

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
