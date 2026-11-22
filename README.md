# podman-images

Rebuilds of upstream images with their packages upgraded, published as
`docker.io/sebgad/<directory>`.

`create-podman-images.sh` runs `build.sh`, `push.sh` and `check.sh` in every
image directory. A failing step skips the rest of that image, so a broken build
is never pushed. The other images still run, and the script exits non-zero if
any image failed.

`check.sh` scans the published image with trivy through `scan-image.sh`. Run by
hand, it prints trivy's table. With `REPORT_DIR` set, as on the image builder
VM, the script also writes `<REPORT_DIR>/<image>.status` (`build=`, `push=`,
`check=`, each `ok`, `failed` or `skipped`), and the scan writes its JSON
report to `<REPORT_DIR>/<image>.trivy.json`. The builder sends a summary of
both to Grafana.
