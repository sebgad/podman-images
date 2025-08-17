#!/bin/sh
podman pull docker.io/library/nginx:stable-alpine
podman build --rm -t nginx-stable-alpine-updated .
