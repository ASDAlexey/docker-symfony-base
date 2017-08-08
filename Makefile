#!make
include .env
export $(shell sed 's/=.*//' .env)

.PHONY: clone rebuild up stop restart status console-app console-db console-nginx clean help

docker-env: clone symfony-parameters nginx-config up migration composer-install status

dialog:
	@. ./dialog.sh

nginx-config:
	@echo "\n\033[1;m Please use your local sudo password.\033[0m"
	@. ./nginx-config.sh

symfony-parameters:
	@echo "\n\033[1;m Preparing config files (using .env file parameters)... \033[0m"
	@. ./symfony_config.sh

xdebug-parameters:
	@. ./xdebug-ini.sh

clone:
	@echo "\n\033[1;m Cloning App (${BRANCH_NAME} branch) \033[0m"
	@if cd src 2> /dev/null; then git pull; else git clone -b ${BRANCH_NAME} ${GIT_URL} src; fi

pull:
	@$(MAKE) --no-print-directory clone
	@$(MAKE) --no-print-directory composer-install
	@$(MAKE) --no-print-directory cache-clear

rebuild: stop
	@echo "\n\033[1;m Rebuilding containers... \033[0m"
	@docker-compose build --no-cache
up:
	@echo "\n\033[1;m Spinning up containers for Local dev environment... \033[0m"
	@docker-compose up -d 
	@$(MAKE) --no-print-directory status

hosts:
	@echo "\n\033[1;m Adding record in to your local /etc/hosts file.\033[0m"
	@echo "\n\033[1;m Please use your local sudo password.\033[0m"
	@echo '127.0.0.1 localhost '${SERVER_NAME}' www.'${SERVER_NAME}''| sudo tee -a /etc/hosts
	@echo "\n\033[1;m Your app available here ${APP_NAME}-${BRANCH_NAME}.umbrella-web.com \033[0m"

stop:
	@echo "\n\033[1;m  Halting containers... \033[0m"
	@docker-compose stop
	@$(MAKE) --no-print-directory status

restart:
	@echo "\n\033[1;m Restarting containers... \033[0m"
	@docker-compose stop
	@docker-compose up -d
	@$(MAKE) --no-print-directory status

cache-clear:
	@docker-compose exec app bash -c "cd /var/www/html/${APP_NAME}/ && php ./bin/console cache:clear --env=prod"
	@docker-compose exec app bash -c "cd /var/www/html/${APP_NAME}/ && php ./bin/console cache:clear"
status:
	@echo "\n\033[1;m Containers statuses \033[0m"
	@docker-compose ps

clean:
	@echo "\033[1;31m*** Removing containers and Application (./src)... ***\033[0m"
	@$(MAKE) --no-print-directory dialog
	@docker-compose down --rmi all 2> /dev/null
	@rm -rf src/
	@$(MAKE) --no-print-directory status

console-app:
	@docker-compose exec app bash
console-db:
	@docker-compose exec db bash
console-nginx:
	@docker-compose exec web-srv bash

composer-install:
	@docker-compose exec app bash -c "cd /var/www/html/${APP_NAME}/ && composer install"
	@$(MAKE) --no-print-directory permissions

migration:
	@docker-compose exec app bash -c "cd /var/www/html/${APP_NAME}/ && ./bin/console doctrine:migrations:migrate && php ./bin/console doctrine:fixtures:load"
	@$(MAKE) --no-print-directory permissions

permissions:
	@docker-compose exec app bash -c "chmod -R 755 /var/www/html/${APP_NAME}/var/cache /var/www/html/${APP_NAME}/var/logs"
	@docker-compose exec app bash -c "chown -R www-data:www-data /var/www/html/${APP_NAME}/var/cache /var/www/html/${APP_NAME}/var/logs"

schema-update:
	@docker-compose exec app bash -c "cd /var/www/html/${APP_NAME}/ && php bin/console doctrine:schema:update --force"

logs-nginx:
	@docker-compose logs --tail=100 -f web-srv
logs-app:
	@docker-compose logs --tail=100 -f app
logs-db:
	@docker-compose logs --tail=100 -f db

help:
	@echo "clone\t\t\t- clone dev or staging repositories"
	@echo "rebuild\t\t\t- build containers w/o cache"
	@echo "up\t\t\t- start project"
	@echo "stop\t\t\t- stop project"
	@echo "restart\t\t\t- restart containers"
	@echo "status\t\t\t- show status of containers"
	@echo "nginx-config\t\t\t- generates nginx config file based on .env parameters"
	@echo "composer-install\t- install dependencies via composer"
	@echo "schema-update\t\t- update database schema"
	@echo "\033[1;31mclean\t\t\t- !!! Purge all Local application data!!!\033[0m"

	@echo "\n\033[1;mConsole section\033[0m"
	@echo "console-app\t\t- run bash console for dev application container"
	@echo "console-db\t\t- run bash console for mysql container"
	@echo "console-nginx\t\t- run bash console for web server container"

	@echo "\n\033[1;mLogs section\033[0m"
	@echo "logs-nginx\t\t- show web server logs"
	@echo "logs-db\t\t\t- show database logs"
	@echo "logs-app\t\t- show VirMuze dev logs"
	@echo "\n\033[0;33mhelp\t\t\t- show this menu\033[0m"
