#!/bin/bash
if [ -f .env ]; then
    source .env
fi

export DEBIAN_FRONTEND=noninteractive
sudo apt-get upgrade docker-engine -y
sudo service docker restart

docker pull daald/ubuntu32:trusty
docker pull tomcat:8-jre8
docker pull debian:jessie


pushd ./powa-web
docker build -t onec/powa-web .
popd

pushd ./postgres
docker build -t onec/postgres:9.4 --build-arg="PG_MAJOR=9.4 PG_VERSION=9.4.7-1.pgdg80+1" .
docker build -t onec/postgres:9.5 --build-arg="PG_MAJOR=9.5 PG_VERSION=9.5.2-1.pgdg80+1" .
popd

pushd ./pgstudio
docker build -t onec/pgstudio:latest .
popd

pushd ./pgbadger
docker build -t onec/pgbadger .
popd

sleep 2

docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
#docker-compose -f docker-compose-94.yml build
