#!/bin/bash

docker run --name postgresql-master -itd --restart always -p 15432:5432 \
  --env 'DB_USER=dbuser' --env 'DB_PASS=dbuserpass' --env 'DB_NAME=dbname' \
  --env 'REPLICATION_USER=repluser' --env 'REPLICATION_PASS=repluserpass' \
  sameersbn/postgresql:9.4-18


docker run --name postgresql-slave01 -itd --restart always \
    --link postgresql-master:master -p 25432:5432 \
    --env 'REPLICATION_MODE=slave' --env 'REPLICATION_SSLMODE=prefer' \
    --env 'REPLICATION_HOST=master' --env 'REPLICATION_PORT=5432'  \
    --env 'REPLICATION_USER=repluser' --env 'REPLICATION_PASS=repluserpass' \
    sameersbn/postgresql:9.4-18
