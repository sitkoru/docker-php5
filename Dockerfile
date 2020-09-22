FROM php:7.4.10-fpm

ENV LANG=C.UTF-8

RUN apt update && apt install -y \
    libxml2-dev \
    zlib1g-dev \
    libfreetype6 \
    libfreetype6-dev \
    libjpeg62-turbo \
    libjpeg-dev \
    libpng16-16 \
    libpng-dev \
    libxslt1.1 \
    libxslt-dev \
    libpq5 \
    libpq-dev \
    bash-completion \
    wget \
    locales \
    locales-all \
    mysql-client \
    zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install pdo_pgsql pgsql soap zip xsl opcache pcntl gd bcmath pdo_mysql mysqli mysql intl \
    && pecl install redis-4.0.0 \
    && docker-php-ext-enable redis \
    && apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        autoconf \
        binutils \
        gcc \
        libc-dev \
        g++ \
        make \
        libxml2-dev \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libxslt-dev \
        libxml2-dev \
        libpq-dev \
        libicu-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen ru_RU.UTF-8 && \
    update-locale LANG=ru_RU.UTF-8 && \
    echo "LANGUAGE=ru_RU.UTF-8" >> /etc/default/locale && \
    echo "LC_ALL=ru_RU.UTF-8" >> /etc/default/locale

COPY opcache.conf /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

COPY .bashrc /root/.bashrc
COPY .bashrc /var/www/.bashrc

RUN chown -R www-data:www-data /var/www

RUN echo Europe/Moscow | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN rm /usr/local/etc/php-fpm.d/www.conf
COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY php.ini /usr/local/etc/php/

WORKDIR /var/www


CMD ["php-fpm"]
