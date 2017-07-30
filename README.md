# Docker environment
Prerequisites
-----
You will require:

- Docker engine for your platfom ([Windows](https://docs.docker.com/docker-for-windows/) [Linux](https://docs.docker.com/engine/installation/#/on-linux) [Mac](https://docs.docker.com/docker-for-mac/install/))
- [Docker-compose](https://docs.docker.com/compose/install/)
- Git client
- [Make](https://en.wikipedia.org/wiki/Make_(software))

Deployment steps
-----
 * Clone the Docker repo:

```
git clone \
git@github.com:ASDAlexey/symfony-base-backend.git \
&& cd docker-symfony
```

 * create .env file from dist: `cp .env.dist .env` 
 * Replace ALL values in `.env` file;
 * Start spinup scenario

```
make docker-env
```
 
 * For additional commands
 
```
make help
```
 * If you need PhpMyAdmin you need uncomment it in docker-compose.yml file. It will be available via http://localhost:8080