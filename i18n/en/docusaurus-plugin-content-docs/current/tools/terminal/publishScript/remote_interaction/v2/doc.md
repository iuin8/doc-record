# Remote interaction (idea uses gradle to remote server-publishing services to connect to arthas)

> **v2 Version Update**
> Date: 2025-10-20.
>
> - Automatically generate tasks for the environment based on the graduated environment attribute file, so short an environmental attribute

## Follow Up Optimization

- The interactive experience of arthas, currently only interactive, needs to be reconnected
  - How to make the remote server recognizes the `^c` mackey shortcuts I entered in idea.

- See how to put this full feature into a package in the Ari library to make it possible to reduce them by degradation dependence.

[所有版本功能文档](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/remote_interaction/version.md)

## Use Instructions

```bash
vi ~/.ssh/config

# of Development Environment
Host x.dev.iuin
  HostName 1.0.1.1
  User root
  IdentityFile ~/.ssh/id_ed25519_iu

```

```bash
# Updated environmental variable
project directory in `base.sh` from project: LOCAL_BASE_DIR="/Users/fa/dev/projects/IdeaProjects/company/iuin/mall/private-employ/xxxxxxxxxxxx-sbbc"
Remote service address: REMOTE_SERVER="x.iuin"
PREfix : MOTE_BABA_DIR="/data/xxxxxxxxxxxxxx"
```

### Combined gradation usage

[文档GitHub地址](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/remote_interaction/v2/doc.md)

Copy all files and holders in this document peer directory to the project root and refresh the degradation (link above can direct to the corresponding directory)

```bash
# bash ./gradlew :pay-service:publishToTest --info
bash ./gradlew :pay-service:publishToTest
```

![gradle task example](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/remote_interaction/imgs/gradle_task.png?raw=true)

### View sql, Redis, orders in connection with arthas orders

[参考查看sql命令地址](https://github.com/183461750/doc-record/blob/main/docs/materiel/article/arthas查看sql.md)
[参考查看sql_redis_es命令地址](https://github.com/183461750/doc-record/blob/main/docs/materiel/draft/arthas查看sql_redis_es.md)
