#!/bin/sh

# add wget
apt-get update -yqq && apt-get -f install -yyq wget

# download helper script
# @see https://github.com/mlocati/docker-php-extension-installer/
wget -q -O /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
    || (echo "Failed while downloading php extension installer!"; exit 1)

# install extensions
chmod uga+x /usr/local/bin/install-php-extensions && sync && install-php-extensions \
    opcache \
    bcmath \
    ctype \
    curl \
    dom \
    gd \
    hash \
    iconv \
    intl \
    mbstring \
    openssl \
    pdo_mysql \
    simplexml \
    soap \
    xsl \
    zip \
    sockets \
;
