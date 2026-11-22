#!/bin/sh
# scan-image.sh <image>
#
# Scans a published image with trivy. Called by each directory's check.sh.
#
# Without REPORT_DIR it prints trivy's usual table, as a manual run always
# has. With REPORT_DIR set (create-podman-images.sh on the podman-image-builder
# VM), it writes the JSON report to <REPORT_DIR>/<name>.trivy.json, <name>
# being the image's last path component without the tag, and keeps trivy's
# vulnerability database in TRIVY_CACHE_DIR (default ~/.cache/trivy), so it is
# not downloaded again on every run.
set -eu

image=$1

if [ -z "${REPORT_DIR:-}" ]; then
    exec podman run --rm docker.io/aquasec/trivy:latest image "$image"
fi

name=${image##*/}
name=${name%%:*}
cache_dir=${TRIVY_CACHE_DIR:-$HOME/.cache/trivy}
mkdir -p "$REPORT_DIR" "$cache_dir"

exec podman run --rm \
    -v "$cache_dir:/root/.cache/trivy" \
    -v "$REPORT_DIR:/reports" \
    docker.io/aquasec/trivy:latest \
    image --quiet --format json --output "/reports/$name.trivy.json" "$image"
