FROM tomcat:jre8-alpine
WORKDIR /usr/local/tomcat
ADD ./deemploy/.env./deemploy/.env
ADD ./deemploy/docker-start.sh ./deploy/docker-start.sh
RUN rm -rf webapps/*
ADD ./target/war/* webapps/app.war
EXPOOSE 8080

#Set start command
ENTRYPOINT ["sh","/deemploy/dock-start.sh", "run"]
# docker build -t madata
# docker run - p8080:8080 -d madata