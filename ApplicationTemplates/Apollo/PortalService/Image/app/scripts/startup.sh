#!/bin/bash
SERVICE_NAME=apollo-portal
## Adjust log dir if necessary
LOG_DIR=/data/apolloportal/logs
## Adjust server port if necessary
SERVER_PORT=8080
## Write  MetaServer URL to apollo-env.properties
touch /data/apolloportal/config/apollo-env.properties
if [ ${DEV_METASERVER} ];then
  echo "dev.meta=${DEV_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${DEVLOCAL_METASERVER} ];then
  echo "devlocal.meta=${DEVLOCAL_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${SIT_METASERVER} ];then
  echo "sit.meta=${SIT_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${BETA_METASERVER} ];then
  echo "beta.meta=${BETA_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${QAS_METASERVER} ];then
  echo "qas.meta=${QAS_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${PET_METASERVER} ];then
  echo "pet.meta=${PET_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${CI_METASERVER} ];then
  echo "ci.meta=${CI_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${FWS_METASERVER} ];then
  echo "fws.meta=${FWS_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${FAT_METASERVER} ];then
  echo "fat.meta=${FAT_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${UAT_METASERVER} ];then
  echo "uat.meta=${UAT_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${LPT_METASERVER} ];then
  echo "lpt.meta=${LPT_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi
if [ ${PRO_METASERVER} ];then
  echo "pro.meta=${PRO_METASERVER}">> /data/apolloportal/config/apollo-env.properties ;
fi


## Adjust memory settings if necessary
#export JAVA_OPTS="-Xms2560m -Xmx2560m -Xss256k -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=384m -XX:NewSize=1536m -XX:MaxNewSize=1536m -XX:SurvivorRatio=8"

## Only uncomment the following when you are using server jvm
#export JAVA_OPTS="$JAVA_OPTS -server -XX:-ReduceInitialCardMarks"

########### The following is the same for configservice, adminservice, portal ###########
export JAVA_OPTS="$JAVA_OPTS -XX:+UseParNewGC -XX:ParallelGCThreads=4 -XX:MaxTenuringThreshold=9 -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+UseCMSInitiatingOccupancyOnly -XX:+ScavengeBeforeFullGC -XX:+UseCMSCompactAtFullCollection -XX:+CMSParallelRemarkEnabled -XX:CMSFullGCsBeforeCompaction=9 -XX:CMSInitiatingOccupancyFraction=60 -XX:+CMSClassUnloadingEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSPermGenSweepingEnabled -XX:CMSInitiatingPermOccupancyFraction=70 -XX:+ExplicitGCInvokesConcurrent -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationConcurrentTime -XX:+PrintHeapAtGC -XX:+HeapDumpOnOutOfMemoryError -XX:-OmitStackTraceInFastThrow -Duser.timezone=Asia/Shanghai -Dclient.encoding.override=UTF-8 -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/./urandom"
#######################Extra JAVA OPTS#############################
export JAVA_OPTS="$JAVA_OPTS -Dserver.port=$SERVER_PORT -Dlogging.file=$LOG_DIR/$SERVICE_NAME.log -Xloggc:$LOG_DIR/heap_trace.txt -XX:HeapDumpPath=$LOG_DIR/HeapDumpOnOutOfMemoryError/ -Dspring.profiles.active=auth"

PATH_TO_JAR=$SERVICE_NAME".jar"
SERVER_URL="http://localhost:$SERVER_PORT"

function checkPidAlive {
    for i in `ls -t $SERVICE_NAME*.pid 2>/dev/null`
    do
        read pid < $i

        result=$(ps -p "$pid")
        if [ "$?" -eq 0 ]; then
            return 0
        else
            printf "\npid - $pid just quit unexpectedly, please check logs under $LOG_DIR and /tmp for more information!\n"
            exit 1;
        fi
    done

    printf "\nNo pid file found, startup may failed. Please check logs under $LOG_DIR and /tmp for more information!\n"
    exit 1;
}

if [ "$(uname)" == "Darwin" ]; then
    windows="0"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    windows="0"
elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
    windows="1"
else
    windows="0"
fi

# for Windows
if [ "$windows" == "1" ] && [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    tmp_java_home=`cygpath -sw "$JAVA_HOME"`
    export JAVA_HOME=`cygpath -u $tmp_java_home`
    echo "Windows new JAVA_HOME is: $JAVA_HOME"
fi

cd `dirname $0`/..

for i in `ls $SERVICE_NAME-*.jar 2>/dev/null`
do
    if [[ ! $i == *"-sources.jar" ]]
    then
        PATH_TO_JAR=$i
        break
    fi
done

if [[ ! -f PATH_TO_JAR && -d current ]]; then
    cd current
    for i in `ls $SERVICE_NAME-*.jar 2>/dev/null`
    do
        if [[ ! $i == *"-sources.jar" ]]
        then
            PATH_TO_JAR=$i
            break
        fi
    done
fi

if [[ -f $SERVICE_NAME".jar" ]]; then
  rm -rf $SERVICE_NAME".jar"
fi

printf "$(date) ==== Starting ==== \n"

ln $PATH_TO_JAR $SERVICE_NAME".jar"
chmod a+x $SERVICE_NAME".jar"
./$SERVICE_NAME".jar" run

rc=$?;

if [[ $rc != 0 ]];
then
    echo "$(date) Failed to start $SERVICE_NAME.jar, return code: $rc"
    exit $rc;
fi

declare -i counter=0
declare -i max_counter=48 # 48*5=240s
declare -i total_time=0

printf "Waiting for server startup"
until [[ (( counter -ge max_counter )) || "$(curl -X GET --silent --connect-timeout 1 --max-time 2 --head $SERVER_URL | grep "Coyote")" != "" ]];
do
    printf "."
    counter+=1
    sleep 5

    checkPidAlive
done

total_time=counter*5

if [[ (( counter -ge max_counter )) ]];
then
    printf "\n$(date) Server failed to start in $total_time seconds!\n"
    exit 1;
fi

printf "\n$(date) Server started in $total_time seconds!\n"

exit 0;
