# Use a docker from a remote server in idea to use a debug remote containing

> Benefits: Use a remote docker containing to reduce pressure on the local environment and reduce some of the worst tools (e). LibreOffice) that you need to re-install Java programs in your local environment

## Use Instructions

- Preparing remote docker server

```bash
# Edit file `~/.ssh/config`

Host fa.intranet.company
  HostName 10.0.11.111
  User root
  IdentitFile ~/.ssh/id_ed25519

```

![docker1](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/docker1.png?raw=true)
![docker2](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/docker2.png?raw=true)
![docker3](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/docker3.png?raw=true)

- Write Dockerfile

[参考文件地址](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/Dockerfile_local)

- idea configuration

Autogenate base configuration
by run![run](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/run.png?raw=true)

This click the edit configuration to automatically build the jar package and start the docker contact.

![edit1](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/edit1.png?raw=true)
![edit2](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/edit2.png?raw=true)

This is the time to process the configuration to run it. Click on it to bug the Java program in Docker.

- Add debug configuration

![debug1](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/debug1.png?raw=true)
![debug2](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/debug2.png?raw=true)
![debug3](https://github.com/183461750/doc-record/blob/main/docs/docker/dev_utls/remote_debug/imgs/debug3.png?raw=true)

This will make it possible to use the Java program in the remote docker containing in idea.
