#!/bin/sh
podman pull ubuntu:noble
podman build --rm -t mariadb-updated .
