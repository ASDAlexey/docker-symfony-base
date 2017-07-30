#!/bin/bash
REMOTE_HOST="$(ipconfig getifaddr en0)"
{ \
    echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so'; \
    echo 'xdebug.remote_enable=1'; \
    echo 'xdebug.remote_autostart=0'; \
    echo 'xdebug.remote_connect_back=0'; \
    echo 'xdebug.remote_host='${REMOTE_HOST}''; \
    echo 'xdebug.remote_port=9009'; \
    echo 'xdebug.idekey=PHPSTORM'; \
    echo 'xdebug.remote_log=/tmp/php7.1-xdebug.log'; \
}| tee ./app/config/conf.d/docker-php-ext-xdebug.ini