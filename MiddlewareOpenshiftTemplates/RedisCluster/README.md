# OpenShift Redis Cluster
# 简介
1、Forked：[https://github.com/mjudeikis/redis-openshift.git](https://github.com/mjudeikis/redis-openshift.git)

# 镜像修改日志
1、 修改image/Dockerfile中的基础镜像rhel7为openshift/base-centos7

# 部署步骤
### 0、准备
    oc new-project redis --display-name="Redis Cluster"
### 1、构建镜像
    git clone https://github.com/RationalMonster/OpenShift.git openshift ;\
    cd openshift/MiddlewareOpenshiftTemplates/RedisCluster/image ;\
    docker build -t 镜像仓库URL/redis/redis:latest ;\
    docker push 镜像仓库URL/redis/redis:latest
### 2、部署
    oc create -f openshift/MiddlewareOpenshiftTemplates/RedisCluster/list.yaml

