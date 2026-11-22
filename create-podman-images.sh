#!/bin/bash
# Builds, pushes and scans every image directory: runs <dir>/build.sh, then
# push.sh, then check.sh, from inside that directory.
#
# A failing step skips the rest of that image, so a broken build is never
# pushed and the scan never reports on an image that was not rebuilt. The
# other images still run. The script exits non-zero if any image failed.
#
# With REPORT_DIR set (the podman-image-builder VM sets it), every image also
# gets <REPORT_DIR>/<image>.status recording each step as ok, failed or
# skipped, and check.sh writes its scan report there (see scan-image.sh).

TARGET_FILES=("build.sh" "push.sh" "check.sh")

# Runs from its own directory, so it works from anywhere.
cd "$(dirname "$0")" || exit 1

if [ -n "${REPORT_DIR:-}" ]; then
    mkdir -p "$REPORT_DIR" || exit 1
fi

# write_status <image> <step=result>...
write_status() {
    local image=$1
    shift
    [ -n "${REPORT_DIR:-}" ] || return 0
    printf '%s\n' "$@" > "$REPORT_DIR/$image.status"
}

# Prune all images before build
podman image prune -f -a

failed=()

for dir in */ ; do
    [ -d "$dir" ] || continue
    image=${dir%/}

    # One entry per step, in TARGET_FILES order, all skipped until they run.
    results=()
    for file in "${TARGET_FILES[@]}"; do
        results+=("${file%.sh}=skipped")
    done

    for i in "${!TARGET_FILES[@]}"; do
        file=${TARGET_FILES[$i]}
        step=${file%.sh}
        FILE_PATH="$dir$file"
        if [ ! -x "$FILE_PATH" ]; then
            echo "Skipping $FILE_PATH (not found or not executable)"
            continue
        fi

        echo "Executing $FILE_PATH"
        echo
        # In a subshell, so the cd cannot leak into the next directory.
        if (cd "$dir" && bash "$file"); then
            results[i]="$step=ok"
        else
            echo "Error: $FILE_PATH failed. Skipping to next directory."
            results[i]="$step=failed"
            failed+=("$FILE_PATH")
            break  # Stop checking other target files in this directory
        fi
        echo
    done

    write_status "$image" "${results[@]}"
done

if [ ${#failed[@]} -gt 0 ]; then
    echo "Failed: ${failed[*]}"
    exit 1
fi
