 

# Apollo分布式部署架构图
![](https://github.com/RationalMonster/OpenShift/blob/master/ApplicationTemplates/Apollo/Pitures/Apollo%E5%88%86%E5%B8%83%E5%BC%8F%E9%83%A8%E7%BD%B2%E5%9B%BE.jpg)

# Openshift上 Apollo分布式部署步骤
### 0. 部署要求
    - JDK：1.8+
    - MySQL: 5.6.5+
    - ConfigAdmin组件镜像（详见目录ConfigAdminService下的README.md）
    - Portal组件镜像（详见目录PortalService下的README.md）
### 1. 创建各个环境下Configadmin服务的高可用MySQL数据库并导入初始化数据
### 2. 各个环境部署configadmin服务
### 3. 创建Portal服务的高可用MySQL数据库并导入初始化数据
### 4. 部署portal服务


# 特别说明：
####1. 支持的环境列表变量
      
      devlocal,dev,sit,uat,beta,qas,pet,ci,fws,fat,lpt,pro
      #在Portal中新增环境时需要到portal对应的数据库中添加一条数据，然后在portal服务启动时添加一个环境变量。格式：CI_METASERVER=http://ci环境下configadminservice的IP:8080
           

