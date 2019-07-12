
# 基于SonarQube官方镜像在openshift中部署的Template模板

## 相关链接
Docker镜像下载地址：https://hub.docker.com/_/sonarqube?tab=description

Docker镜像说明文档：https://github.com/docker-library/docs/tree/master/sonarqube

Docker镜像GIthub: https://github.com/SonarSource/docker-sonarqube

下载插件：https://binaries.sonarsource.com/Distribution/

LDAP插件的说明文档：https://docs.sonarqube.org/display/SONARQUBE67/LDAP+Plugin

Sonarqube集成LDAP说明文档：https://docs.sonarqube.org/latest/instance-administration/delegated-auth/

## Template说明
1. 第一次部署时自动从本仓库下载安装ldap插件，同时可在模板中通过环境变量的形式添加LDAP相关的配置（"7.7-community"之后的版本才可以）。

2. 可在模板中选择要部署的版本

3. 需要持久化的目录

   | 目录                      | 说明                                              | 可配置的环境变量     |
   | ------------------------- | ------------------------------------------------- | -------------------- |
   | /opt/sonarqube/conf       | 配置文件目录。例如sonar.properties                | sonarqube_conf       |
   | /opt/sonarqube/data       | 数据目录。存储elasticsearch或者默认H2数据库的数据 | sonarqube_data       |
   | /opt/sonarqube/logs       | 日志目录                                          | sonarqube_logs       |
   | /opt/sonarqube/extensions | 插件目录                                          | sonarqube_extensions |

## 操作步骤
```jshelllanguage
oc new-project sonarqube --display-name="SonarQube" && \
oc project sonarqube && \
oc create -f https://raw.githubusercontent.com/RationalMonster/OKD/master/MiddlewareOpenshiftTemplates/SonarQube/SonarQube-LDAP-template.yaml -n sonarqube && \
oc -n sonarqube process \
    sonarqube \
    NAMESPACE=sonarqube \
    SONARQUBE_VERSION="7.9-community" \
    LADP_URL='ldap://openldap-service.openldap.svc:389' \
    LDAP_BINDDN='cn=admin,dc=example,dc=com' \
    LDAP_BINDDNPASSWORD='******' \
    LDAP_USER_BASEDN='ou=employee,dc=example,dc=com' \
    LDAP_USER_REQUEST='(&(memberOf=cn=sonarqube,ou=applications,dc=example,dc=com)(cn={0}))' \
    LDAP_USER_REALNAMEATTRIBUTE='sn' \
    JVM_CE='-Xmx1024m -Xms512m -XX:+HeapDumpOnOutOfMemoryError' \
    JVM_WEB='-Xmx1024m -Xms512m -XX:+HeapDumpOnOutOfMemoryError' \
    |oc create -f -
```
## 查看日志
```jshelllanguage
# oc get po
NAME                            READY     STATUS     RESTARTS   AGE
postgresql-sonarqube-1-5pfg4    0/1       Running    0          6s
postgresql-sonarqube-1-deploy   1/1       Running    0          10s
sonarqube-1-deploy              1/1       Running    0          11s
sonarqube-1-p9wbz               0/1       Init:0/1   0          7s

# oc logs -f sonarqube-1-p9wbz -c init-scheduler
# oc logs -f sonarqube-1-p9wbz
```
## 删除创建的资源
```jshelllanguage
oc delete project/sonarqube  scc/sonarqube-anyuid
```
