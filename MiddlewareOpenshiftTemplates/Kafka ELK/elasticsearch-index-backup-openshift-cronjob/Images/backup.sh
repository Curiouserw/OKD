#!/bin/sh
elasticsearch_url="http://${ELASTICSEARCH_HOST}:9200"
allIndex=`curl -s -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XGET "${elasticsearch_url}/_cat/indices/_all?h=index"`
excludeIndex=`curl -s -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XGET "${elasticsearch_url}/_cat/indices/${ELASTICSEARCH_EXCLUDE_INDEX}/?h=i"`
for i in $allIndex ;
do
  if `echo $excludeIndex |grep -q $i` ;then
    echo "The index $i belong to elasticsearch system index, leave it alone !" ;
  else
    createdateincludemesc=`curl -s -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XGET "${elasticsearch_url}/_cat/indices/$i?h=cd"` ;
    createdate=$((createdateincludemesc/1000)) ;
    currentdate=`date +%s` ;
    durationtime=$((currentdate-createdate)) ;
    if [ $durationtime -gt ${ELASTICSEARCH_INDEX_EXPIRYDATE} ] ;then
        curl -s -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XPUT "${elasticsearch_url}/_snapshot/${ELASTICSEARCH_SNAPSHOTS_REPOSITORY}/%3C$i-snapshot-%7Bnow%2Fd%7D%3E?wait_for_completion=true" -H 'Content-Type: application/json' -d'{"indices": "'$i'","ignore_unavailable": true,"include_global_state": false}' ;
        if [ $? = 0 ] ;then
            curl -s -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XDELETE "${elasticsearch_url}/$i" ;
        else
            echo "Backup Index $i failed!" ;
        fi
        echo " The Index $i have been backup to repository,and deleted in the ElasticSearch !" ;
    else
      echo "Created time of the index $i does not comply with the backup policy, should't backup to repository!";
    fi
  fi
done