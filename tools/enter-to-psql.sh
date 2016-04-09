#!/bin/bash

if [ -f .env ]; then
    source ./../.env
fi

if [ -z $PROJECT ]; then
    PROJECT="pgsteroids"
fi
if [ -z $USERNAME ]; then
    USERNAME="vasya"
fi

docker exec -it postgres-$USERNAME-$PROJECT su postgres -c psql
