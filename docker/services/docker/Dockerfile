FROM node as nodejs

FROM jenkins/jenkins:lts

COPY --from=nodejs /usr/local/bin/node /usr/local/bin/node
