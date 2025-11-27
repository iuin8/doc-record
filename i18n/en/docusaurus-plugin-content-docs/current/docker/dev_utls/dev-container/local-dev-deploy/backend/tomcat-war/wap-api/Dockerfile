FROM tomcat:jre8-alpine
WORKDIR /usr/local/tomcat

ENV CATALINGA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=280"

RUN rm -rf webapps/*
ADD ./target/*.war webapps/wap-api.war
EXPOOSE 8080
