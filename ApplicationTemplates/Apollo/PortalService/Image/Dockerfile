FROM centos:7.5.1804


EXPOSE 8080

ENV TZ Asia/Shanghai
ENV LANG en_US.UTF-8

COPY jdk-8u181-linux-x64.rpm /root/

RUN mkdir -p /data/apolloportal/logs &&\
    useradd -s /sbin/nologin -d /data/apolloportal -M -u 10001 -c "The user who run apollo portal application" apolloportal &&\
    yum localinstall -y /root/jdk-8u181-linux-x64.rpm &&\
    rm -rf /root/jdk-8u181-linux-x64.rpm &&\
    yum clean all


COPY app /data/apolloportal/
RUN chown -R 10001:10001 /data/apolloportal

USER 10001

CMD /data/apolloportal/scripts/startup.sh

