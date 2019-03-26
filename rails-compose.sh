#!/bin/sh

touch .env

touch Gemfile.lock

# Full stack
# docker-compose run api rails new . --database=mysql

# API
docker-compose run --rm api rails new . --database=postgresql --api 

sleep 5 

docker-compose build --force-rm

sleep 5

docker-compose up -d

docker-compose exec api bash -c 'column=$(grep -n "encoding:" config/database.yml | cut -f 1 -d ":") && column=$((column + 1)) && sed -ie "${column}i username: postgres" config/database.yml'
docker-compose exec api bash -c 'sed -ie "s/username: postgres/  username: postgres/" config/database.yml'

docker-compose exec api bash -c 'column=$(grep -n "encoding:" config/database.yml | cut -f 1 -d ":") && column=$((column + 2)) && sed -ie "${column}i host: db" config/database.yml'
docker-compose exec api bash -c 'sed -ie "s/host: db/  host: db/" config/database.yml'

docker-compose exec api rails db:create

