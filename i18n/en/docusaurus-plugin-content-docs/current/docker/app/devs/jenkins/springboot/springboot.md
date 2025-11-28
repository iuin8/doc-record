## springboot pom.xml configuration

```xml
            <!-- Docker maven plugin start -->
            <plugin>
                <groupId>com.spotify</groupId>
                <artifactId>docker-maven-plugin</artifactId>
                <version>0.4.13</version>
                <configuration>
                    <imageName>demo</imageName><!--[a-z 0-9] 不然docker:build会报错-->
                    <dockerDirectory>${project.basedir}/src/main/docker</dockerDirectory>
                    <resources>
                        <resource>
                            <targetPath>/</targetPath>
                            <directory>${project.build.directory}</directory>
                            <include>${project.build.finalName}.jar</include>
                        </resource>
                    </resources>
                </configuration>
            </plugin>
            <!-- Docker maven plugin end -->
```

## docker.sh

```shell
mvn clean package docker: build
echo "Current docker image："
docker images | grep demo
echo "Start container -->"
docker run -p 8001:8001-d demo
echo "Start service success!"
```

## Dockerfile

```shell
#FROM openjdk:8-jdk-alpine
FROM hub.c.163.com/dwyane/openjdk:8
VOLUME /tmp
ADD docker-springboot-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar","/app.jar"]
```

## jenkins Install Docker Plugin

- Docker Plugin Configuration [System Manager -> System Configuration -> System Configuration -> System Configuration -> Cloud]
- Configure docker host URI [unix:/var/run/docker.sock]

> (typically unix:/var/run/docker.sock or tcp://127.0.1:2376)

![img.png](img/img.png)

## New maven project configuration

![img_1.png](img/img_1.png)
![img_2.png](img/img_2.png)
