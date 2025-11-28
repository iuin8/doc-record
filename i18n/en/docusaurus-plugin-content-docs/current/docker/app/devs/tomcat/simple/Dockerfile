FROM tomcat:8.5

#Maintainer
MAINTAINER Fa

#Delete all under the webapp
RUN rm -rf /usr/local/tomcat/webapps/*

#Copy x.war from target to /usr/local/tomcat/webapps/
ADD ./target/*.war /usr/local/tomcat/webapps/

#Port
EXPOOSE 8080

#Set start command
ENTRYPOINT ["/usr/local/tomcat/bin/catina.sh", "run"]