#!/bin/bash

docker tag onec/postgres:9.4 silverbulleters/vanessa-postgres:9.4
docker tag onec/postgres:9.5 silverbulleters/vanessa-postgres:9.5
docker tag onec/postgres:9.5 silverbulleters/vanessa-postgres:latest

docker silverbulleters/vanessa-postgres:9.4.7
docker silverbulleters/vanessa-postgres:9.5
docker silverbulleters/vanessa-postgres:latest
