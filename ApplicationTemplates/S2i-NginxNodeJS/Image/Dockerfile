FROM centos

ENV TZ Asia/Shanghai
ENV LANG en_US.UTF-8

EXPOSE 8080
LABEL io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.k8s.display-name="NodeJS && Nginx" \
      io.openshift.expose-services="80:http" \
      Version="1.0" \
      EXPOSE="8080" 

ADD nginx.repo /etc/yum.repos.d/nginx.repo
ADD node-v8.9.4-linux-x64.tar /opt/nodejs
RUN yum install -y telnet wget net-tools vim nginx-1.12.2 ;yum clean all
RUN useradd -s /sbin/nologin -b /data -M -u 1001 -g 0 -c "Curiouser springcloud applications run user" curiouser ;\
    mkdir -p /data/{apps/src,nginx/logs} 
  

RUN chown -R 1001:0 /data  ;\
    chmod -R g+w /data ;\
    chmod -R 777 /var/log/nginx ;\
    chmod -R 777 /var/cache/nginx

ENV NODEJS_HOME /opt/nodejs/node-v8.9.4-linux-x64
ENV PATH $PATH:$NODEJS_HOME/bin

COPY ./s2i/bin/* /usr/libexec/s2i/

USER 1001
ADD etc /opt/nodejs/node-v8.9.4-linux-x64/etc
CMD /usr/libexec/s2i/usage



