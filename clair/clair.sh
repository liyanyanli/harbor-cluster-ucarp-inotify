#!/usr/bin/env bash

cd $1/build/clair

#load docker images
docker load -i ../../release/docker/clair-clair.tar

docker load -i ../../release/docker/clair-postgres.tar

#cp ./docker-compose.yml $HOME/docker-compose.yml

/usr/local/bin/docker-compose down

mkdir clair_config

cp ./config.yaml ./clair_config/config.yaml

/usr/local/bin/docker-compose -f docker-compose.yml up --build -d

sleep 60

docker start clair_clair

sleep 60

docker cp ../../release/docker/init.sql clair_postgres:/

docker exec -it clair_postgres psql -d postgres -U postgres -f /init.sql

docker cp ../../release/docker/clair.sql clair_postgres:/

docker exec -it clair_postgres psql -d postgres -U postgres -f /clair.sql

