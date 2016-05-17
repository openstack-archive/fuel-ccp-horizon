#!/bin/bash

/var/lib/microservices/venv/bin/python /var/lib/microservices/venv/bin/manage.py compress --force

source /etc/apache2/envvars

sed -i "s/Secret_String/${HORIZON_SECRET_KEY}" /etc/openstack-dashboard/local_settings
sed -i "s/KEYSTONE_ADDRESS/${KEYSTONE_ADDRESS}" /etc/openstack-dashboard/local_settings

exec /usr/sbin/apache2 -DNO_DETACH
