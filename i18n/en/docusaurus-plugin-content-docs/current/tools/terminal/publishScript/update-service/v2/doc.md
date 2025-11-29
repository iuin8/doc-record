# Quick Publish Service: with idea and gradle

> **v2 Version Update**
> Date: 2025-09-19
>
> - Priority use bootJar's jar file when there is a bootJar task
> - When gradle is used, you no longer need to configure the `LOCAL_BASE_DIR` environment variable to get it automally
> - Change service command to systemctl (because the new jar service is managed by systemctl, and the systemctl launch configuration assigns a user to start)

- Support for updates from the specified service
- Support for updating all services
- Process service JAR file upload and remote launch
- Support area and grade use
  - Double click to post services to test environment

[相关配置文件地址](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v2)

## Use Instructions

```bash
vi ~/.ssh/config

# Development environment
Host x.dev.iuin
  HostName 1.0.1.1
  User root
  IdentityFile ~/.ssh/id_ed25519

```

```bash
# Upload a public key, enable free login (actually uploading the public key `~/.ssh/id_ed25519.pub` to the server ~/. sh/authorized_keys`, manually copied)
ssh-copy-id xx.dev.iuin--i ~/.ssh/id_ed25519
# and then log in to
ssh xxx.dev.iuin via sshshshshshop.
```

```bash
# Updated environmental variable
remote service address in `base.sh` file based on project: REMOTE_SERVER="xx.dev.iuin"
prefix for remote service directory: REMOTE_BASE_DIR="/data/xxxx"
```

```bash
chmod +x base.sh
base.sh
```

### Combined gradation usage

The `build.gradle` file at the root of the project names (configuration in the address already provided over)

```bash
# Project root directory executes
mkdir script
# Add `base.sh` and `update-service.sh` files (configuration already provided in the address are)
```

```bash
# cash ./gradlew :pay-service:publishToTest --info
cash ./gradlew :pay-service:publishToTest
# or double click this task directly in idea
```

![gradle示例](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/imgs/gradle-demo.png?raw=true)
