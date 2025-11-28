# sshuttle

[github地址](https://github.com/sshuttle/sshuttle)

```bash
# Installing
brew install sshuttle

# Locally executed commands to proxy
sshuttle --sudoers-user fa -r jump.local.container22 - sshuttle.fa.intranet.company 10.0.1.0/24
```

- Other advanced autoconfiguration parameters

```bash
# --dns capture local DNS requests and forward them to remote DNS server
sshuttle --sudoers-user fa-r mac.intranet.company 10.0.10. /24 --dns --method auto
# --auto-hosts continue to scan remote hostnames and update local /etc/hosts files when they are found.
# --auto-nots automatically determine routing subnet
sshuttle --sudoers-user fa -r mac. ntranet.company 10.0.10.0/24 --dns --method auto-hosts --auto-nets
# -D run
sshuttle --sudoers-user fa-r mac.intranet.company 10.0.0.0/24 --dns --method auto --auto-nots -D
```

- Best practices

```bash
# Only add the necessary configuration, and all others use default values for
sshuttle --dns --auto-hosts --auto-nets -D -r mac.intranet.company 10.0.0/24
# multi-grid segments, spaces separated, typically connect k8s to k8s, so that the k8s internal domain `svc can be properly parsed and accessed. luster.local` (or, if parsed, IP has no proxies, and has no access (PPS: this is important, the container segment needs to be proxy)
sshuttle --dns --auto-hosts --auto-nets -D -r mac.intranet.company 10.0.0.0.24 100.20.0.0.0.0/ 16 100.19.0.0/
```
