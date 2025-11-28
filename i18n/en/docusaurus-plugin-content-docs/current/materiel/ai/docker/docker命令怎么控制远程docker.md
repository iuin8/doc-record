# How the docker command controls the remote docker

To control remote docker examples, you need to make sure that the Docker daemon is running on a remote server and that the client has permission to communicate with it.The following are detailed steps：

## 1. Ensure that the remote Docker service is running

First, you need to confirm that the Docker daemon on the remote server is running.This can connect to the remote server via SSH and execute the following command to check：

```bash
ssh username@remote_server
docker ps
```

If the Docker is running, you should be able to see some listed containers.

## 2. Configure Docker Client

You may need to configure the Docker client to connect to the remote Docker daemon.This can be done by environmental variables or command line parameters.

### Use Environment Variables

You can specify the address of the Docker daemon by setting up the `DOCKER_HOST` environment variable.For example, if you know that the remote Docker daemon is listening to TCP on port 2376, you can set：

```bash
export DOCKER_HOST=tcp://remote_server:2376
```

To ensure that this environment variable can be used in subsequent SSH sessions, you can add it to your `~/.bashrc` or `~/.profile`.

### Use command line arguments

You can also specify the address of the Docker daemon every time you use the Docker command using the command line parameters, such as：

```bash
docker -H tcp://remote_server:2376 ps
```

## 3. Use SSH port forwards

To safely connect to a remote Docker daemon, you can do this via SSH port forwarding.On the SSH client, you can specify the Docker daemon port to forward the local port to the remote server.
For example, if you want to receive the Docker daemon data from the remote server on the 2376 port of the local machine, you can do this with：

```bash
ssh -L 2376:remote_server:2376 username@remote_server
```

Once this is done, you can run Docker commands on your local machine through `docker -H tcp://localhost:2376 ps`, which in fact will be forwarded via SSH tunnels to a remote Docker daemon.

## 4. Verify connection

Once you have completed the above configuration, you can verify that the settings are correct by running the Docker command and seeing whether you can successfully connect to the remote Docker daemon.

```bash
docker --host tcp://remote_server:2376 ps
```

If all is set correctly, you should be able to see a list of Docker containers on remote servers.

## Attention to security

When configuring remote Docker visits, make sure that appropriate security measures are taken.This may include limiting access to IP addresses of the Docker daemon (for example, authenticated via SSH key instead of password), using TLS certificate authentication, and setting passwords or key passwords when necessary.

## Use Docker Compose and Docker Machine (optional)

If you use Docker Compose on a remote server or manage Docker instance via Docker Machine, you need to ensure that the configuration file and settings also point to the right remote Docker daemon.
By following these steps, you should be able to effectively control docker instances on remote servers.Make sure you have enough permissions to start and run the Docker daemon process and follow best safety practices during the operation.
