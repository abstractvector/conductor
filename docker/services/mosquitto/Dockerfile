FROM resin/rpi-raspbian:jessie

RUN addgroup --gid 1000 mosquitto \
    && adduser --system --disabled-password --disabled-login -uid 1000 -gid 1000 mosquitto \
    && apt-get update \
    && apt-get install -y wget apt-transport-https gnupg2

RUN wget -q -O - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add - \
    && wget -q -O /etc/apt/sources.list.d/mosquitto-jessie.list http://repo.mosquitto.org/debian/mosquitto-jessie.list \
    && apt-get update && apt-get install -y mosquitto

COPY config /mqtt/config

VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

EXPOSE 1883 9001
CMD /usr/sbin/mosquitto -c /mqtt/config/mosquitto.conf