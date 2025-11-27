# headscale docker composer usage record

```bash
# Port 8888 is the server port (via the polar proxy 8888 port -> https://5d37b78.r3.cpolar.top)
# Use headscale as the control server on the tailscale client of macos (press option, click on the taailscale icon, select debug->Customom Login Server->Add Account...->Enter https://5d37b78.r3.cpolar. op-> then automatically open browser -> Copy key> to server --> Execute the following command)
docker exec -it headscale headscale user create USERNAME
docker exec -it headscale headscale nodes register --user USERNAME --key qWrn3RY86bXG5BAcik7V7MoX
```

```bash
# linux clients (available on the server computer and used to connect to the server)
docker exec -it headscale head creation fa.iuin 
docker exec -it headscale preauthorkeys creation -e 24h --user fa. uin 
# Copy the above generated key to the following command
tailscale up --accept-dns=true --accept-rotes --login-server=http://127.0.0.1:8888--hostname=fa.iuin --force-reauth --authkey d69d58c00919035df704e7b3d867c1be022c038bc89be
```

```bash
# View Node
docker exec -it headscale headscale nodes list
# Delete node (via ID)
docker exc -it headscale headscale nodes delete --identier 3
# Rename node (via ID)
docker exec -it headscale headscale nodes name --identifier 4 hueigongyinglian
```

## Container uses host mode

Port can be replaced in config.yml if port conflicts
