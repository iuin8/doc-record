# headscale

## Related Employment Configuration

- [服务端doc](https://github.com/183461750/doc-record/blob/main/docs/network/headscale/local/demo2/doc.md)
- [服务端docker-compose.yml](https://github.com/183461750/doc-record/blob/main/docs/network/headscale/local/demo2/docker-compose.yml)
- [客户端docker-compose.yml](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/tailscale/simple/docker-compose.yml)

## Use

- ssh connection

```bash
# ~/.ssh/config
Host bailscale-ssh.example.com
  HostName taile-ssh.example.com
  User root
  IdentityFile ~/.ssh/id_ed25519
  ForwardAgent yes
  # PasswordAuthentication password

```

```bash
# 可以通过用户名加headscale中配置的base_domain去访问其他节点的服务
# `hostname.base_domain` (e.g., _myhost.example.com_).
ssh tailscale-ssh.example.com
```
