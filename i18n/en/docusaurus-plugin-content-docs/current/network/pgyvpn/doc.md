# Beauty vpn

[官网](https://pgy.oray.com)

```bash
# Mirror pulled
docker pull crpi-orhk6a4lutw1gb13.cn-hangzhou.personal.cr.cr.ariyuncs.com/bestoray/pgyvpn
# Launch container
docker run -d --dev/net/tun -net=host-cap-add=NET_ADMIN -env PGY_USERNAME="-env PGY_PASWARD="crpi-orhk6a4lutw1gb13. n-hangzhou.personal.cr.aliyuncs. om/bestoray/pgyvpn

#II, instructions to use
# 1. The launcher must be field "--cap-add=NET_ADMINDE", otherwise the virtual card creation failed, The group network could not contact
# 2, USERNAME options to support the input 'Beat' or 'UID'
# 3, The -v arrow supported with docker uses the container volume
# # 4, The network debugging tools such as ping, ifconfig and others have been installed by default in the mirror, enabling users to use
# 5, log path：/var/log/oray
# 6, configuration path：/etc/oray/pgyvpn
```
