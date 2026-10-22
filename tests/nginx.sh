#!/bin/sh
set -eu
nginx -t
nginx -v 2>&1 | grep -q 'nginx/1.30.6'
nginx -V 2>&1 | grep -q 'OpenSSL 3.5.9'
# Nginx uses its static OpenSSL; PHP keeps its original shared-library ABI.
if ldd /usr/sbin/nginx | grep -Eq 'lib(ssl|crypto)\.'; then exit 1; fi
command -v msmtp
[ "$(getent passwd www-data | cut -d: -f3,6)" = '33:/var/www' ]
attempt=0
while [ "$attempt" -lt 50 ]; do
    if response=$(curl --fail --silent --max-time 2 http://127.0.0.1/); then
        [ "$response" = 'nginx:5.6.40' ]
        [ "$(cat /tmp/php5-hook-check)" = 'hook executed' ]
        echo 'Nginx to PHP and startup hook: OK'
        exit 0
    fi
    attempt=$((attempt + 1))
    sleep 0.1
done
exit 1
