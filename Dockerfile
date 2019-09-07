FROM alpine:latest

ENV PUID 0
ENV PGID 100
ENV PERMISSION 777

RUN apk update

# Set locale and timezone
RUN apk add --no-cache tzdata
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone
ENV TZ Asia/Seoul
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

# Install packages
RUN apk add --no-cache \
  transmission-daemon \
  openjdk8 \
  nginx \
  php7 \
  php7-fpm \
  php7-session \
  php7-sockets \
  php7-json

# Set config files
COPY ./defaults/settings.json /settings.json
COPY ./defaults/default.conf /etc/nginx/conf.d/default.conf
RUN chown root:root /settings.json /etc/nginx/conf.d/default.conf
RUN chmod 775 /settings.json /etc/nginx/conf.d/default.conf
RUN mkdir -p /run/nginx

# Ports and volumes
EXPOSE 80 4040 9091 51413 51413/udp
VOLUME /transmission /showdown /output /showdown-manager

# Set initial script
COPY ./defaults/init.sh /init.sh
RUN chown root:root /init.sh
RUN chmod 775 /init.sh

# Define entrypoint
ENTRYPOINT /init.sh
