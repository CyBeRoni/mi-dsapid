#!/bin/sh

# Do we need to register an account?
quickstart=0
test -f /data/ssl/acme/conf/target || quickstart=1

test -d /data/ssl/acme/conf || mkdir -p /data/ssl/acme/conf
test -d /var/lib || mkdir /var/lib
ln -s /data/ssl/acme /var/lib

cat > /data/ssl/acme/conf/responses <<EOF
"acme-enter-email": ""
"acme-agreement:https://letsencrypt.org/documents/LE-SA-v1.1.1-August-1-2016.pdf": true
"acmetool-quickstart-choose-server": https://acme-v01.api.letsencrypt.org/directory
"acmetool-quickstart-choose-method": listen
"acmetool-quickstart-complete": true
"acmetool-quickstart-install-cronjob": false
"acmetool-quickstart-install-haproxy-script": false
"acmetool-quickstart-install-redirector-systemd": false
"acmetool-quickstart-key-type": rsa
"acmetool-quickstart-rsa-key-size": 2048
"acmetool-quickstart-ecdsa-curve": nistp256
EOF

cat > /data/ssl/acme/conf/perm <<EOF
keys 0640 0710 0 6
EOF

# Do quickstart to register an account
if [ $quickstart -eq 1 ]; then
	/opt/local/bin/acmetool quickstart --batch
fi

# Request the primary hostnames
hostname=$(mdata-get sdc:hostname).$(mdata-get sdc:dns_domain)
/opt/local/bin/acmetool want $hostname 

# Renew every week
echo '14 5 * * 0 /opt/local/bin/acmetool reconcile' >> /etc/cron.d/crontabs/root
