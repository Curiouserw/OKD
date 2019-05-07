# Apollo Portal服务组件Docker镜像

## 1. 构建Docker镜像
    git clone https://github.com/RationalMonster/OpenShift.git ~ &&\
    cd ~/OpenShift/ApplicationTemplates/Apollo/PortalService/Image &&\
    docker build -t apollo-portal:v1 . 

## 2. 启动容器
#### 创建环境变量文件
    bash -c 'cat > ~/portalservice-envfile <<EOF
    PORTALDB=1.2.3.1
    PORTALDB_PORT=43306
    PORTALDB_USER=root
    PORTALDB_PASSWORD=curiouser
    DEVLOCAL_METASERVER=http://1.1.1.2:8080
    DEV_METASERVER=http://1.1.1.2:8080
    SIT_METASERVER=http://1.1.1.3:8080
    UAT_METASERVER=http://1.1.1.4:8080
    JAVA_OPTS=-Xms2560m -Xmx3000m
    EOF'
    
#### 启动容器
    docker run -it \
    #指定要加载的环境变量文件 \
    --env-file=portalservice-envfile \
    #端口映射 \
    -p 18080:8080 \
    #指定启动的镜像 \
    apollo-portal:v1
    
#### 调试镜像
    docker run -it \
    --env-file=portalservice-envfile \
    -p 18080:8080 \
    apollo-portal:v1 bash
    
    #服务启动脚本，日志在/data/apolloportal/logs目录下
    bash-4.2$ sh /data/apolloportal/scripts/startup.sh


## openshift CLI下部署
1. 推送镜像到open shift的私有仓库中

        docker tag apollo-portal:v1 docker-registry.default.svc:5000/apollo/portalui:v1 &&\
        docker push docker-registry.default.svc:5000/apollo/portalui:v1
2. 创建Namespace

        oc new-project apolloportal --displayname="Apollo Portal UI" && \
        #创建一个在apolloportal项目中运行特权容器的serviceaccount \
        oc create serviceaccount apollo -n apolloportal && \
        #在scc中放行该namespace中的serviceaccount \
        oc adm policy add-scc-to-user anyuid system:serviceaccount:apolloportal:apollo

3. Openshift CLI部署

        oc new-app \
        #指定镜像
        --docker-image="docker-registry.default.svc:5000/apollo/portalui:v1" \
        --name=apolloportal \
        -e PORTALDB=mysql.apolloportal.svc  \
        -e PORTALDB_PORT=3306 \
        -e PORTALDB_USER=apollo \
        -e PORTALDB_PASSWORD=curiouser \
        -e DEVLOCAL_METASERVER=http://apolloapollosvc.apollolocal.svc:8080 \
        -e DEV_METASERVER=http://config.apollodev.svc:8080 \
        -e SIT_METASERVER=http://apolloapollosvc.apollosit.svc:8080 \
        -e JAVA_OPTS='-Xms2560m -Xmx3000m' \
        -n apolloportal &&\
        oc expose dc apolloportal --port=8080 --name=apolloportal && \
        oc expose service apolloportal --port=8080  --name=apolloportal          