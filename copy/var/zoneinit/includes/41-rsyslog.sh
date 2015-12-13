#!/bin/sh

# Pacakge overrides our copied file
mv /opt/local/etc/rsyslog_haproxy.conf /opt/local/etc/rsyslog.conf

/usr/sbin/svcadm disable svc:/system/system-log:default
/usr/sbin/svcadm enable svc:/pkgsrc/rsyslog:default
