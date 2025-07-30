FROM docker.io/library/nextcloud:production-fpm-alpine

RUN set -ex; \
    apk update; \
    apk add imagemagick imagemagick-dev; \
    apk upgrade --no-cache; \
    apk add ffmpeg;
