# Preparing Docker SSH environment... How to prepare for the environment? What's the reason ? How do I do it to use ssh's way to command a local docker to control the inner web docker via a docker

IDEA supports connecting to a remote Docker environment via SSH while using IntellliJ IDEA. When you see tips like "Preparing Docker SSH environment. ." in IDEA, IDEA is normally set up to communicate with a remote Docker most via SSH proxy.

## Preparation process for SSH environment

1. **Launch a remote Docker service**: First, you need to start the Docker service on a remote host, and make sure the SSH service is installed on a remote host.
2. **Configure the SSH key**: Requires a security SSH key between the local machine and the remote host (usally `id_rsa` and `id_rsa. ub`) to log in without a password.
3. **Set SSH Prox**: IDEA uses an internal tool named `idea-docker-ssh` to forward requests from the local Docker client to the docker service of the remote host via the SSH tunnel.
4. **Build a connection**: When IDEA details that you want to connect to a remote Docker environment via SSH, It automatically attempts to establish a connection using a configured SSH key and a host's IP address.

## Principles

- **SSH Tunnel**: Through SSH Tunnel technology, communications between local Docker clients and remote hosts are encrypted and forwarded.

- **Docker Remote API**: Once it connects via SSH, the local Docker client interface with the remote host docker service via the remote API.

## Locally controlled Intranet Docker via SSH

To use SSH for docker hosts in a locally controlled intranet, you need to make sure that the following conditions meet：

1. **Remote host configuration**:

   - Make sure the Docker service is running.
   - Make sure the SSH service on host is installed and allows log in without a password (via `ssh-copy-id` or `ssh-agent`).
   - Ensure that firewall and port forward settings allow SSH connections.
2. **Local Machine Configuration**:
   - Has a SSH key for a remote host.
   - Install and configure the `idea-docker-ssh` tool (using IDEA will handle this step automatically).
3. \*\*Configure in IDEA \*\*:
   - In IDEA, open "Preferences" (or "Settings") and fd Docker settings.
   - Configure the remote URL of Docker to the SSH protocol plus the IP address and port of the host. .g.： `ssh:/<user>@<host>:<port>`.
   - Enter your SSH key path if IDEA is not checked automatically.
4. **Connect and operate**:
   - When you complete the above settings, IDEA should be able to automatically create SSH connotations and Docker environments.
   - You should now be able to run the Docker command in IDEA and operate the container on the remote Docker host.

## Note

- Make sure you have access to remote hosts.
- Ensure that all operations meet the policies and safety standards of your organization.
- Protect your SSH key, not let it all into unfinished hands.
  In the course of the operation, if there is any uncertainty, It is recommended to consult more detailed official documentation or consult experienced developers.
