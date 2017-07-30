#!/bin/bash
{ \
	echo 'server {'; \
	echo '    listen 80 default_server;'; \
	echo '    root /var/www/html/'$APP_NAME'/web;'; \
	echo '    index app.php;'; \
	echo ; \
	echo '	server_name '$SERVER_NAME';'; \
    echo '  location / {'; \
    echo '      try_files $uri /app.php$is_args$args;'; \
    echo '  }'; \
	echo '	location ~ ^/app\.php(/|$) {'; \
	echo '                fastcgi_split_path_info ^(.+\.php)(/.*)$;'; \
	echo '                fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;'; \
	echo '                fastcgi_param DOCUMENT_ROOT $realpath_root;'; \
	echo '                fastcgi_index app.php;'; \
	echo '                include fastcgi_params;'; \
	echo '                fastcgi_pass app:9000;'; \
	echo '                fastcgi_param APP_ENVIRONMENT '$APP_ENV';'; \
	echo '		}'; \
	echo '}'; \
}| tee nginx/configs/conf.d/$APP_NAME.conf