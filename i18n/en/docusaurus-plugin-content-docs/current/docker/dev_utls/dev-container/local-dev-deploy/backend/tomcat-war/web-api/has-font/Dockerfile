FROM tomcat:jre8-alpine
WORKDIR /usr/local/tomcat

# for remote debug
ENV CATALINGA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=280"

ENV JAVA_OPTS="-Djava.security.egd=file:/dev/../urandom"

ENV TZ=Asia/Shanghai

# Proxy addresses, pull font requires scientific access
ENV https_proxy="http://10.0.16.17:7890"
ENV http_proxy="http://10.0.16.17:7890"
ENV all_proxy="socks5:/10.0.16.17:7890"

RUN rm -rf webapps/* ``
    &&apk update
    &&apk add --update font-adobe-100dpi ttf-dejavu fontconfig \.
    && rm -rf /etc/apk/cache/*
# && apk cache clean# This command will report wrong when Cache is disabled

ADD ./target/*.war webapps/web-api.war

EXPOOSE 8080
