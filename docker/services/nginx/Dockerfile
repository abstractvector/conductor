FROM openresty/openresty:bionic

RUN addgroup --system --gid 1000 nginx \
    && adduser --system --disabled-login --home /var/cache/nginx --shell /sbin/nologin --uid 1000 nginx \
    && usermod -aG nginx nginx

# copy in our configuration
COPY ./conf/ /usr/local/openresty/nginx/conf/

# create a new dhparam.pem file each time the image is created - this does take a while...
RUN openssl dhparam 2048 > /usr/local/openresty/nginx/conf/dhparam.pem \
    && chown -R nginx:nginx /usr/local/openresty/nginx/conf

VOLUME /etc/ssl

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]