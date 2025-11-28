# dockerfile

## maven builds with dockerfile plugin

- Reference project [https://gitee.com/LFa/demo-test.git]
- springboot pom.xml configuration

```xml
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
        <maven.test.skip>true</maven.test.skip>
        <spring-cloud.version>Finchley.RELEASE</spring-cloud.version>
        <dockerfile.maven.version>1.4.3</dockerfile.maven.version>
        <!-- 首先确保，配置的docker.image.prefix时正确的，即配置了绑定仓库。 -->
        <docker.image.prefix>registry.docker.com:5000</docker.image.prefix>
        <appPort>8880</appPort>
    </properties>
    <!-- build -->
    <finalName>${project.name}</finalName>
    <!-- build -> plugins -->
    <plugin>
        <groupId>com.spotify</groupId>
        <artifactId>dockerfile-maven-plugin</artifactId>
        <version>1.4.13</version>
        <executions>
            <execution>
                <id>default</id>
                <goals>
                    <goal>build</goal>
                    <goal>push</goal>
                </goals>
            </execution>
        </executions>
        <configuration>
            <!-- 注意，repository的格式必须为：<username>/<repository_name>
             username就是登录Docker Hub的用户名，例如我的用户名是longyonggang。
            repository_name就是上一步在Docker Hub上创建的repository名字。 -->
            <repository>${docker.image.prefix}/${project.build.finalName}</repository>
            <tag>${project.version}</tag>
            <buildArgs>
                <JAR_FILE>${project.build.finalName}.jar</JAR_FILE>
                <APP_PORT>${appPort}</APP_PORT>
            </buildArgs>
        </configuration>
    </plugin>
```

- springboot application.yml configuration

```yaml
server:
  report: @appport@
logging:
  level:
    root: info
spring:
  application:
    name: @project.name@
# com.example.demo.repository.UserRepository: debug
```

- Dockerfile File Configuration > tip: Put in Project Root

```Dockerfile
#FROM openjdk:8-jdk-alpine
FROM hub.c.163.com/dwyane/openjdk:8
# VOLUME ，VOLUME 指向了一个/tmp的目录，由于 Spring Boot 使用内置的Tomcat容器，Tomcat 默认使用/tmp作为工作目录。这个命令的效果是：在宿主机的/var/lib/docker目录下创建一个临时文件并把它链接到容器中的/tmp目录
VOLUME /tmp 
WORKDIR /workdir
ARG JAR_FILE
ARG APP_PORT
ADD target/${JAR_FILE} app.jar
# ENTRYPOINT ，为了缩短 Tomcat 的启动时间，添加java.security.egd的系统属性指向/dev/urandom作为 ENTRYPOINT
#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","app.jar"] 
ENTRYPOINT ["java","-jar","app.jar"]
EXPOSE ${APP_PORT}
```

- Execute mvn clean package > Access to Private Repository: http://registry.docker.com:5000/v2/_catalog
- Jenkins configuration
- Create maven project
- Build[Goals and options -> clean install -Dmaven.test.skip=true]
- Post Steps[Run only if build such]
- ad post-build step [Senegal files or executive orders over SSH]

```shell

cd $DOCKER_WORKSPACE/$JOB_NAME

export app_version='1.0'

# 编辑stack yml文件
tee $JOB_NAME.yml <<-'EOF'
version: '3.5'
services:
  $JOB_NAME:
    image: registry.docker.com:5000/$JOB_NAME:${app_version}
    ports:
      - target: 8880
        published: 8880
        mode: host
    networks:
      - middleware
    deploy:
      replicas: 1
      update_config:
        parallelism: 1
      restart_policy:
        condition: on-failure

networks:
  middleware:
    external: true

EOF

# 启动app容器 
docker stack up -c $JOB_NAME.yml app

```

## Open docker Remote Access

- Edit /etc/sysconfig/docker file, docker I installed. No such file found, if any,：

```shell
sudo vi /etc/sysconfig/docker

///add the following
other_args="-H tcp://0.0.0:2375 -H unix:////var/run/docker.sock"

/Save
:wq!
 
//reboot docker service
service docker restart
```

- Create a new DOCKER_HOST value in the windows system environment variable to tcp://[docker_ip]:2375, replace[docker_ip]here with a centeros server IP or hostname in which the docker is located (using hostname and requiring windows to configure hosts/hosts) and may require a restart of the system.
- Modify /usr/lib/systemd/system/docker.service file

```shell
sudo vi /usr/lib/systemd/system/docker.service
//在ExecStart这一行后面加上（这里就写4个0，别改成自己的ip） 
-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
 
改完后效果如下
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
 
:wq!
保存退出

重新加载配置文件 systemctl daemon-reload
重启docker ：service docker restart
这样才可以是/etc/default/docker中的配置项生效
```

- We first ask which ports docker's virtual machine is listening to, using command：

```shell
netstat -tlunp
# Show
# tcp6 0 ::::2375 ::::* LISTEN -

# 2375 Ports, Listening.
# firewall problems when this is very likely, In CentOS7, the firewall will be opened by default. If the firewall is opened, it will only listen to the port at 22 by default, i.e. only 22 ports are exposing from the host.
# Use the following command：
sudo iptables-save
# to view the external port of firewall leaks, The current 2373 port does not have a ripple leak.
# An additional 2375 port is required, using the following command：
# Add port
sudo firewall-cmd --zone=public --add-port=2375/tcp --permanent
# Reload
sudo firewall 
 sudo firewald-cmd --reload
# Use the iptables-save command to view the port and see an additional 2375 port.
```
