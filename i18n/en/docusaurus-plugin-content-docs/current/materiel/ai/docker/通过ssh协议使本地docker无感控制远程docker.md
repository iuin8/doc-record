# Preparing Docker SSH environment... how to prepare for the environment? What's the reason? How do I do it to use ssh's way to command a local docker to control the inner web docker via docker

IDEA supports connecting to a remote Docker environment via SSH while using IntelliJ IDEA.When you see tips like "Preparing Docker SSH environment..." in IDEA, IDEA is normally set up to communicate with a remote Docker host via SSH proxy.

## Preparation process for SSH environment

1. **Launch a remote Docker service**: First, you need to start the Docker service on a remote host, and make sure the SSH service is installed on a remote host.
2. **Configure the SSH key**: Requires a security SSH key between the local machine and the remote host (usually `id_rsa` and `id_rsa.pub`) to log in without a password.
3. **Set SSH Prox**: IDEA uses an internal tool named `idea-docker-ssh` to forward requests from the local Docker client to the docker service of the remote host host via the SSH tunnel.
4. **Build a connection**: When IDEA detects that you want to connect to a remote Docker environment via SSH, it automatically attempts to establish a connection using a configured SSH key and a host's IP address.

## Principles

- **SSH Tunnel**: Through SSH Tunnel technology, communications between local Docker clients and remote hosts are encrypted and forwarded.

- **Docker Remote API**: Once connected via SSH, the local Docker client interacts with the remote host docker service via the remote API.

## Locally control Intranet Docker via SSH

To use SSH for docker hosts in a locally controlled intranet, you need to make sure that the following conditions meet：

1. **Remote host configuration**:

   - Make sure the Docker service is running.
   - Make sure the SSH service on host is installed and allows login without a password (via `ssh-copy-id` or `ssh-agent`).
   - Ensure that firewall and port forward settings allow SSH connections.
2. **Local Machine Configuration**:
   - Has a SSH key for a remote host.
   - Install and configure the `idea-docker-ssh` tool (usually IDEA will handle this step automatically).
3. \*\*Configure in IDEA \*\*:
   - In IDEA, open "Preferences" (or "Settings") and find Docker settings.
   - Configure the remote URL of Docker to the SSH protocol plus the IP address and port of the host.e.g.： `ssh:/<user>@<host>:<port>`.
   - Enter your SSH key path if IDEA is not detected automatically.
4. **Connect and operate**:
   - When you complete the above settings, IDEA should be able to automatically create SSH connections and Docker environments.
   - You should now be able to run the Docker command in IDEA and operate the container on the remote Docker host.

## Note

- Make sure you have access to remote hosts.
- Ensure that all operations meet the policies and safety standards of your organization.
- Protect your SSH key, not let it fall into unauthorized hands.
  In the course of the operation, if there is any uncertainty, it is recommended to consult more detailed official documentation or consult experienced developers.
