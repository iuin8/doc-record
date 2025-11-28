# ipsec-vpn

## What is IPsec VPN?

IPsec, Internet Protocol Security, is a protocol for the protection of Internet protocol (IP) transmission of data.VPN, on the other hand, is a dedicated network based on a public network that allows for secure data transfer.IPsec VPN, in combination with the advantages of both, can create a virtual private network in the public network to secure communications between different locations, including remote working, resource-sharing, etc.

## Build IPsec VPN Server with Docker

### Server

Planning vpn configuration information

- /data/jump/vpn/.env configuration information for vpn

```shell
VPN_IPSEC_PSK=password1!
# 配置用于登陆VPN的账号和密码
VPN_USER=vpn
VPN_PASSWORD=vpn1234
# 如下应该填写本机的外网IP（服务器ip）
VPN_PUBLIC_IP=36.111.179.*
# 配置额外的用户名和密码
VPN_ADDL_USERS=vpn1 vpn2
VPN_ADDL_PASSWORDS=vpn11234 pass21234
#DNS配置
VPN_DNS_SRV1=8.8.8.5
VPN_DNS_SRV2=114.114.114.114
```

Start VPN service

```shell
docker run 
    --name ipsec-vpn-server
    --env-file /data/jump/vpn/. nv 
    --restore=always \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -v /lib/modules:/lib/modules:ro
    -d --prieged
    hwdsl2/ipsec-vpn-server
```

View Info

```shell
# View VPN connection information
docker logs-f ipsec-vpn-server
# View client connections, ipallocation, usage of traffic etc
docker exec -it ipsec-vpn-server ipsec whack --traffickstatus
```

### Client

Client Connection VPN General Configuration (phone, computer)

```shell
#不同设备实际需要填写的信息会有略微不同，但是关键信息为以下几个配置
VPN类型：IPSec
服务器：vpn服务器的ip，不需要端口
密钥：配置信息中的IPSec PSK
用户名、密码：配置信息中的username、password
```

## Related Articles

- [一套好用的VPN](https://mp.weixin.qq.com/s/iKOaRoSwbA5Nz667uk-jRA)
- Private articles
  - [package](https://gitee.com/LFa/doc/raw/master/me/records/soft/vpn/openVPN/pakage/doc.md)
