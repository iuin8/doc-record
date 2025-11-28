# Quick Publish Service

- Support for updates from the specified service
- Support for updating all services
- Process service JAR file upload and remote launch
- Support area gradation
  - Double click to post services to test environment

[相关配置文件地址](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service)

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
project directory in `base.sh` from project: LOCAL_BASE_DIR="/Users/fa/dev/projects/IdeaProjects/company/iuin/mall/private-employ/xxxxxx-sbbc"
Remote service address: REMOTE_SERVER="xx.dev.iuin"
PREfix : MOTE_BABA_DIR="/data/xxxxxx"
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
# bash ./gradlew :pay-service:publishToTest --info
bash ./gradlew :pay-service:publishToTest
```

![gradle示例](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/imgs/gradle-demo.png?raw=true)
