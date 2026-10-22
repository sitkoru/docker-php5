#!/bin/sh
set -eux
cd /tmp
curl -fsSL https://nginx.org/download/nginx-1.30.6.tar.gz -o nginx.tar.gz
echo '3cf46f5ed7504d460125866b7bea99fb357f31d887e2e63b35503310e9b8b6c8  nginx.tar.gz' | sha256sum -c -
curl -fsSL https://github.com/openssl/openssl/releases/download/openssl-3.5.9/openssl-3.5.9.tar.gz -o openssl.tar.gz
echo '603f5602e2eef00d77fbd429d34dcd5822bb301757a1bc9cdb24c670f1eb859a  openssl.tar.gz' | sha256sum -c -
tar -xzf nginx.tar.gz
tar -xzf openssl.tar.gz
cd nginx-1.30.6
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid \
    --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=www-data --group=www-data \
    --with-http_ssl_module --with-http_realip_module --with-http_v2_module \
    --with-openssl=/tmp/openssl-3.5.9 --with-openssl-opt='no-shared no-tests'
make -j2
make install DESTDIR=/nginx-root
