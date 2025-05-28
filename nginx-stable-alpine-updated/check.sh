#!/bin/sh
podman run --rm docker.io/aquasec/trivy:latest image docker.io/sebgad/nginx-stable-alpine-updated:latest
