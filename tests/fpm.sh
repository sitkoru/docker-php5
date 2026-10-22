#!/bin/sh
set -eu
printf '<?php echo "fpm:" . PHP_VERSION;' > /tmp/fpm-check.php
php-fpm -F &
fpm_pid=$!
trap 'kill "$fpm_pid"; wait "$fpm_pid" || true; rm -f /tmp/fpm-check.php' EXIT
attempt=0
while [ "$attempt" -lt 50 ]; do
    if SCRIPT_FILENAME=/tmp/fpm-check.php REQUEST_METHOD=GET \
       cgi-fcgi -bind -connect 127.0.0.1:9000 > /tmp/fpm-response 2>/dev/null; then
        grep -q 'fpm:5.6.40' /tmp/fpm-response
        echo 'FPM executes request: OK'
        exit 0
    fi
    attempt=$((attempt + 1))
    sleep 0.1
done
exit 1
