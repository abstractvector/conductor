#!/bin/sh

# The "--resolve-image never" option is needed if `docker info` and
# `docker inspect` on the container report different results.
# See: https://github.com/docker/swarmkit/issues/2294 for more details
# This was an issue using https://hub.docker.com/r/resin/rpi-raspbian/ but
# using arm32v7/debian:stretch seems to be fine
docker stack deploy -c docker-compose.yml app