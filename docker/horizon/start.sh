#!/bin/bash

/var/lib/microservices/venv/bin/python \
    /var/lib/microservices/venv/bin/manage.py compress --force

source /etc/apache2/envvars

sed -i "s/Secret_String/${HORIZON_SECRET_KEY}/g" \
    /etc/openstack-dashboard/local_settings
sed -i "s/KEYSTONE_ADDRESS/${KEYSTONE_ADDRESS}/g" \
    /etc/openstack-dashboard/local_settings

#check does keyston is alive
nc -z -v -w5 ${KEYSTONE_ADDRESS} 5000
if [ $? -ne 0 ];then
    exit 1
fi


exec /usr/sbin/apache2 -DNO_DETACH
