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
docker pull bmorton/pghero

pushd ./powa-web
docker build -t onec/powa-web .
popd

pushd ./postgres
docker build -t onec/postgres:9.4 -f Dockerfile.94 .
docker build -t onec/postgres:9.5 -f Dockerfile.95 .
popd

pushd ./postgres/cluster
docker build -t  onec/postgres-citus:5.0-9.5 -f Dockerfile.95.Citus .
popd

pushd ./pgstudio
docker build -t onec/pgstudio:latest .
popd

pushd ./pgbadger
docker build -t onec/pgbadger .
popd

pushd ./barman
docker build -t onec/barman .
popd

pushd ./barman/postgres
echo "build barman postgres"
docker build -t onec/postgres:9.4-barman -f Dockerfile.94 .
docker build -t onec/postgres:9.5-barman -f Dockerfile.95 .
popd


sleep 2

docker rmi $(docker images | grep "^<none>" | awk '{print $3}')

#docker network create -d bridge pgsteroids
#docker-compose -f docker-compose-94.yml build
