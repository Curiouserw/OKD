FROM centos:7.4.1708
MAINTAINER Curiouser

EXPOSE  8080 2181

ADD https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz /opt/
RUN  yum install -y java-1.8.0-openjdk && \
    tar -xf /opt/zookeeper-3.4.13.tar.gz -C /opt/ && \
    rm -rf /opt/zookeeper-3.4.13.tar.gz && \
    yum clean all && \
    useradd noroot -u 1000 -s /bin/bash
COPY dubbo-admin-0.1.jar /opt
COPY zoo.cfg /opt/zookeeper-3.4.13/conf/zoo.cfg
COPY zkServer.sh /opt/zookeeper-3.4.13/bin/zkServer.sh

ENV TZ Asia/Shanghai
ENV LANG en_US.UTF-8
ENV ZOOKEEPER_HOME=/opt/zookeeper-3.4.13
ENV PATH=$PATH:$ZOOKEEPER_HOME/bin


USER 1000
WORKDIR /home/noroot
RUN  chmod 777 /home/noroot