FROM node as nodejs
FROM docker as docker

FROM jenkins/jenkins:latest

COPY --from=nodejs /usr/local/bin/node /usr/local/bin/node
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
