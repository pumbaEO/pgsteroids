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
docker build -t onec/postgres:9.4 .
popd

pushd ./pgstudio
docker build -t onec/pgstudio:latest .
popd


sleep 2

docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
#docker-compose -f docker-compose-94.yml build
