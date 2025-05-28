#!/bin/sh
podman run --rm docker.io/aquasec/trivy:latest image docker.io/sebgad/nextcloud-fpm-alpine-updated:latest
