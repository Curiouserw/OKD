FROM centos:7.4.1708

ENV TZ=Asia/Shanghai \
    LANG=en_US.UTF-8 \
    JDK_VERSION=Oracle_1.8.0_171 \
    MAVEN_VERSION=Apache_3.6.1 \
    HOME=/home/jenkins \
    MAVEN_HOME=/opt/apache-maven-3.6.1 \
    JAVA_HOME=/opt/jdk1.8.0_171 \
    SONARSCANNER_HOME=/opt/sonar-scanner-3.3.0.1492-linux

COPY jdk1.8.0_171 /opt/jdk1.8.0_171
COPY apache-maven-3.6.1 /opt/apache-maven-3.6.1
COPY helm /usr/bin/helm
COPY sonar-scanner-3.3.0.1492-linux  /opt/sonar-scanner-3.3.0.1492-linux
RUN curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo \
  && yum makecache \
  && yum install -y git docker-ce-cli  \
  && yum clean all \
  && groupadd -g 1000 jenkins \
  && useradd -c "Jenkins user" -d /home/jenkins -u 1000 -g 0 -m jenkins \
  && chmod -R 777 /home/jenkins \
  && ln -s /opt/jdk1.8.0_171/bin/java /usr/bin/java \
  && ln -s /opt/apache-maven-3.6.1/bin/mvn /usr/bin/mvn \
  && ln -s /opt/sonar-scanner-3.3.0.1492-linux/bin/sonar-scanner /usr/bin/sonar-scanner

USER jenkins

WORKDIR /home/jenkins
COPY dumb-init /usr/bin/dumb-init
ADD run-jnlp-client /usr/bin/
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/run-jnlp-client"]