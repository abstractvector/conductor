FROM arm32v7/debian:stretch as builder

# http://koenaerts.ca/compile-and-install-mongodb-on-raspberry-pi/

ENV MONGODB_VERSION 3.2.21

# download and install dependencies
RUN cd /tmp \
    && apt update \
    && apt install -y wget scons build-essential libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev python-pymongo \
    && wget https://fastdl.mongodb.org/src/mongodb-src-r$MONGODB_VERSION.tar.gz \
    && tar xvf mongodb-src-r$MONGODB_VERSION.tar.gz

# temporarily create a swap partition to help complilation
RUN dd if=/dev/zero of=/mytempswapfile bs=1024 count=1048576 \
    && chmod 0600 /mytempswapfile \
    && mkswap /mytempswapfile \
    && swapon /mytempswapfile

# install some 3rd party stuff
RUN export SHELL=/bin/bash \
    && cd src/third_party/mozjs-38/ \
    && ./get_sources.sh \
    && ./gen-config.sh arm linux \
    && cd /tmp/mongodb-src-r$MONGODB_VERSION

# build mongo and mongod
RUN scons mongo mongod --wiredtiger=off --mmapv1=on --disable-warnings-as-errors=DISABLE-WARNINGS-AS-ERRORS

RUN strip -s build/opt/mongo/mongo \
    && strip -s build/opt/mongo/mongod

FROM arm32v7/debian:stretch

COPY --from=builder /root/mongodb-src-r$MONGODB_VERSION/build/opt/mongo/mongo** /usr/local/bin/

RUN groupadd -r -g 1000 mongodb \
    && useradd -r -g mongodb -u 1000 mongodb \
    && mkdir -p \
      /data/db \
      /data/configdb \
      /var/log/mongodb \
    && chown -R mongodb:mongodb \
      /usr/bin/mongo* \
      /data/db \
      /data/configdb \
      /var/log/mongodb

COPY ./docker-entrypoint.sh /

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

# Define mountable directories
VOLUME /data/db /data/configdb

# Define working directory
WORKDIR /data

# Expose ports
# - 27017: process
# - 28017: http
EXPOSE 27017
EXPOSE 28017

#ENTRYPOINT ["/sbin/tini", "--"]
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["mongod"] 

