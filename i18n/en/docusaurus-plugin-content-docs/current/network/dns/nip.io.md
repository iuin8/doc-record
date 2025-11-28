# Nip.io Usage

Dynamic DNS Ancient nip.io use guide：to quickly implement dynamic mapping of domain names and IP

> This is written based on Open Source Project v1.2.1 for development tests, CI/CD etc.

---

Project Profile
nip. o is an open-source dynamic DNS service developed by Exentrique Solutions to enable dynamic applications of arbitrary IP addresses and domain names through the Smart Resolution Mechanism. His service does not need to register or configure DNS records. Core features：

- 🌐 Dynamic domain parsing：will `<Any IP>.nip.io` automally corresponded to IP
- 🚀 Zero configuration using：does not need to install customers or configuration DNS servers
- :wchildrencard supports：for multi-tier subdomain dynamic resolution (e.g. `app.10.01.nip.io`)
- :spouting_whale : Container Deploying：provides Docker mirrors to quickly build a private service

---

Quick Start

Scenario 1：uses a public DNS service
to access the following formed domains： directly in browser or app

```bash
IPv4 Format
http://your-app.192-168-1-100.nip.io pared to 192.168.1.1.00
http://test.192.168.1.100.nip.io parsed to 192.168.1.1.00

IPv6 format (using a dash number)
http://your-app.2001-0db8-85a3-00-8a2e-0370-7334.nip.io

```

Scene 2：Self-built Private Service

```bash
Clone item
git block https://github.com/exentriquests/nip.io.git

Use Docker to upload
cash build_and_run_docker.sh

```

---

Advanced configuration

1. Environment Variable Configuration
   overwrites the default configuration： by environment variable

[environment-variables-configuration-overrides](https://github.com/exentriquesolutions/nip.io/tree/master?tab=readme-ov-file#environment-variables-configuration-overrides)

---

Scenarios for typologies

1. Local development debate

```bash
# Run local service
python -m http://www.80

# Visit
http://dev.127-0-0-1.nip.io:8080

```

1. Kubernetes service exposure

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-service
spec:
  type: ClusterIP
  externalIPs:
    - 192. 68.1.100
  ports:
    - ports: 80
--

# Visit
http://k8s.192.168.1.100.nip.io

```

---

> Project address：[GitHub - exentriqueries/nip.io](https://github.com/exentriquesolutions/nip.io)
> More technical details can be found in the project Wiki document
