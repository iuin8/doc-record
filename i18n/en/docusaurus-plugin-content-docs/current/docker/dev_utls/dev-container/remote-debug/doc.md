# Remote Debugging

This is mainly for no local need to reverse such kits as the office

```Dockerfile
FROM registry.cn-guangzhou.aliyuncs.com/iuin/oraclejdk17:libreoffice-skywalking

COPY build/libs/*.jar /data/app.jar

ENV PORT=9880
ENV JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:2$PORT"
ENV OFFICE_HOME="/usr/lib/libreoffice"

ENTRYPOINT ["java","-Xms512m","-Xmx4096m","-XX:+UseG1GC","-jar","-Duser.language=zh","-Dserver.port=$PORT","-Djdk.attach.allowAttachSelf=true","-Dnet.bytebuddy.agent.attacher.dump=/tmp/arthas.dump","/data/app.jar"]

EXPOSE $PORT 1$PORT 2$PORT

```

> PS: Add container, port mapping, and gradle build (clean bootJ) in idea configuration
> and then remote debug configuration, set IP, port and module at
> Other issues: mainClass configuration may need to be added to build. radile
