#!/bin/bash

cat <<EOF > app/config/parameters.yml
parameters:
    database_host: db
    database_port: 3306
    database_name: $MYSQL_DATABASE
    database_user: $MYSQL_USER
    database_password: $MYSQL_PASSWORD
    mailer_transport: smtp
    mailer_host: 127.0.0.1
    mailer_user: null
    mailer_password: null
    secret: $SYMFONY_SECRET
    product_image:
        uri_prefix: /images/products/
        upload_destination: '%kernel.root_dir%/../web/images/products'
EOF