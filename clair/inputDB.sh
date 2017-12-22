#!/usr/bin/env bash

cd $1/build/clair

docker cp ../../release/docker/clair.sql clair_postgres:/

docker exec -it clair_postgres psql -d postgres -U postgres -f /clair.sql

  
