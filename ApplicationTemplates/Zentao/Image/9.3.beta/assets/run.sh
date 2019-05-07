#!/bin/bash
set -e

htpasswd -b -c /opt/zentaopms/auth/users admin $ADMINER_PASSWORD

echo "<?php" >> /opt/zentaopms/config/my.php
echo "\$config->installed       = true;" >> /opt/zentaopms/config/my.php
echo "\$config->debug           = false;" >> /opt/zentaopms/config/my.php
echo "\$config->requestType     = 'GET';" >> /opt/zentaopms/config/my.php
echo "\$config->db->host        = '$MYSQL_HOST';" >> /opt/zentaopms/config/my.php
echo "\$config->db->port        = '$MYSQL_PORT';" >> /opt/zentaopms/config/my.php
echo "\$config->db->name        = '$MYSQL_DB_NAME';" >> /opt/zentaopms/config/my.php
echo "\$config->db->user        = '$MYSQL_DB_USER';" >> /opt/zentaopms/config/my.php
echo "\$config->db->password    = '$MYSQL_DB_PASSWD';" >> /opt/zentaopms/config/my.php
echo "\$config->db->prefix      = 'zt_';" >> /opt/zentaopms/config/my.php
echo "\$config->webRoot         = getWebRoot();" >> /opt/zentaopms/config/my.php
for ((i=1;i<=3;i++)) ;do
  sleep 6s ; 
  echo "正在进行第$i次MySQL数据库初始连接" ;
  if [[ `php /assets/init_db.php` =~ "Connected to MySQL Server" ]] ;then
    echo "第$i次对MySQL数据库初始化成功，接下来启动Apache服务器。" ;
    /usr/sbin/apachectl start ;
    tail -f /var/log/httpd/error_log /var/log/httpd/access_log ;
    exit ;
  fi
  echo "第$i次尝试MySQL数据库初始化失败！" ;
done
echo "3次尝试MySQL数据库初始化失败，请检查MySQL数据库实例是否正常提供服务。"
exit
