FROM centos:6

EXPOSE 80


RUN yum install -y httpd php php-mysql php-pdo php-pdo_mysql ;\
    yum clean all ;\
    sed -i -e 's/post_max_size = 8M/post_max_size = 10M/' -e 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php.ini ;\
    curl -# http://dl.cnezsoft.com/zentao/10.0/ZenTaoPMS.10.0.stable.zbox_64.tar.gz -o /tmp/ZenTaoPMS.10.0.stable.zbox_64.tar.gz ;\
    tar -zxvf /tmp/ZenTaoPMS.10.0.stable.zbox_64.tar.gz -C /tmp;\
    rm -rf /tmp/ZenTaoPMS.10.0.stable.zbox_64.tar.gz ;\
    cp -r /tmp/zbox/app/adminer/  /opt ;\
    rm -rf /tmp/zbox ;\
    rm -rf /var/www/html ;\
    ln -s /opt/adminer /var/www/html ;\
    mkdir /etc/httpd/auth ;\
    echo "Alias /adminer "/var/www/html"" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "<Directory "/var/www/html/">" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "  AuthName 'zentao adminer'" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "  AuthType Basic" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "  AuthUserFile /etc/httpd/auth/users" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "  require user admin" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "  <Files "index.php">" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "    SetHandler application/x-httpd-php" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "  </Files>" >> /etc/httpd/conf.d/adminer.conf ;\
    echo "</Directory>" >> /etc/httpd/conf.d/adminer.conf

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]