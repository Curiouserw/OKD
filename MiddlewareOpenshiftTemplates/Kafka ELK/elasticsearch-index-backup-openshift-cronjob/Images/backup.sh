#!/bin/sh
allIndex=`curl -s -XGET "http://elasticsearch.kelk.svc:9200/_cat/indices/_all?h=index"`
systemIndex=`curl -s -XGET "http://elasticsearch.kelk.svc:9200/_cat/indices/.*/?h=i"`
for i in $allIndex ;
do
  if `echo $systemIndex |grep -q $i` ;then
    echo "The index $i belong to elasticsearch system index, leave it alone !" ;
  else
    createdateincludemesc=`curl -s -XGET "http://elasticsearch.kelk.svc:9200/_cat/indices/$i?h=cd"` ;
    createdate=$((createdateincludemesc/1000)) ;
    currentdate=`date +%s` ;
    durationtime=$((currentdate-createdate)) ;
    if [ $durationtime -gt 172800 ] ;then
        curl -s -XPUT "http://elasticsearch.kelk.svc:9200/_snapshot/pvc-snap-repo/%3C$i-snapshot-%7Bnow%2Fd%7D%3E?wait_for_completion=true" -H 'Content-Type: application/json' -d'{"indices": "'$i'","ignore_unavailable": true,"include_global_state": false}' ;
        if [ $? = 0 ] ;then
            curl -s -XDELETE "http://elasticsearch.kelk.svc:9200/$i" ;
        else
            echo "Backup Index $i failed!" ;
        fi
        echo " The Index $i have been backup to repository,and deleted in the ElasticSearch !" ;
    else
      echo "Created time of the index $i does not comply with the backup policy, should't backup to repository!";
    fi
  fi
done
