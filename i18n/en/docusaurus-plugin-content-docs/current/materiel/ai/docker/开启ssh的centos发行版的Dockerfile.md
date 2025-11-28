# Help me write a docker file and open ssh's remote connection requires centres distribution

To create a Dockerfile to build a CentS containing with SSH services, you can follow the following steps to move：

1. **Select the base image：** to select a CentS base image.
2. **Install SSH service：** install SSH services in containers (using `openssh-server`).
3. **Generate the SSH key：** to generate a new SSH key air for security purposes, avoiding using the default key.
4. **Set root password：** to set a root password or create a new user and set a password.
5. **Configure SSH service：** to configure SSH services such as allowing root logs or password authorization.
6. **Exposure SSH port：** to specified ports to be exposed in Dockerfile, using 22.
7. **Launch SSH service：** sets the SSH service to start automatically when the containing starts.
   Below is a simple Dockerfile example：

```Dockerfile
# 使用官方 CentOS 基础镜像
FROM centos:latest
# 安装 SSH 服务
RUN yum install -y openssh-server
# 生成 SSH 密钥
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
# 设置 root 密码
RUN echo "root:password" | chpasswd
# 配置 SSH 服务
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
# 暴露 SSH 端口
EXPOSE 22
# 启动 SSH 服务
CMD ["/usr/sbin/sshd", "-D"]
```

Note that this Dockerfile uses a simple password "password" as an example and should use a more complete password when actually used. lso, for security reasons, you may want to create a new user instance of using root for SSH connections.
Build Image：

```bash
Docker build -t cents-ssh.
```

Run the container and map the port：

```bash
docker run -d --name cents-ssh -p 222:22 cents-ssh
```

How you can use SSH server： from host to contain SSH clients

```bash
ssh root@localhost - p 2222
```

Enter a previous password to log in.
Please make sure you understand the security risks of the Docker containing the SSH service and configuration your security situation according to law.
