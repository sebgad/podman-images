#!/bin/sh
podman run --rm docker.io/aquasec/trivy:latest image docker.io/sebgad/mariadb-updated:latest
