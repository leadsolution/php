#!/bin/sh

EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
  php composer-setup.php
  RESULT=$?
  rm composer-setup.php
  mv composer.phar /usr/local/bin/composer
  composer global require hirak/prestissimo
  exit $RESULT
else
  >&2 echo 'ERROR: Invalid installer signature'
  rm composer-setup.php
  exit 1
fi
