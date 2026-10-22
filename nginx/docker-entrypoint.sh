#!/bin/bash
set -e
if [ -n "${APP_BEFORE_START_SCRIPT:-}" ] && [ -f "$APP_BEFORE_START_SCRIPT" ]; then
    bash "$APP_BEFORE_START_SCRIPT"
fi
php-fpm -F &
php_pid=$!
nginx -g 'daemon off;' &
nginx_pid=$!
trap 'kill "$php_pid" "$nginx_pid" 2>/dev/null || true; wait || true' EXIT
trap 'exit 0' TERM INT
wait -n "$php_pid" "$nginx_pid"
