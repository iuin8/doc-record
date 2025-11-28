# /bin/bash

AGENT_ID_PREFIX=$PROJECT_NAME
AGENT_ID_SUFFIX=`echo $HOSTNAME | rev | cut -d'-' -f-1 | rev`
AGENT_ID="$AGENT_ID_PREFIX-$AGENT_ID_SUFFIX"
SPRING_PROFILES_ACTIVE=$APP_ENV

# Ali's Appliance Agent
#CDBG_AGENT="-agentpath:/tmp/cdbg_java_agent.so"

tee -a /etc/hosts <EOF
10.0.1.1.1.1.1.139 skywalking-skywalking-helm-oap.skywalking
10.0.1.1.1.17 skywalking-skywalking-helm-oap.skywalking
EOF

export JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=${DEBUG_PORT}"

export SW_AGENT_COLLECTOR_BACKEND_SERVICES=skywalking-skywaling-helm-oap.skywalking:3004
export SW_AGENT_NAME=$PROJECT_NAME


java -Xms512m -Xmx4096m -XX:+UseG1GC -jar -Duser.language=zh -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -Dserver.port=$SERVER_PORT app.jar
