#!/bin/sh


test -d /data/ssl || mkdir /data/ssl

mkdir -p /var/lib/haproxy/dev
logadm -C 10 -p 1d -a 'kill -HUP `cat /var/run/*syslog*.pid`' -w haproxy /var/log/haproxy/*.log

/usr/sbin/svcadm enable svc:/pkgsrc/haproxy:default
