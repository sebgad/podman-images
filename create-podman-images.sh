#!/bin/bash

TARGET_FILES=("build.sh" "push.sh" "check.sh")

for dir in */ ; do
    if [ -d "$dir" ]; then
        for file in "${TARGET_FILES[@]}"; do
            FILE_PATH="$dir$file"
            if [ -x "$FILE_PATH" ]; then
                echo "Executing $FILE_PATH"
                echo
                cd $dir
                "$file"
                cd ..
                if [ $? -ne 0 ]; then
                    echo "Error: $FILE_PATH failed. Skipping to next directory."
                    break  # Stop checking other target files in this directory
                fi
                echo
            else
                echo "Skipping $FILE_PATH (not found or not executable)"
            fi
        done
    fi
done
