#!/bin/sh

REGISTRY_URL=localhost:5000
TAG=latest

docker build -t $REGISTRY_URL/mosquitto:$TAG mosquitto && docker push $REGISTRY_URL/mosquitto:$TAG

docker build -t $REGISTRY_URL/node-red:$TAG node-red && docker push $REGISTRY_URL/node-red:$TAG