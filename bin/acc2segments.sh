#!/bin/bash -e

function segment_aac_file() {
    # $1 is the path of the .aac file
    input_file="$1"
    size="$2"

    # Remove the suffix from the filename
    filename_without_suffix="$(basename "$input_file" .aac)"

    # Create the folder with the same name as the input file (minus the suffix)
    output_folder="${filename_without_suffix}_segments"
    mkdir "$output_folder"

    # Split the input file into 30s segments with ffmpeg
    ffmpeg -i "$input_file" -c copy -map 0 -f segment -segment_time "$size" "$output_folder/$filename_without_suffix-%03d.aac"
}

segment_aac_file "$@"
