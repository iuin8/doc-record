# frps usage record

Environment variable configuration for server bound port is added on v2

## Quick Start

[docker-compose.yml链接](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/frp/server/v3/simple/docker-compose.yml)

```bash
# Launch sufficient to
docker-compose up -d
```

- Configuration Description

`auth_token_line=auth.token = "xxx"` # authenticates token, used to authenticate on client connections, adjust a suitable value sufficient to
`bindPort=18000` # for the port specified when the client connects, adjust a suitable value sufficient
