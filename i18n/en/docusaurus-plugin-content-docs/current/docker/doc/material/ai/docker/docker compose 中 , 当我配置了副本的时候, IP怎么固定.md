# docker compose, how to fix the IP when I configure a copy

In Docker Compose, when copies are configured, the container IP address is dynamically assigned and cannot be fixed directly.However, a number of methods can be used to achieve effects similar to fixed IPs.

Below is a possible solution：

1. Create an Overlay network using the Overlay Network：and specify a custom subnet.In this way, it is possible to control the container's IP address range and avoid conflicting IP addresses assigned to the Docker engine [[3]](https://gist.github.com/olljanat/b96ed26583c452118313fc18e4a663c1).

   `````yaml
   version: "3.9"

   networks:
     mynetwork:
       driver: overlay
       ipam:
         config:
           - subnet: 10.0.0.0.24
   ````

   `````
2. Customize the Docker image：to create a custom Docker image that can set a fixed IP address when the container starts.The corresponding configuration can be added in Dockerfile, for example using iconfig commands to set the container IP address [[3](https://gist.github.com/olljanat/b96ed26583c452118313fc18e4a663c1).

   `````Dockerfile
   FROM ubuntu
   RUN apt-get update && apt-get install -y net-tools iputils-ping
   COPY start.sh /
   ENTRYPOINT /start.sh
   ```

   ````bash
   # start.sh
   #!/bin/bash
   if [[ -f "${STATIC_IP}" ]]; then
       echo "Using default IP from Docker"
   else
       echo "Found static IP: ${STATIC_IP}, using it"
       ifconfig eth0 ${STATIC_IP} netmask 255.255.255.0 up
   fi
   sleep infinity
   ```

   `````
3. Launch container：to launch the container in Docker Compose, using the `cap-add=NET_ADMIN` parameter and connect it to the Overlay network.By setting the `STATIC_IP` environment variable, the container IP address can be set to a fixed value [[3](https://gist.github.com/olljanat/b96ed26583c452118313fc18e4a663c1).

   ````yaml
   version: "3. "

   services:
     myservice:
       image: static-ip
       networks:
         - myetwork
       environment:
         - STATIC_IP=10. .0.11
       Deployment:
         replicas: 2
         placement:
           constraints:
             - node. whole == worder
   ```
   ````

Please note that the above solution offers only one possible method, and that the modalities of its implementation may vary according to the environment and need.Adjustments and tests are recommended on a case-by-case basis.

---

Learn more:

1. [Provide static IP to docker containers via docker-compose - Stack Overflow](https://stackoverflow.com/questions/39493490/provide-static-ip-to-docker-containers-via-docker-compose)
2. [It is used for fixing the ip of container for Swaziland after enabling the replication - Swarm - Docker Community Forums](https://forums.docker.com/t/it-is-useless-for-fixing-the-ip-of-container-for-swarm-after-enabling-the-replicas/121998)
3. [Overlay network and static IPs for Docker Containers GitHub](https://gist.github.com/olljanat/b96ed26583c452118313fc18e4a663c1)
