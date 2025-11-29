# frp+ssh+docker access restricted network

Extract frp zips, rename the file in the frpc file to jumpboxc and use it for the copy command in Dockerfile

## Usage

```yaml

Services:
  dev-jumpbox:
    image: registry.cn-hangzhou.aliyuncs.com/iuin/dev-jumpbox:tcpmux-v6.1.
    container_name: dev-jumpbox
    environment:
      TZ: "Asia/Shanghai"
      serverAddr: '"183. 1.11. 1'
      serverPort: 11100
      auth_token: 'xx-jumpbox-ssh'
      client_name: '"container". rod.xxx.customer"'
      customDomains: '["container". rod.xxx.customer"]'
    extra_hosts:
      - "prod.xx.customer:host-gateway"
    restore: unless-stopped

```

Fields to adjust

- serverAddr: Server Address
- ServerPort: Server Port
- auth_token: Verify token
- client_name: client name
- customomDomains: Custom domains
- extra_hosts: additional custom container hosts configuration (optional)
