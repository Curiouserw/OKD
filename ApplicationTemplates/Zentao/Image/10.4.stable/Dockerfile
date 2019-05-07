FROM centos:latest

EXPOSE 80

RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum install -y unzip telnet vim net-tools zip httpd php56w php56w-pdo php56w-pdo_mysql php56w-json php56w-filter php56w-openssl php56w-mbstring php56w-zlib  php56w-curl php56w-gd php56w-iconv && \
    sed -i -e 's/post_max_size = 8M/post_max_size = 10M/' -e 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php.ini && \

    curl -# http://dl.cnezsoft.com/zentao/10.4/ZenTaoPMS.10.4.stable.zip -o /tmp/ZenTaoPMS.10.4.stable.zip && \
    unzip /tmp/ZenTaoPMS.10.4.stable.zip -d /opt && \
    rm -rf  /tmp/ZenTaoPMS.10.4.stable.zip && \
    curl -# http://dl.cnezsoft.com/zentao/10.4/ZenTaoPMS.10.4.stable.zbox_64.tar.gz -o /tmp/ZenTaoPMS.10.4.stable.zbox_64.tar.gz && \
    tar -zxvf /tmp/ZenTaoPMS.10.4.stable.zbox_64.tar.gz -C /tmp && \
    rm -rf  /tmp/ZenTaoPMS.10.4.stable.zbox_64.tar.gz && \
    cp -r /tmp/zbox/app/adminer/ /opt/zentaopms/www/ && \
    rm -rf /tmp/zbox && \
    mkdir /opt/zentaopms/auth && \
    echo "Alias /adminer "/opt/zentaopms/www/adminer"" >> /etc/httpd/conf.d/adminer.conf && \
    echo "<Directory "/opt/zentaopms/www/adminer">" >> /etc/httpd/conf.d/adminer.conf && \
    echo "  AuthName 'zentao adminer'" >> /etc/httpd/conf.d/adminer.conf && \
    echo "  AuthType Basic" >> /etc/httpd/conf.d/adminer.conf && \
    echo "  AuthUserFile /opt/zentaopms/auth/users" >> /etc/httpd/conf.d/adminer.conf && \
    echo "  require user admin" >> /etc/httpd/conf.d/adminer.conf && \
    echo "  <Files "index.php">" >> /etc/httpd/conf.d/adminer.conf && \
    echo "    SetHandler application/x-httpd-php" >> /etc/httpd/conf.d/adminer.conf && \
    echo "  </Files>" >> /etc/httpd/conf.d/adminer.conf && \
    echo "</Directory>" >> /etc/httpd/conf.d/adminer.conf && \
    rm -rf /var/www/html && \
    ln -s /opt/zentaopms/www/ /var/www/html && \
    rm -rf /opt/zentaopms/www/{upgrade.php,install.php} && \
    yum clean all
COPY assets /assets/
ENTRYPOINT ["/assets/run.sh"]
