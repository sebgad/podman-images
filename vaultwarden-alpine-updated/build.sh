#!/bin/sh
podman pull docker.io/library/vaultwarden:alpine
podman build --rm -t vaultwarden-alpine-updated .
