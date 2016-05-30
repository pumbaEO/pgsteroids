#!/bin/bash
if [ -f .env ]; then
    source .env
fi

set -x
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
PGMAJOR=9.4-barman
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

docker stop powa-$USERNAME-$PROJECT
docker rm -f powa-$USERNAME-$PROJECT

docker stop postgres-$USERNAME-$PROJECT
docker rm -f postgres-$USERNAME-$PROJECT

docker stop pgstudio-$USERNAME-$PROJECT
docker rm -f pgstudio-$USERNAME-$PROJECT

docker stop barman-$USERNAME-$PROJECT
docker rm -f barman-$USERNAME-$PROJECT

docker network create pgsteroids

sleep 2

FULLPATH=$ROOT/$USERNAME/$PROJECT
FULLPATHLOGS=$LOGSROOT/$USERNAME/$PROJECT

if [ -d $FULLPATH ]; then
    echo "data directory is allready exist"
else
    sudo mkdir -p $FULLPATH/postgres
    sudo mkdir -p $FULLPATH/barman
fi

if [ ! -s "$FULLPATH/barman/.ssh/id_rsa.pub" ]; then
    sudo mkdir -p $FULLPATH/barman/.ssh
    sudo ssh-keygen -t rsa -N '' -q -f $FULLPATH/barman/.ssh/id_rsa -g -n "barman@backup"
    
fi

if [ ! -s "$FULLPATH/postgresssh/.ssh/id_rsa.pub" ]; then
    sudo mkdir -p $FULLPATH/postgresssh/.ssh
    sudo ssh-keygen -t rsa -N '' -q -f $FULLPATH/postgresssh/.ssh/id_rsa -g -n "postgres@pg"
    
    sudo chown vagrant:vagrant -R $FULLPATH/barman/.ssh/
    sudo chown vagrant:vagrant -R $FULLPATH/postgresssh/.ssh/
    
    cat >> $FULLPATH/barman/.ssh/ssh_config << EOL
Host pg
   StrictHostKeyChecking no
EOL

    cat >> $FULLPATH/postgresssh/.ssh/ssh_config << EOL
Host backup
   StrictHostKeyChecking no
EOL
    
    cat $FULLPATH/postgresssh/.ssh/id_rsa.pub > $FULLPATH/barman/.ssh/authorized_keys
    cat $FULLPATH/barman/.ssh/id_rsa.pub > $FULLPATH/postgresssh/.ssh/authorized_keys

fi

docker run -d $DNSOPTIONS --net=pgsteroids --restart="on-failure:1" --name=barman-$USERNAME-$PROJECT \
        -P -h backup \
        -v $FULLPATH/barman:/var/lib/barman \
        onec/barman

docker run --net=pgsteroids -d  $DNSOPTIONS --restart="on-failure:1" --name postgres-$USERNAME-$PROJECT -h db -p $INTERNAL:5432:5432 \
        -e POSTGRES_PASSWORD=strange \
        -v $FULLPATH/postgres/:/var/lib/postgresql/data \
        -v $FULLPATHLOGS/pglog/:/var/log/postgresql \
        -v $V8SYSTEMSPACE/v8space \
        -v $FULLPATH/postgresssh/.ssh:/home/postgres/.ssh \
        --link barman-$USERNAME-$PROJECT:backup \
        onec/postgres:$PGMAJOR
        #onec/postgres:$PGMAJOR

docker run -d  $DNSOPTIONS --net=pgsteroids --restart="on-failure:1" --name powa-$USERNAME-$PROJECT \
        -p $INTERNAL:8888:8888 \
        --link postgres-$USERNAME-$PROJECT:db onec/powa-web

docker run -d $DNSOPTIONS --net=postgresnet --restart="on-failure:1" --name=pgstudio-$USERNAME-$PROJECT \
        -p $INTERNAL:8081:8080 \
        --link postgres-$USERNAME-$PROJECT onec/pgstudio
        
sleep 2

#restart barman for correct links
docker stop barman-$USERNAME-$PROJECT
docker rm -f barman-$USERNAME-$PROJECT

#сделаем link к postgres 
docker run -d $DNSOPTIONS --net=pgsteroids --restart="on-failure:1" --name=barman-$USERNAME-$PROJECT \
        -P -h backup \
        --link postgres-$USERNAME-$PROJECT:pg \
        -v $FULLPATH/barman:/var/lib/barman \
        onec/barman


docker exec -u barman barman-$USERNAME-$PROJECT barman check main