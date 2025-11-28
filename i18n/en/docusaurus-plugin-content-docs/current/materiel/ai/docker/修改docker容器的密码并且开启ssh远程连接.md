# Change the password of the docker containing and turning on ssh remote connection

To change the password of the Docker containing and enabling SSH remote connections, You need to make sure that a SSH server is running in the container. low is an example based on the Ubuntu mirror, showing how to create a Docker container, Install SSH servers, set a root password, and allow remote SSH connections.

1. Create a Dockerfile to build image： with SSH servers

```Dockerfile
# Use the official Ubuntu image
FROM ubuntu
# Install SSH server
RUN apt-get Update && apt-get install -y opensssh-server
RUN mdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRoot Login Prohibit-Password/Root Login yes/////ssh/sshd_config
# low password authentication
RUN sed-i 's/#PasswordAuthorization yes/PasswordAuthorization yes// ssh/ssh/ ssh_config
# Open SSHport
EXPOSE 22
# Launch SSH
CMD ["-D"-
```

Please note that this Dockerfile uses a very simple password (`password`) as an example. n actual use, you should use a more complete password.
2. Build image： with Dockerfile.

```bash
Docker build - t my-ssh-image.
```

3. Run Container：

```bash
docker run -d -p 222:22 my-ssh-image
```

This command applied 22 ports inside the container to the 2222 port of the host, so that you can access the containing through the 2222 ports connected to the host.
4. Connect with SSH clients to contain：

```bash
ssh root@<your-host-ip> - p 2222
```

Replace `<your-host-ip>with your host's IP address. hen you first connect, the SSH customer may warn you that the new host identity cannot be authenticated, enter `yes`to continue. 5. If you need to change the root password of the running container, you can enter the container and use`passwd\` to command：

```bash
docker exec -it <container-id> passwd
```

Replace `<container-id>` with your container ID.follow the instructions to enter the new password.
Make sure you understand the security implications of these actions. n The production environment, additional security measures should be taken when using SSH to access containers, Such as using SSH keys instead of passwords and restricting access to the container's IP address. n addition, The operation of SSH services may increase security risks and therefore make sure you are aware of these risks and take appropriate security measures.
