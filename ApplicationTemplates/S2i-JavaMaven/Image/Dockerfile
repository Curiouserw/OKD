FROM centos

EXPOSE 8080
ENV MAVEN_VERSION 3.3.3
ENV TZ Asia/Shanghai
ENV JVM_OPTS -Xmx512M
ENV LANG en_US.UTF-8
LABEL io.k8s.description="Platform include Oracle Java and Apache Maven  for building and running Spring Boot Applications" \
      io.k8s.display-name="Java 8 Maven 3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,java8,maven,maven3" \
      Author="Curiouser" \
      Version="1.0" \
      EXPOSE="8080" \
      MavenVersion="Apache-maven-3.3.3" \
      JavaVersion="oracle-jdk-1.8.111" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


ADD apache-maven-3.3.3.tar /opt/maven
ADD jdk-8u111-linux-x64.tar.gz /opt/jdk

RUN yum install telnet vim -y;\
    yum clean all ;\
    mkdir -p /data/apps/{src,jars} ;\ 
    useradd -s /sbin/nologin -b /data/apps/ -M -u 1001 -g 0 -c "Curiouser SpringCloud applications run user" curiouser;\
    ln -s /opt/maven/apache-maven-3.3.3/bin/mvn /usr/bin/mvn

ADD repository.tar /data/apps/
RUN chown -R 1001:0 /data/apps/ ;\
    chmod g+w /data/apps/

ENV MAVEN_HOME /opt/maven/apache-maven-3.3.3
ENV JAVA_HOME /opt/jdk/jdk1.8.0_111
ENV PATH $PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin

ADD settings.xml /opt/maven/apache-maven-3.3.3/conf/
COPY ./s2i/bin/ /usr/libexec/s2i
USER 1001
CMD /usr/libexec/s2i/usage
