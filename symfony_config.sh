#!/bin/bash
{ \
    echo 'parameters:'; \
    echo '  database_host: db'; \
    echo '  database_port: 3306'; \
    echo '  database_name: '${MYSQL_DATABASE}''; \
    echo '  database_user: '${MYSQL_USER}''; \
    echo '  database_password: '${MYSQL_PASSWORD}''; \
}| tee ./app/config/parameters.yml