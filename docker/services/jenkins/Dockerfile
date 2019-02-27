FROM node as nodejs

FROM jenkins/jenkins:latest

COPY --from=nodejs /usr/local/bin/node /usr/local/bin/node
