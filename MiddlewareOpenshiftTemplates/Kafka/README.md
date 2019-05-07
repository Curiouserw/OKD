# 简介
1. Forked:[https://github.com/debianmaster/openshift-kafka.git](https://github.com/debianmaster/openshift-kafka.git)

# 部署步骤 

1. 准备工作
<pre> 
oc cluster up  # setup openshift on docker for Mac  (Skip this if you already have a cluster)
git clone https://github.com/debianmaster/openshift-kafka.git && cd openshift-kafka
oc login -u system:admin
</pre>

2. 创建项目工程
<pre>
oc new-project kafka --display-name="Kafka"
</pre>

3. 给Pod中的容器授予root用户执行的权限
<pre>
oc adm policy add-scc-to-user anyuid -z default
</pre>

4. 创建持久化卷请求
<pre>
#PVC的后端持久化卷使用的是Ceph动态存贮。前提是当前项目中能够使用ceph storage class 和创建了Ceph 证书
#oc  create secret generic ceph-secret --type="kubernetes.io/rbd" --from-literal=key='AQCgrOJaf3mECxAA4qAnoPoYfOxvXIq8BwgL7w==' --namespace=kafka
oc create -f ./bootstrap/pvc.yml ;\
oc create -f ./zookeeper/bootstrap/pvc.yml
</pre>

5. 创建 Zookeeper & Kakfa stateful
<pre>
oc create -f ./zookeeper/service.yml ;\
oc create -f ./zookeeper/zookeeper.yaml ;\
oc create -f ./
</pre>

6. 创建测试客户端POD
<pre>
oc create -f test/99testclient.yml ;\
oc rsh testclient   #terminal 1 ;\
oc rsh testclient   #terminal 2 
</pre>

7. Kafka常用操作<br>
可在客户端POD的终端中进行操作
<pre>
#创建一个Topic
./bin/kafka-topics.sh --zookeeper zookeeper:2181 --topic test1 --create --partitions 1 --replication-factor 1 
#创建一个自带的消费者从Topic消费数据
./bin/kafka-console-consumer.sh --zookeeper zookeeper:2181 --topic test1 --from-beginning
</pre>
在另一个客户端POD的终端中操作
<pre>
#创建一个kafka自带的生产者往Topic中生产数据
./bin/kafka-console-producer.sh --broker-list kafka-0.broker.kafka.svc.cluster.local:9092,kafka-1.broker.kafka.svc.cluster.local:9092 --topic test1
</pre>

# 扩展集群
<pre>
oc edit petset kakfa  #change replicas to desired number (make sure you have enough PV,PVC)
</pre>
# 删除项目中的资源
<pre>
oc delete all,petset --all
oc delete pv,pvc --all
</pre>

![Demo Image](https://pbs.twimg.com/media/Cx5nXXQVIAEOvzL.jpg:large)
