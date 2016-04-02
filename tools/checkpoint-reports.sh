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

docker run --rm -it --entrypoint sh --name pgbadger-local -v /vagrant/temp/wwwreports:/var/www/pg_reports \
  --volumes-from=postgres-$USERNAME-$PROJECT onec/pgbadger -c "/usr/local/bin/pgbadger -j 2 /var/log/postgresql/postgresql-*"
