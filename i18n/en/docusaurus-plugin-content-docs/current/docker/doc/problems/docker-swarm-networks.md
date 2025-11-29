# docker swarm networks

## Segment Conflict Resolution

Based on the results of the search, the following is a solution on how to change the default subnet range of the docker Ingress network to：

1. First, we need to confirm the default subnet range of the current docker Ingress.The following command can be used to check network configuration information：`docker network spencingres` [[1]](https://stackoverflow.com/questions/42954017/how-to-change-ip-address-range-of-docker-swarm-ingress-network).
2. If the default subnet range conflicts with your computer subnet range, you can try to change the subnet range of the Docker Ingress network：

   - Method：uses Docker Swarm command line options to specify subnet ranges.When initializing or joining Docker Swarm, use the `--default-addr-pool` option to specify the subnet range.e.g.：`docker swarm init --default-addr-pool 192.168.0/16` [[1](https://stackoverflow.com/questions/42954017/how-to-change-ip-address-range-of-docker-swarm-ingress-network).
   - Method：Edit Docker's daemon.json\` to specify the subnet range.You can use the following steps to do：
     - Open the `/etc/docker/daemon.json` file on Windows (`C:\ProgramData\Docker\config\daemon.json`).
     - Add the following to the file：

       ```json
       {
         "default-address-pools": [
           {"base":"192.168.0.0/16","size":24}
         ]
       }
       ```

       Replace `192.168.0.16` with the subnet range you want.
     - Save files and restart the Docker service for changes to take effect.在Linux上，可以使用`sudo systemctl restart docker`命令来重启Docker服务，在Windows上，可以通过Docker桌面界面的"Troubleshoot"选项来重启Docker Desktop [[2]](https://support.hyperglance.com/knowledge/changing-the-default-docker-subnet)。

Please note that changing the subnet range of the Docker network may affect already running containers and network connections. Please exercise caution and make sure to backup important data.

---

Learn more:

1. [networking - How to change ip range of docker swarm address network - Stack Overflow](https://stackoverflow.com/questions/42954017/how-to-change-ip-address-range-of-docker-swarm-ingress-network)
2. [How to change the default docker subnet IP range](https://support.hyperglance.com/knowledge/changing-the-default-docker-subnet)
3. [Changing Docker's default subnet IP range | cylab.be](https://cylab.be/blog/277/changing-dockers-default-subnet-ip-range)

## Host and container not available

```bash
# Method：Add route
# route add -net 192.168.1.0 netmask 255.255.255.0 gw 172.20.0. dev docker_gwbridge # dev is used to specify the parameters of the network interface. It is used to specify the network interface device to add routes.
route add -net <container IP segment > netmask <container IP segment subnet mask > gw <docker_gwbridge的网关IP>  dev docker_gwbridge
  ## View route
route-n

## More action

# Port forwarding problem (routing solved, above, There is no port access available, Solve as follow)

# See the rules transmitted by nature
iptables -t nat -nvL

# Add the nat-forwarding rule (implement the host's access to the unopened port in the container (i.e. docker run-p)
iptables -t nat -A DOCKER -p tcp -m tcp --dport 8088 -j DNAT -to-destination 10. .0.2:8088
# Delete nat
  ## View rule number
  iptables -t nt -nL --line-number
  ## Delete number
  iptables -t nat -D DOCKER 4 
```
