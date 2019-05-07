FROM stpork/bamboo-centos-base

MAINTAINER stpork from Mordor team

ENV JIRA_VERSION=7.5.2 \
JIRA_INSTALL=/opt/atlassian/jira \
JIRA_HOME=/var/atlassian/application-data/jira \
JIRA_SHARED_HOME=/var/atlassian/application-data/jira/shared \
RUN_USER=daemon \
RUN_GROUP=daemon \
M2_HOME=/usr/local/maven \
GRADLE_HOME=/usr/local/gradle \
JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk/jre \
JIRA_CLUSTER_CONFIG="/var/atlassian/application-data/jira/cluster.properties" \
TZ=Asia/Shanghai \
LANG=en_US.UTF-8


LABEL io.k8s.description="Atlassian JIRA"
LABEL io.k8s.display-name="JIRA ${JIRA_VERSION}"
LABEL io.openshift.expose-services="8080:http"

USER root

RUN JIRA_URL=https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz \
&& M2_URL=https://bitbucket.org/stpork/bamboo-agent/downloads/settings.xml \
&& mkdir -p ${JIRA_INSTALL} \
&& mkdir -p ${JIRA_HOME} \
&& curl -fsSL ${JIRA_URL} | tar -xz --strip-components=1 -C "${JIRA_INSTALL}" \
&& echo -e "\njira.home=${JIRA_HOME}" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
&& chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL} \
&& chmod -R 777 ${JIRA_INSTALL} \
&& chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_HOME} \
&& chmod -R 777 ${JIRA_HOME} \
&& yum update -y \
&& yum install -y git wget openssl unzip nano net-tools tini telnet which dejavu-* \
&& yum clean all \
&& rm -rf /var/cache/yum


USER ${RUN_USER}:${RUN_GROUP}

EXPOSE 8080

VOLUME ["${JIRA_HOME}/shared"]

WORKDIR ${JIRA_HOME}

COPY entrypoint.sh /entrypoint.sh
COPY check-java.sh "${JIRA_INSTALL}/bin/check-java.sh"

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/usr/bin/tini", "--"]

