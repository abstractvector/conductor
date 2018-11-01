# Pull base image
FROM resin/rpi-raspbian:stretch

RUN apt-get update && apt-get install -y wget apt-transport-https

RUN wget -q -O - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mosquitto-stretch.list http://repo.mosquitto.org/debian/mosquitto-stretch.list
RUN apt-get update && apt-get install -y mosquitto

COPY config /mqtt/config
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

RUN chown -R mosquitto:mosquitto /mqtt

EXPOSE 1883 9001

USER mosquitto

CMD /usr/sbin/mosquitto -c /mqtt/config/mosquitto.conf