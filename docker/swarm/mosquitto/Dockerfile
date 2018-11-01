FROM arm32v7/debian:stretch

RUN apt-get update \
    && apt-get install -y wget apt-transport-https gnupg2 \
    && wget -q -O - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add - \
    && wget -q -O /etc/apt/sources.list.d/mosquitto-stretch.list http://repo.mosquitto.org/debian/mosquitto-stretch.list \
    && apt-get update && apt-get install -y mosquitto \
    && mkdir -p /mqtt/config \
    && mkdir -p /mqtt/data \
    && mkdir -p /mqtt/log \
    && chown -R mosquitto:mosquitto /mqtt

COPY config /mqtt/config

VOLUME ["/mqtt/data"]

EXPOSE 1883 9001

CMD /usr/sbin/mosquitto -c /mqtt/config/mosquitto.conf