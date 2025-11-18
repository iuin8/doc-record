# 远程交互插件(idea使用gradle与远程服务器间的交互--发布服务,查看日志,连接arthas等)

## 使用说明

```bash
vi ~/.ssh/config

# 开发环境
Host xxx.dev.iuin
  HostName 1.0.1.1
  User root
  IdentityFile ~/.ssh/id_ed25519_iu

```

### 结合gradle使用

```gradle
// 项目根目录下的build.gradle文件中添加以下内容
plugins {
    id 'io.github.iuin8.remote' version '0.1.36'
}

group = 'com.xxx.xxx'
version = '3.0.0'
```

```gradle
// 项目根目录下的settings.gradle文件中添加以下内容
//gradle插件仓库
pluginManagement {
    repositories {
        //本地
        mavenLocal()
        //私服
        maven {
            url 'http://10.11.11.11:1111/repository/maven-public/'
            allowInsecureProtocol = true
        }
        //国内镜像
        maven {
            url 'https://maven.aliyun.com/repository/public'
        }
        //gradle官方门户
        gradlePluginPortal()
        //备用
        mavenCentral()
    }
}

```

```yml
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

```bash
# bash ./gradlew :order-service:publish\(dev\) --info
bash ./gradlew :order-service:publish\(dev\)
```

![gradle task示例](https://github.com/iuin8/doc-record/blob/main/docs/tools/terminal/publishScript/remote_plugin/imgs/gradle_task.png?raw=true)

### 结合arthas命令查看sql, Redis, es命令

[参考查看sql命令地址](https://github.com/iuin8/doc-record/blob/main/docs/materiel/article/arthas查看sql.md)
[参考查看sql_redis_es命令地址](https://github.com/iuin8/doc-record/blob/main/docs/materiel/draft/arthas查看sql_redis_es.md)
