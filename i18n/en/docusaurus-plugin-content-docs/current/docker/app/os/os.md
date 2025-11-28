# Deploying system documentation in docker containing

## win system

- Mode one: `docker-compose.yml`

- Mode two: `docker run`

  ```shell
  docker run -it --rm -p 8006:806 --device=/dev/kvm --cap-add NET_ADMIN --stop-timeout 120 dockurr/windows.
  ```

- Related Articles
  - [开源地址](https://github.com/dockur/windows)

## Install visualized viral machines in Linux

- Beta

[参考文章](https://github.com/quickemu-project/quickemu/wiki/01-Installation)
[参考文章](https://mp.weixin.qq.com/s/W99irRFN5geQ5wHr2i4y2w)

```bash
# unsucessful... Can system does not support
yum install -y dnf

sudo dnf install cash core uses curl edk2-tools genisoimage grep jq mesa-demos pciuulls processes python3 qemu sed socat spice-gtk-tools swtpm unzip usbutil-linux xdg-users-dirs xrandr zsync

git class https://github. om/quickemu-project/quickemu.git

```
