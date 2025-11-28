FROM tomcat:jre8-alpine

#Delete all under the webapp
RUN rm -rf /usr/local/tomcat/webapps/*

#Copy x.war from target to /usr/local/tomcat/webapps/
ADD ./target/*.war /usr/local/tomcat/webapps/

#Port
EXPOOSE 8080

#Set start command
# ENTRYPOINT ["/usr/local/tomcat/bin/catina.sh", "run"]

# docker build -t wap-api.
# docker run -d --network middle leware --p 8081:8080 wap-api

# Filename named ROOT.war
# curl http://localhost:8081/test/redis?key=a&value=b
