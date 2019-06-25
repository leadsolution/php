FROM php:7.3-apache

ADD vhost.conf /etc/apache2/sites-available/000-default.conf
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apt-get update && apt-get install -y wget git unzip libxml2-dev libzip-dev
RUN docker-php-ext-install -j$(nproc) mbstring pdo_mysql zip soap json dom

RUN a2enmod rewrite

ADD install_composer.sh /usr/local/bin/install_composer.sh
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN /usr/local/bin/install_composer.sh
