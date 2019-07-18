FROM centos

EXPOSE 8080

ENV MAVEN_VERSION=apache-3.3.3 \
    JAVA_VERSION=oracle-1.8.0_202 \
    TZ=Asia/Shanghai \
    JVM_OPTS=-Xmx512M \
    LANG=en_US.UTF-8 \
    MAVEN_HOME=/opt/maven/apache-maven-3.3.3 \
    JAVA_HOME=/opt/jdk/jdk1.8.0_202
ENV PATH $PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin


LABEL io.k8s.description="Platform include Oracle Java  for building and running Spring Boot applications" \
      io.k8s.display-name="Java 8 Maven 3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,java8,maven,maven3" \
      Author="Curiouser" \
      Version="1.0" \
      EXPOSE="8080" \
      MavenVersion="Apache-maven-3.3.3" \
      JavaVersion="oracle-jdk-1.8.202" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


ADD apache-maven-3.3.3.tar /opt/maven
ADD jdk-8u202-linux-x64.tar.gz /opt/jdk
ADD settings.xml /opt/maven/apache-maven-3.3.3/conf/
ADD elastic-apm-agent-1.7.0.jar /opt/apm/

RUN yum install telnet net-tools -y ;\
    yum clean all ;\
    mkdir -p /data/apps/{src,jars} ;\
    useradd -s /sbin/nologin -b /data/apps -M -u 1001 -c "Curiouser openshift s2i run user" curiouser

ADD repository.tar /data/apps/
RUN chown -R 1001:1001 /data/apps/ ;\
    chmod g+w /data/apps/


COPY local_policy.jar /opt/jdk/jdk1.8.0_202/jre/lib/security/
COPY US_export_policy.jar /opt/jdk/jdk1.8.0_202/jre/lib/security/
COPY ./s2i/bin/ /usr/libexec/s2i


USER 1001
CMD /usr/libexec/s2i/usage