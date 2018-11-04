#!/bin/sh

REGISTRY_URL=localhost:5000
TAG=latest

docker build -t $REGISTRY_URL/influxdb:$TAG influxdb && docker push $REGISTRY_URL/influxdb:$TAG

docker build -t $REGISTRY_URL/mosquitto:$TAG mosquitto && docker push $REGISTRY_URL/mosquitto:$TAG

docker build -t $REGISTRY_URL/node-red:$TAG node-red && docker push $REGISTRY_URL/node-red:$TAG

docker build -t $REGISTRY_URL/mariadb:$TAG mariadb && docker push $REGISTRY_URL/mariadb:$TAG

docker build -t $REGISTRY_URL/mongodb:$TAG mongodb && docker push $REGISTRY_URL/mongodb:$TAG