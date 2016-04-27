#!/bin/bash
if [ -f .env ]; then
    source .env
fi

if [ -z $PROJECT ]; then
    PROJECT="pgsteroids"
fi
if [ -z $USERNAME ]; then
    USERNAME="vasya"
fi

DATABASE=$1

docker stop pghero-$USERNAME-$PROJECT
docker rm -f pghero-$USERNAME-$PROJECT

echo "PGHero will monitor ${DATABASE}"
echo "PGHero try to link container with postgres-$USERNAME-$PROJECT"

docker run -d $DNSOPTIONS --restart="on-failure:1" --name=pghero-$USERNAME-$PROJECT \
        --link postgres-$USERNAME-$PROJECT:db \
        -e DATABASE_URL=postgres://postgres@db:5432/$DATABASE -p 9999:8080 bmorton/pghero
