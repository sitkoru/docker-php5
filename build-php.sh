#!/bin/sh
set -eux
cd /usr/src
echo '1369a51eee3995d7fbd1c5342e5cc917760e276d561595b6052b21ace2656d1c  php.tar.xz' | sha256sum -c -
docker-php-source extract
cd /usr/src/php
for patch_file in /patches/*.patch; do patch -p1 --fuzz=0 < "$patch_file"; done
export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"
gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"
if [ ! -d /usr/include/curl ] && [ ! -e /usr/local/include/curl ]; then
    ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl
fi
./configure --build="$gnuArch" \
    --with-config-file-path="$PHP_INI_DIR" --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --enable-option-checking=fatal --with-mhash --enable-ftp --enable-mbstring --enable-mysqlnd \
    --with-curl --with-libedit --with-openssl --with-zlib --with-libdir="lib/$debMultiarch" \
    --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --disable-cgi
make -j2
make install
