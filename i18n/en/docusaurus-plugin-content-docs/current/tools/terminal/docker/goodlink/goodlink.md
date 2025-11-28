# Direct link between the two hosts

[gitee仓库](https://gitee.com/konyshe/goodlink)

## docker boot

```bash
docker rm goodlink -f
# remote
docker run -d --name=goodlink --net=host --restoreet=always registry.cn-shanghai.aliyuncs. om/kony/foodlink --key=nas_202412140928
# local
docker run -d --name=goodlink --net=host --restore=always registry.cn-shanghai.aliyuncs. om/kony/foodlink --local=127.0. :18080 --key=nas_202412140928

# After the above two orders are executed, if connected, that is to say, Access all ports of the remote via proxy software such as clash to all ports
# Target: Configure proxy on home (or mission computer) browser: socks5:/127. 1.1:18080, visit all of the company's Intranet WEB, and lack of Viterate
# By default algorithms used at both remote and local, It may be incompatible with one end and the default algorithms if there is a situation that cannot be connected for more than 10 minutes at the local end, when you add the "--conn=1" option to replace the two-end algorithm
```

## Command Method

```bash
chmod +x ./goodlink-linux-amd64
./goodlink-linux-amd64 --key=nas_202412140928
./foodlink-linux-arm64 --local=127.0.0.0 :18080 --key=nas_202412140928
# of Background, collection logs to file (PS:2>&1 for redirecting standard errors to standard output, i. Writing into the Goodlink.log)
nohorl-link-link-amd64 --key=nas_2024122828 > /goodlink.log 2>&1
```

- Exception

- [参考文章](https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes)

```bash
sysctl -w net.core.rmem_max=7500000
sycctl-w net.core.wmem_max=750000
```
