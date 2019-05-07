#!/bin/bash

sh /data/apollo/configservice/scripts/startup.sh
sh /data/apollo/adminservice/scripts/startup.sh
tail -f /data/apollo/adminservice/logs/apollo-adminservice.log /data/apollo/configservice/logs/apollo-configservice.log
