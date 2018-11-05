FROM arm32v7/node:latest

RUN mkdir -p /usr/src/node-red \
    && mkdir /data \
    && chown -R node:node /usr/src/node-red \
    && chown -R node:node /data \
    && usermod -aG dialout node

WORKDIR /usr/src/node-red

USER node

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
RUN npm install

# User configuration directory volume
EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules

CMD ["npm", "start", "--", "--userDir", "/data"]