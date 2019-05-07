# Apollo ConfigAdmin Service

### 部署前置条件
1. MySQL (版本5.6.5以上)已安装部署
2. MySQL向Database(Apollo ConfigDB)导入初始化数据的脚本apolloconfigdb.sql并执行apolloconfigdbvalidationsql.sql文件中的SQL进行验证
3. Image镜像目录中RPM格式的JDK为空文件（GitHub无法上传这么大的文件），在实际构建镜像中使用真实的文件进行替换。
### 镜像构建步骤
    git clone https://github.com/RationalMonster/OpenShift.git -b master ~ &&\
    cd ~/OpenShift/ApplicationTemplates/Apollo/ConfigAdminService/Image &&\
    docker build -t apolloconfigadminservice:v1 . 
### 环境配置文件configadmin-env中的变量详解
    #Config Service注册到eureka上的域名或者IP地址和端口。
    CONFIGSERVICE_REGISTRY_TO_EUREKA_URL_OR_IP=1.2.3.3
    CONFIGSERVICE_REGISTRY_TO_EUREKA_PORT=8080
    
    #Config Service要连接的数据库信息
    CONFIGSERVICEDB=1.2.3.4
    CONFIGSERVICEDB_PORT=13306
    CONFIGSERVICEDB_USER=configadmin
    CONFIGSERVICEDB_PASSWORD=abcdefg
    
    #Admin Service注册到eureka上的域名或者IP地址和端口。
    ADMINSERVICE_REGISTRY_TO_EUREKA_URL_OR_IP=1.2.3.3
    ADMINSERVICE_REGISTRY_TO_EUREKA_PORT=8090
    
    #Admin Service要连接的数据库信息
    ADMINSERVICEDB=1.2.3.4
    ADMINSERVICEDB_PORT=13306
    ADMINSERVICEDB_USER=configadmin
    ADMINSERVICEDB_PASSWORD=abcdefg
    
### Docker部署
    docker run -it \
    -p 18080:8080 -p 18090:8090  #映射端口 \ 
    --env-file=configadmin-env #加载环境变量文件 \ 
    apolloconfigadminservice:v1
调试

    docker run -it \
    -p 18080:8080 -p 18090:8090 #映射端口 \ 
    --env-file=configadmin-env #加载环境变量文件 \ 
    apolloconfigadminservice:v1 bash

### openshift部署（以在Dev环境部署ConfiAdmin服务为例，其他环境类似）

##### 0. 创建Dev环境对应的项目
    oc new-project apollodev --displayname="Apollo Dev环境" && \
    #创建一个在apollodev项目中运行特权容器的serviceaccount \
    oc create serviceaccount apollo -n apollodev && \
    #在scc中放行该namespace中的serviceaccount \
    oc adm policy add-scc-to-user anyuid system:serviceaccount:apollodev:apollo 
#### 1. 部署持久化的数据库,向MySQL的Database(Apollo ConfigDB)导入初始化数据并验证。（此步骤省略）。
#### 2. 构建ConfigAdmin镜像并推送到open shift自带的镜像仓库Registry中
    docker tag apolloconfigadminservice:v1 docker-registry.default.svc:5000/apollo/configadminservice:v1 &&\
    docker push docker-registry.default.svc:5000/apollo/configadminservice:v1
#### 3. CLI 命令行部署
    oc project apollodev #切换工程  && \ 
    oc new-app \
    #指定部署的镜像 \
    --docker-image="docker-registry.default.svc:5000/apollo/configadminservice:v1" \
     #创建DC \
    --name=apolloconfigadminsvc \
    #注入环境变量，其值见环境配置文件configadmin-env中的详解
    -e CONFIGSERVICE_REGISTRY_TO_EUREKA_URL_OR_IP=config-apollodev.apps.allinone.curiouser.com  \
    -e CONFIGSERVICE_REGISTRY_TO_EUREKA_PORT=80 \
    -e CONFIGSERVICEDB=mysql.apollodev.svc  \
    -e CONFIGSERVICEDB_PORT=3306 \
    -e CONFIGSERVICEDB_USER=apollo \
    -e CONFIGSERVICEDB_PASSWORD=curiouser \
    -e ADMINSERVICE_REGISTRY_TO_EUREKA_URL_OR_IP=admin-apollodev.apps.allinone.curiouser.com \
    -e ADMINSERVICE_REGISTRY_TO_EUREKA_PORT=80 \
    -e ADMINSERVICEDB=mysql.apollodev.svc  \
    -e ADMINSERVICEDB_PORT=3306 \
    -e ADMINSERVICEDB_USER=apollo \
    -e ADMINSERVICEDB_PASSWORD=curiouser \
    -n apollodev  &&\
    oc expose dc apolloconfigadminsvc --port=8080,8090  --name=apolloconfigadminsvc #创建指向POD内容器的8080和8090端口的service && \
    oc expose service apolloconfigadminsvc --hostname=config-apollodev.apps.allinone.curiouser.com --port=8080 --name=config #创建POD内容器8080端口的route &&\
    oc expose service apolloconfigadminsvc --hostname=admin-apollodev.apps.allinone.curiouser.com --port=8090 --name=admin #创建POD内容器8090端口的route
    
备注： 该DC部署的POD，其中容器中服务启动需要特殊权限.需要在DC的yml配置serviceaccount
   
    oc edit dc/apolloconfigadminsvc 
    在spec层级下添加
    template: 
      spec: 
        serviceAccount: apollo
        serviceAccountName: apollo
   





