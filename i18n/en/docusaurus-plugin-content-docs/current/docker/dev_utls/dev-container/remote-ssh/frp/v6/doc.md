# frpc use record

## Quick Start

[docker-compose.yml链接](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/dev-container/remote-ssh/frp/v6/simple/docker-compose.yml)

```bash
# Launch sufficient to
docker-compose up -d
```

- Configuration Description

`auth_token_line=auth. oken = "xxx" ``` # Authenticating token, used to authenticate when the customer connects, just a sufficient value to
`serverAdd`# of the server addresses, use the address specified when the customer connects, Just a sufficient value sufficient to`server_port=18000`# of the server port, use the port specified when the customer connects, Adjust a sufficient value to `client_name=frpc`# of the client's name, for the name specified when the client connects to the client, and just a sufficient value (same fit for service that can have multiple frpc clients, as long as the name is not in conflict) `remotePort_proxies_tcp_line: remotePort=12222\\` # remote ports, For the port specified when the customer connects, add an appropriate value

> PS: In basically fixed server settings, simply copy the first client's dock-compose, modified `client_name`, `removePort_proxies_tcp_line`

- How to add a new frpc client (and get sshkey) when a frpc client is already connected

```bash
# Copy a dock-compose.yml file, modified by client_name and removePort_proxies_tcp_line (note in docker-compose. ml)

# Then sshit connection needs to get keys, Perform the following command to get the private key
docker exec -it dev-jumpbox cat ~/. sh/id_ed25519_frp
# needs to configure this private key to local ~/.ssh/id_ed25519_frp, and modify
chmod 600 ~/.ssh/id_ed25519_frp
```
