#!/bin/bash

function convert_m4b_to_aac {
    for file in "$@"; do
        if [ "${file##*.}" = "m4b" ]; then
            ffmpeg -i "$file" -c:a aac -b:a 128k "${file%.*}.aac"
        else
            echo "Skipping file $file, not an m4b file"
        fi
    done
}

convert_m4b_to_aac "$@"
