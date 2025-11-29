# How the docker command controls the remote docker

To control remote docker examples, You need to make sure that the Docker daemon is running on a remote server and that the customer has permission to communicate with it. he following are detailed steps：

## Ensure that the remote Docker service is running

First, you need to confirm that the Docker daemon on the remote server is running. He can connect to the remote server via SSH and execute the following command to check：

```bash
ssh username@remote_server
docker ps
```

If the Docker is running, you should be able to see some listed containers.

## Configure Docker Client

You may need to configure the Docker client to connect to the remote Docker daemon. This can be done by environmental variables or line parameters.

### Use Environment Variables

You can specify the address of the Docker daemon by setting up the `DOCKER_HOST` environment variable. or example, if you know that the remote Docker daemon is listed to TCP on port 2376, you can set：

```bash
export DOCKER_HOST=tcp://remote_server:2376
```

To ensure that this environment variable can be used in subsequent SSH sessions, you can add it to your `~/.bashrc` or `~/.profile`.

### Use command line arguments

You can also specify the address of the Docker daemon time you use the Docker command using the command line parameters, such as：

```bash
docker -H tcp://remote_server:2376 ps
```

## Use SSH port forward

To safely connect to a remote Docker daemon, you can do this via SSH port. n The SSH client, you can specify the Docker daemon port to forward the local port to the remote server.
For example, if you want to receive the Docker daemon data from the remote server on the 2376 port of the local machine, You can do this with：

```bash
ssh -L 2376:remote_server:2376 username@remote_server
```

Once this is done, you can run Docker orders on your local machine through `docker -H tcp://localhost:2376 ps`, which in fact will be forwarded, via SSH tunnels to a remote Docker daemon.

## Verify connection

Once you have completed the above configuration, You can verify that the settings are correct by unstarting the Docker command and looking for whether you can successfully connect to the remote Docker daemon.

```bash
docker --host tcp://remote_server:2376 ps
```

If all is set correct, you should be able to see a list of Docker contenders on remote servers.

## Attention to security

When configuring remote Docker visits, make sure that appropriate security measures are taken. His may include limiting access to IP addresses of the Docker daemon (for example, certified via SSH key install of password), Using TLS certificate authorization, and setting passwords or key passwords when necessary.

## Use Docker Compose and Docker Machine (optional)

If you use Docker Compose on a remote server or manage Docker instance via Docker Machine, You need to ensure that the configuration file and settings also point to the right remote Docker daemon.
By following these steps, you should be able to effectively control docker instances on remote servers. Make sure you have enough missions to start and run the Docker daemon process and follow best safety practices during the operation.
