#!/bin/bash
set -e


htpasswd -b -c /etc/httpd/auth/users admin $ADMINER_PASSWORD
/usr/sbin/apachectl start
tail -f /var/log/httpd/error_log /var/log/httpd/access_log