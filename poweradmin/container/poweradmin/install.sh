#!/usr/bin/env bash
set -ex
apt-get -q update && \
    apt install -y curl wget lsb-release apt-transport-https ca-certificates

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" |  tee /etc/apt/sources.list.d/php7.3.list
apt-get update && \
        apt-get install -y apache2  \
            php7.3  \
            php7.3-cli \
            php7.3-fpm \
            php7.3-json \
            php7.3-pdo \
            php7.3-mysql \
            php7.3-zip \
            php7.3-gd  \
            php7.3-mbstring \
            php7.3-curl \
            php7.3-xml \
            php7.3-bcmath \
            php7.3-json \
            gettext \
            mcrypt \
            libapache2-mod-php7.3

curl -sLo poweradmin-${POWERADMIN_VERSION}.tgz http://freefr.dl.sourceforge.net/project/poweradmin/poweradmin-${POWERADMIN_VERSION}.tgz && \
    tar xf poweradmin-${POWERADMIN_VERSION}.tgz -C /tmp && \
    rm -f /var/www/html/* && \
    mv /tmp/poweradmin-${POWERADMIN_VERSION}/* /var/www/html/ && \
    cp /var/www/html/inc/config-me.inc.php /var/www/html/config.inc.php && \
    rm -rf /var/www/html/install && \
    chown -R www-data:www-data /var/www