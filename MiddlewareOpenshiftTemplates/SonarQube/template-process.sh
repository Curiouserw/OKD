#!/usr/bin/env bash
oc new-project sonarqube --display-name="SonarQube" && \
oc project sonarqube && \
oc create -f https://raw.githubusercontent.com/RationalMonster/OKD/master/MiddlewareOpenshiftTemplates/SonarQube/SonarQube-LDAP-template.yaml -n sonarqube && \
oc -n sonarqube process \
sonarqube \
NAMESPACE=sonarqube \
SONARQUBE_VERSION="7.4-community" \
LADP_URL='ldap://openldap-service.openldap.svc:389' \
LDAP_BINDDN='cn=admin,dc=curiouser,dc=com' \
LDAP_BINDDNPASSWORD='Curiouser' \
LDAP_USER_BASEDN='ou=employee,dc=curiouser,dc=com' \
LDAP_USER_REQUEST='(&(memberOf=cn=sonarqube,ou=applications,dc=curiouser,dc=com))' \
LDAP_USER_REALNAMEATTRIBUTE='sn' \
JVM_CE='-Xmx1024m -Xms512m -XX:+HeapDumpOnOutOfMemoryError' \
JVM_WEB='-Xmx1024m -Xms512m -XX:+HeapDumpOnOutOfMemoryError' \
|oc create -f -


oc delete project/sonarqube  scc/sonarqube-anyuid