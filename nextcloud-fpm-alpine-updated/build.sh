#!/bin/sh
podman pull docker.io/library/nextcloud:fpm-alpine
podman build --rm -t nextcloud-fpm-alpine-updated .
