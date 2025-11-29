# frps use record

The `tcpmuxHTTPConnect Port` parameter is added on a v3 basis for a port that supports multiple ssh connotations

## Quick Start

[v3 doc](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/frp/server/v3/doc.md)

[network_mode (currently used)](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/frp/server/v4/simple/network_mode/docker-compose.yml)

```bash
# Launch sufficient to
docker-compose up -d
```

- Configuration Description

`7000`Port # Server port, used to specify port when the customer connects, promote a sufficient value for
`5002`Port # for multiple ssh' connections, Just a sufficient value to
`auth_token` # authate token, authenticate on customer connections, add a sufficient value
