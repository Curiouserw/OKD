# OpenShift Jira
# 简介
1. Jira版本7.5.2<br>
2. [http://my.atlassian.com](http://my.atlassian.com) 网站注册用户申请试用License 30天<br>
3. 数据存贮使用Postgresql作为外置数据库<br>
4. 挂载持久卷到`/var/atlassian/application-data/`和 `/var/atlassian/application-data/jira/shared`目录
5. Forked: [https://github.com/rtcm-ops/openshift-jira](https://github.com/rtcm-ops/openshift-jira)
# 部署步骤
#### 1、拉取容器镜像代码、构建容器镜像并推送至镜像仓库</br>
<pre>
git clone https://github.com/RationalMonster/OpenShift.git openshift ;\
cd openshift/MiddlewareOpenshiftTemplates/Jira/Image ;\
docker build -t 镜像仓库URL/jira/jira:7.5.2 . ;\
docker push 镜像仓库URL/jira/jira:7.5.2
</pre>
#### 2、部署持久化数据库Postgresql
后续Jira存储数据使用外部数据库。使用MySQL的话需要在容器中下载mysql的驱动包。所以直接使用`Postgresql`。<br>
![Postgresql](https://github.com/RationalMonster/OpenShift/blob/master/MiddlewareOpenshiftTemplates/Jira/Pictures/PostgreSQL.jpg)<br>
然后创建基于Ceph的持久化卷。
#### 3、创建Jira容器的持久化卷
需要对Jira容器中的 `/var/atlassian/application-data/`和 `/var/atlassian/application-data/jira/shared`进行持久化。
持久化卷暂时使用的是Ceph动态存储。需要注意Jira项目中要创建Ceph的secret才能创建持久化卷。
<pre>
oc  create secret generic ceph-secret --type="kubernetes.io/rbd" --from-literal=key='AQAil11anEPOORAArxzRkH9iS1IOGKQfK87+Ag==' --namespace=jira
</pre>
#### 4、部署Jira容器镜像
![Jira](https://github.com/RationalMonster/OpenShift/blob/master/MiddlewareOpenshiftTemplates/Jira/Pictures/Jira.jpg)
#### 5、设置Jira
①设置数据库连接信息<br>
②在[my.atlassian.com](https://my.atlassian.com/products)网站获取License（试用期30天）。
