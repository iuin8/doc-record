# Remote interaction (idea uses gradle to remote server-publishing services to connect to arthas)

> **v1 Version Update**
> Date: 2025-10-13
>
> - Easy to act, double tap enough
> - Double-click to publish the specified service to the specified server and show the log in real time
>   - idea can connect to the log, click the class in the log to jump to specific code lines
>   - Unexpected group function and idea can only detect an exception starting with `Caused by:`
> - Double-click to show the log of the specified service in the specified server
>   - Maximum rows that the log behavior idea console can contain, followed by real time scrolling for new logs
> - Double tap to connect to the specified service in the specified server

## Follow Up Optimization

- The interactive experience of arthas, currently only interactive, needs to be reconnected
  - How to make the remote server recognize the `^c` mackey shortcuts I entered in idea.
- Add remote server connection function
- Automatically generate tasks for the environment based on the gradle environment attribute file, so simply add an environmental attribute file
- See how to put this full feature into a package in the Ari library to make it possible to introduce them by gradle dependency.

[相关配置文件地址](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/remote_interaction/v1)

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

The `build.gradle` file at the root of the project adds tasks (configuration in the address already provided above)

```bash
# Project root directory executes
mkdir scripts
# Add files from the above folder to (configuration already provided in the address above)
# and add config files and quotes code to the project root
```

```bash
# bash ./gradlew :pay-service:publishToTest --info
bash ./gradlew :pay-service:publishToTest
```

![gradle task example](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/remote_interaction/imgs/gradle_task.png?raw=true)

### View sql, Redis, es commands in conjunction with arthas commands

[参考查看sql命令地址](https://github.com/183461750/doc-record/blob/main/docs/materiel/article/arthas查看sql.md)
[参考查看sql_redis_es命令地址](https://github.com/183461750/doc-record/blob/main/docs/materiel/draft/arthas查看sql_redis_es.md)
