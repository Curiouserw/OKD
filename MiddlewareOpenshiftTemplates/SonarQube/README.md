# SonarQube模板说明
####  在[https://github.com/OpenShiftDemos/sonarqube-openshift-docker.git](https://github.com/OpenShiftDemos/sonarqube-openshift-docker.git)的基础上进行改造的SoanrQube部署配置模板，主要改造的地方：<br>
1.源模板配置文件中没有对SonarQube POD中的/opt/sonar/extensions目录挂载持久化卷导致sonarqube无法持久化安装后的插件，POD重建后插件会消失，需要重新安装。所以在模板配置文件中添加了持久化卷请求PVC，并挂载到/opt/sonar/extensions目录下。<br>

2.源模板中，SonarQube容器镜像的JVM初始化堆内存和最大使用内存太小，导致访问量稍微一大，POD就会挂掉。修改容器镜像中SonarQube的配置文件，重新配置JVM。所以容器镜像需要在Image目录下手动构建并上传到Openshift集群的私有镜像注册仓库中。

## 目录结构说明
<pre>
-pv.yml：创建NFS类型持久化卷的YML配置文件，SonarQube POD中的/opt/sonar/{data，extensions}，Postgresql POD的数据目录需要持-久化。
-sonarqube-postgresql-template.yaml : Openshift模板配置文件，定义SonarQube、Postgresql两个POD的DC、IS、Router配置等。
-Image ：模板文件中的容器镜像，需手动在该目录下执行以下命令进行构建
    |-Dockerfile
    |-fix-permissions
    |-run.sh
</pre>
# 部署步骤
### 1、创建SonarQube工程
<pre>
oc new-project --display-name="SonarQube" sonarqube
</pre>
### 2、创建PV
<pre>
oc create -f pv.yml
</pre>
### 3、导入模板配置文件
<pre>
oc create -f sonarqube-postgresql-template.yaml
</pre>
### 4、构建模板中容器镜像SonarQube并推送到Openshift集群私有镜像注册仓库sonarqube镜像流中
<pre>
cd Image ;\
docker build -t 镜像仓库URL/sonarqube/sonarqube:6.7 . ;\
docker push 镜像仓库URL/sonarqube/sonarqube:6.7
</pre>
### 5、配置模板（使用模板配置文件中默认值即可，本步骤略）

