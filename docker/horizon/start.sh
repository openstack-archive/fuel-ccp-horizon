#!/bin/bash

/var/lib/microservices/venv/bin/python \
    /var/lib/microservices/venv/bin/manage.py compress --force

source /etc/apache2/envvars

DASHBOARD="/etc/openstack-dashboard/local_settings"
BACKEND="django.core.cache.backends.memcached.MemcachedCache"

if [ -z "$HORIZON_SECRET_KEY" ]; then
    KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    HORIZON_SECRET_KEY=$KEY
fi

if [ -z "$KEYSTONE_ADDRESS" ]; then
    KEYSTONE_ADDRESS="127.0.0.1"
fi

sed -i "s/Secret_String/${HORIZON_SECRET_KEY}/g" $DASHBOARD
sed -i "s/KEYSTONE_ADDRESS/${KEYSTONE_ADDRESS}/g" $DASHBOARD

if [ -n "$MEMCACHED_LOCATION" ]; then
    CONF="{'default':{'BACKEND':'$BACKEND','LOCATION':'$MEMCACHED_LOCATION',},}"
    sed -i 's/^CACHES = .*$/CACHES = $CONF/g' $DASHBOARD
fi

#check if keystone is alive
nc -z -v -w5 ${KEYSTONE_ADDRESS} 5000
if [ $? -ne 0 ];then
    exit 1
fi


exec /usr/sbin/apache2 -DNO_DETACH
