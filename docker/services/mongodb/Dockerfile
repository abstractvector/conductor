FROM arm32v7/debian:stretch as builder

# following compile & install info from: http://koenaerts.ca/compile-and-install-mongodb-on-raspberry-pi/

# this is the latest version of MongoDB that supports 32-bit
ENV MONGODB_VERSION 3.2.21

# download and install dependencies
RUN cd /tmp \
    && apt update \
    && apt install -y wget scons build-essential libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev python-pymongo \
    && wget https://fastdl.mongodb.org/src/mongodb-src-r$MONGODB_VERSION.tar.gz \
    && tar xvf mongodb-src-r$MONGODB_VERSION.tar.gz

# set our working directory to the file we've just opened
WORKDIR /tmp/mongodb-src-r$MONGODB_VERSION

# install some 3rd party stuff
RUN export SHELL=/bin/bash \
    && cd src/third_party/mozjs-38/ \
    && ./get_sources.sh \
    && ./gen-config.sh arm linux \
    && cd /tmp/mongodb-src-r$MONGODB_VERSION

# build mongo and mongod
RUN scons mongo mongod --wiredtiger=off --mmapv1=on --disable-warnings-as-errors=DISABLE-WARNINGS-AS-ERRORS

# strip the debug info from the binaries and put them in /tmp/bin so they're easier to find
RUN strip -s build/opt/mongo/mongo \
    && strip -s build/opt/mongo/mongod \
    && mkdir -p /tmp/bin \
    && mv /tmp/mongodb-src-r$MONGODB_VERSION/build/opt/mongo/mongo* /tmp/bin

# create a brand new, clean image
FROM arm32v7/debian:stretch

# copy across the binaries we made
COPY --from=builder /tmp/bin/mongo* /usr/local/bin/

# own everything necessary
RUN groupadd -r -g 1000 mongodb \
    && useradd -r -g mongodb -u 1000 mongodb \
    && mkdir -p \
      /data/db \
      /var/log/mongodb \
    && chown -R mongodb:mongodb \
      /usr/local/bin/mongo* \
      /data \
      /var/log/mongodb

# expose volume
VOLUME "/data/db"

# expose ports
EXPOSE 27017
EXPOSE 28017

# run as mongodb user (uid=1000, gid=1000)
USER mongodb

# set the current working directory
WORKDIR /data

# need to explicitly set the storage engine as wiredTiger isn't available on 32-bit
CMD ["mongod", "--storageEngine=mmapv1"]