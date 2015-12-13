#!/bin/sh

/usr/sbin/svcadm disable svc:/system/system-log:default
/usr/sbin/svcadm enable svc:/pkgsrc/rsyslog:default
