# Change the password of the docker container and turn on ssh remote connection

To change the password of the Docker container and enable SSH remote connections, you need to make sure that a SSH server is running in the container.Below is an example based on the Ubuntu mirror, showing how to create a Docker container, install SSH servers, set a root password, and allow remote SSH connections.

1. Create a Dockerfile to build image： with SSH servers

```Dockerfile
# Use the official Ubuntu image
FROM ubuntu
# Install SSH server
RUN apt-get Update && apt-get install -y opensssh-server
RUN mdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin Prohibit-Password/PermitRoot Login yes////ssh/sshd_config
# Allow password authentication
RUN sed-i 's/#PasswordAuthorization yes/PasswordAuthentication yes/PasswordAuthentication yes// etc/ssh/sshd_config
# Open SSHport
EXPOSE 22
# Launch SSH
CMD ["/usr "-D"]
```

Please note that this Dockerfile uses a very simple password (`password`) as an example.In actual use, you should use a more complex password.
2. Build image： with Dockerfile.

```bash
Docker build - t my-ssh-image.
```

3. Run Container：

```bash
docker run -d -p 222:22 my-ssh-image
```

This command mapped 22 ports inside the container to the 2222 port of the host, so that you can access the container through the 2222 ports connected to the host.
4. Connect with SSH clients to container：

```bash
ssh root@<your-host-ip> - p 2222
```

Replace `<your-host-ip>` with your host's IP address.When you first connect, the SSH client may warn you that the new host identity cannot be verified, enter `yes` to continue.
5. If you need to change the root password of the running container, you can enter the container and use `passwd` to command：

```bash
docker exec -it <container-id> passwd
```

Replace `<container-id>` with your container ID.Follow the instructions to enter the new password.
Make sure you understand the security implications of these actions.In the production environment, additional security measures should be taken when using SSH to access containers, such as using SSH keys instead of passwords and restricting access to the container's IP address.In addition, the operation of SSH services may increase security risks and therefore make sure you are aware of these risks and take appropriate security measures.
