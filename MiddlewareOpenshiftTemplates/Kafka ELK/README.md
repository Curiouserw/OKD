# OKD Template: Apache kafka(single)+Logstash+Elasticsearch+kibana


## 模板说明
1. 部署的kafka、elasticsearch是单节点
2. Logstash的Pipeline是从kafka的"log" Topic中抽取日志数据到ElasticSearch的。只抽取日志格式匹配的数据。
3. 日志数据格式： TimeStamp|level|类名|线程名|应用名|{"key1"："v1: {json}"}

## 样本日志数据
	20180222173500144|INFO |com.curiouser.common.JobDispatcher|JobNotifyQueue_uat.wechat-uat-2|wechat_uat|{"msg":"target serviceId: merchant-service; application name: wechatsrv","funcName":"dispatch","hostName":"wechat-19-pv8219","service":"JobDispatcher","ip":"10.129.7.82","time":"20180232 17:35:00","flowNo":"20180222173512014121162512243037"}
	20180222173500144|INFO |com.curiouser.common.JobDispatcher|JobNotifyQueue_uat.wechat-uat-2|wechat_uat|{"msg":"servicedId not match","funcName":"dispatch","hostName":"wechat-19-pv2619","service":"JobDispatcher","ip":"10.129.7.82","time":"20180232 17:35:00","flowNo":"20180222173503214121162512243037"}
## Kafka常用操作
	#查看Topic
	/opt/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --list

	#Console生产者
	/opt/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic log

	# Console消费者
	/opt/kafka/bin/kafka-console-consumer.sh --zookeeper  localhost:2181 --topic log --from-beginning

## 部署步骤
	oc create -f Kafka-ELK-OKD-template.yml

