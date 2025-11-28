# Minutes

[官网](https://www.iepose.com/)

```bash
# 安装

## docker
# x86_64
docker run -d --net host --name owjdxb -v "$(pwd)/store:/data/store" --restart always ionewu/owjdxb
# arm_64
# docker run -d --net host --name owjdxb -v "$(pwd)/store:/data/store" --restart always ionewu/owjdxb_a64
docker run -d --net host --name owjdxb -v "./temp/store:/data/store" --restart always ionewu/owjdxb_a64

```

```bash
# Device Bind
# After launching the container, You can view the 6-bit device's code
# docker logs ionewu/owjdxb
docker logs owjdxb

```
