# Quick Publish Service

- Support for updates from the specified service
- Support for updating all services
- Process service JAR file upload and remote launch
- Support idea gradle
  - Double click to post services to test environment

[相关配置文件地址](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service)

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

```bash
chmod +x base.sh
base.sh
```

### Combined gradle usage

The `build.gradle` file at the root of the project adds tasks (configuration in the address already provided above)

```bash
# Project root directory executes
mkdir script
# Add `base.sh` and `update-service.sh` files (configuration already provided in the address above)
```

```bash
# bash ./gradlew :pay-service:publishToTest --info
bash ./gradlew :pay-service:publishToTest
```

![gradle示例](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/imgs/gradle-demo.png?raw=true)
