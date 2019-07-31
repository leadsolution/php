FROM php:7.3-apache

ADD vhost.conf /etc/apache2/sites-available/000-default.conf
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apt-get update && apt-get install -y \
  wget git unzip libxml2-dev libzip-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) mbstring pdo_mysql zip soap json dom gd

RUN a2enmod rewrite

ADD install_composer.sh /usr/local/bin/install_composer.sh
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN /usr/local/bin/install_composer.sh

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
