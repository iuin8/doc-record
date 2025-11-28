# Remote interactive plugins (idea uses various interfaces with remote servers, publishing services, viewing logs, connecting arthas, etc)

## Use Instructions

```bash
vi ~/.ssh/config

# Development environment
Host x.dev.iuin
  HostName 1.0.1.1
  User root
  Port 22
  IdentitFile ~/.ssh/id_ed25519_iu

```

```bash
ssh-copy-id -i ~/.ssh/id_ed25519_iu xxx.dev.iuin
```

### Combined gradation usage

- Add the following to build.gradle file at the root of the project

```gradle
// Add the following to build.gradle file in project root directory
plugins {
    id 'io.github.iuin8.remote' version '0.1.36'
}

group = 'com.xxx.xxx'
version = '3.0.0'
```

- Add the following to the settings.gradle file at the root of the project

```gradle
// Settings under the project root directory. Add the following to the radle file the
//gradle plugin in repository
pluginManagement ROL
    repositories are subject to the
        //local
        mavenLocal()
        //private sub
        maven 0
            url 'http://10. 1.11. 1:1111111/repository/maven-public/'
            allowInsecureProtocol = true
        }
        /domestic image
        maven
            url 'https://maven. liyun. om/repository/public'
        }
        /gradle official Portal
        gradlePluginPortal()
        //alternate
        mavenCentral()
    }
}

```

- Profiles : <Project Root >/remote-plugin/remote.yml

```yml
# 配置文件: {项目根目录}/remote-plugin/remote.yml
# Remote plugin configuration example
# Supported placeholders:
#   - ${service}            : current Gradle project name
#   - ${REMOTE_BASE_DIR}    : value of remote.base.dir
#   - ${remote.base.dir}    : same as above

# Environment configurations
# Each environment can have its own settings
environments:
  # Development environment configuration (from gradle-dev.properties)
  dev:
    remote:
      server: xxx.dev.iuin
      base:
        dir: /data/xxx
  # 其他环境, 例如: 测试环境, 生产环境等
  test:
    remote:
      server: xxx.test.iuin
      base:
        dir: /data/xxx

# Service ports configuration (previously in service-ports.json)
service:
  ports:
    order-service: 1111
  start:
    command: $REMOTE_BASE_DIR/$SERVICE_NAME/$SERVICE_NAME-start.sh
  env:
    JAVA_TOOL_OPTIONS: -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:3$SERVICE_PORT

# Configure log file pattern for logTask (logTo<Profile>)
# Default resolves to: ${REMOTE_BASE_DIR}/../logs/${service}.log
log:
  filePattern: ${REMOTE_BASE_DIR}/../logs/${service}.log

```

- Publish Example Service

```bash
# bash ./gradlew :order-service:publish\(dev\) --info
bash. gradlew :order-service:publish\(dev\)
# Execute this order, or double click this gradle task directly in idea, can post services to remote server
```

![gradle task example](https://github.com/iuin8/doc-record/blob/main/docs/tools/terminal/publishScript/remote_plugin/imgs/gradle_task.png?raw=true)

### View sql, Redis, es orders in connection with arthas commands

- [参考查看sql命令地址](https://github.com/iuin8/doc-record/blob/main/docs/materiel/article/arthas查看sql.md)
- [参考查看sql_redis_es命令地址](https://github.com/iuin8/doc-record/blob/main/docs/materiel/draft/arthas查看sql_redis_es.md)
