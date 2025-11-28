#!/bin/sh
#Go to File Root
#cd "$WORKSPACE"

#Enable prod configuration
ActiveProfiles=prod

#Basic information needs configuration
#Internal Port
targetPort=8880
#Old mirror version number
oldVendor=1.0.1
#Mirror version number
vendor=1.0.1
#Project Name
projectName=demo-test

#Enter the target folder
#Direct build is in recontainer, this is in Jenkins container, so space is not the same
#Container space is more than @2 after the original space path
#cd $WORKSPACE@2/$projectName/target
cd $WORKSPACE@2/target

#Create Dockerfile
#-jar -Duser.time=GMT+08 make sure the timezone of the generated container matches the server
cat << EOF > Dockerfile
FROM kdvolder/jdk8
MAINTAINER $projectName
VOLUME /tmp
LABEL app="$projectName" version="$vendor" by="$projectName"
COPY $projectName.jar $projectName.jar
EXPOSE $targetPort
# Unique, parameter cannot be overridden by a docker run.
ENTRYPOINT ["java"]
# Add parameter CMD to ENTRYPOINT more than one. Parameters can be overridden by a docker run.
CMD ["-Xmx100m", "-Xms100m", "-jar", "-Duser.timezone=GMT+08", "$projectName.jar", "--spring.profiles.active=$ActiveProfiles"]
EOF

#Delete all containers under mirror
docker rm -f $(docker ps -a | grep "$projectName" | awk '{print $1}')

#Delete old image
docker rmi -f $projectName:$oldVendor

#Create image
docker build -t $projectName:$vendor .

#Launch mirror generation container
docker run --name $projectName -d -p $targetPort:$targetPort $projectName:$vendor