# Remote interaction (idea uses gradle to remote server-publishing services to connect to arthas)

> **v2 Version Update**
> Date: 2025-10-20.
>
> - Automatically generate tasks for the environment based on the gradle environment attribute file, so simply add an environmental attribute file

## Follow Up Optimization

- The interactive experience of arthas, currently only interactive, needs to be reconnected
  - How to make the remote server recognize the `^c` mackey shortcuts I entered in idea.

- See how to put this full feature into a package in the Ari library to make it possible to introduce them by gradle dependency.

[所有版本功能文档](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/remote_interaction/version.md)

## Use Instructions

```bash
vi ~/.ssh/config

# of Development Environment
Host xx.dev.iuin
  HostName 1.0.1.1
  User root
  IdentityFile ~/.ssh/id_ed25519_iu

```

```bash
# Updated environmental variable
project directory in `base.sh` from project: LOCAL_BASE_DIR="/Users/fa/dev/projects/IdeaProjects/company/iuin/mall/private-employ/xxxx-sbbc"
Remote service address: REMOTE_SERVER="xxx.dev.iuin"
Prefix : REMOTE_BABA_DIR="/data/xxxx"
```

### Combined gradle usage

[文档GitHub地址](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/remote_interaction/v2/doc.md)

Copy all files and folders in this document peer directory to the project root and refresh the gradient (link above can jump directly to the corresponding directory)

```bash
# bash ./gradlew :pay-service:publishToTest --info
bash ./gradlew :pay-service:publishToTest
```

![gradle task example](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/remote_interaction/imgs/gradle_task.png?raw=true)

### View sql, Redis, es commands in conjunction with arthas commands

[参考查看sql命令地址](https://github.com/183461750/doc-record/blob/main/docs/materiel/article/arthas查看sql.md)
[参考查看sql_redis_es命令地址](https://github.com/183461750/doc-record/blob/main/docs/materiel/draft/arthas查看sql_redis_es.md)
