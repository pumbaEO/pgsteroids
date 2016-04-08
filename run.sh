#!/bin/bash
if [ -f .env ]; then
    source .env
fi

#set -e
#set the DEBUG env variable to turn on debugging
[[ -n "$DEBUG" ]] && set -x

if [ -z $ROOT ]; then
    ROOT=/srv/main
fi
if [ -z $LOGSROOT ]; then
  LOGSROOT=/srv/extension
fi
if [ -z $V8SYSTEMSPACE ]; then
  V8SYSTEMSPACE=/srv/second
fi
if [ -z $PGMAJOR ]; then
    PGMAJOR=9.4
fi

if [ -z $PROJECT ]; then
    PROJECT="pgsteroids"
fi
if [ -z $USERNAME ]; then
    USERNAME="vasya"
fi
if [ -z $USERPASSW ]; then
    USERPASSW="123456"
fi

if [ -z $INTERFACE ]; then
    if test -d /vagrant; then
        INTERFACE=eth1
    else
        INTERFACE=eth0
    fi
fi

INTERNAL=$(ip addr show $INTERFACE | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
IPCONSUL=$INTERNAL

if [ -d $ROOT/$USERNAME/$PROJECT ]; then
    echo "data directory is allready exist"
else
    sudo mkdir -p $ROOT/$USERNAME/$PROJECT/postgres
fi

docker stop powa-$USERNAME-$PROJECT
docker rm -f powa-$USERNAME-$PROJECT

docker stop postgres-$USERNAME-$PROJECT
docker rm -f postgres-$USERNAME-$PROJECT

docker stop pgstudio-$USERNAME-$PROJECT
docker rm -f pgstudio-$USERNAME-$PROJECT

sleep 2

FULLPATH=$ROOT/$USERNAME/$PROJECT
FULLPATHLOGS=$LOGSROOT/$USERNAME/$PROJECT

docker run -d  $DNSOPTIONS --restart="on-failure:1" --name postgres-$USERNAME-$PROJECT -h db -p $INTERNAL:5432:5432 \
        -e POSTGRES_PASSWORD=strange \
        -v $FULLPATH/postgres/:/var/lib/postgresql/data \
        -v $FULLPATHLOGS/pglog/:/var/log/postgresql \
        -v $V8SYSTEMSPACE/v8space onec/postgres:$PGMAJOR

docker run -d  $DNSOPTIONS --restart="on-failure:1" --name powa-$USERNAME-$PROJECT \
        -p $INTERNAL:8888:8888 \
        --link postgres-$USERNAME-$PROJECT:db onec/powa-web

docker run -d $DNSOPTIONS --restart="on-failure:1" --name=pgstudio-$USERNAME-$PROJECT \
        -p $INTERNAL:8081:8080 \
        --link postgres-$USERNAME-$PROJECT onec/pgstudio
