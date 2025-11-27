# Beauty vpn

[官网](https://pgy.oray.com)

```bash
# Mirror pulled
docker pull crpi-orhk6a4lutw1gb13.cn-hangzhou.personal.cr.ariyuncs.com/bestoray/pgyvpn
# Launch container
docker run -d --device=/dev/net/tun --net=host-cap-add=NET_ADMIN -env PGY_USERNAME="xxx" --env PGY_PASWORD="crpi-orhk6a4lutw1gb13.cn-hangzhou.personal.cr.aliyuncs. om/bestoray/pgyvpn

#II, instructions to use
# 1. The launch container must be field "--cap-add=NET_ADMIN", otherwise the virtual card creation failed, The group network could not contact
# 2, USERNAME options to support the input 'Beat' or 'UID'
# 3, the -v argument supported with docker uses the container volume
# # 4, the network debugging tools such as ping, ifconfig and others have been installed by default in the mirror, enabling users to use
# 5, log path：/var/log/oray
# 6, configuration path：/etc/oray/pgyvpn
```
