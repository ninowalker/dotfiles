#!/bin/bash

# Check if the required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_audio_file:path> <minimum_length_of_silence:float>"
    exit 1
fi

# get input audio file name from argument
in_file="$1"
len="$2"

# Check if input file exists
if [ ! -f "$in_file" ]; then
    echo "Input file '$in_file' not found."
    exit 1
fi

# get base name of input file without extension
base_name=$(basename -- "$in_file")
base_name="${base_name%.*}"

# save all start times and durations of silences greater than 1 second
times=()
echo "Reading audio file..."
while read line; do
    # echo "$line"
    if [[ $line == *silence_end:* ]]; then
        duration_regex='silence_duration: ([^ ]*)'
        if [[ $line =~ $duration_regex ]]; then
            duration=${BASH_REMATCH[1]}
            if (($(echo "$duration > $len" | bc -l))); then
                time_regex='silence_end: ([^ ]*)'
                if [[ $line =~ $time_regex ]]; then
                    end_time=${BASH_REMATCH[1]}
                    end_time=$(echo "$end_time - ($duration / 2)" | bc -l)
                    times+=($end_time)
                    echo "End time = $end_time"
                fi
            fi
        fi
    fi
done < <(ffmpeg -hide_banner -i "$in_file" -af silencedetect=noise=-40dB:d=0.2 -f null - 2>&1)

# split audio file at midpoints of silent periods
if [ ${#times[@]} -eq 0 ]; then
    echo "No gaps detected."
    exit 1
fi

# add start and end time of the last segment
times+=($(ffprobe -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$in_file"))
segments=()
for ((i = 0; i < ${#times[@]} - 1; i++)); do
    start_time=${times[i]}
    end_time=${times[i + 1]}
    segments+=("-ss $start_time -to $end_time")
done

echo "Splitting audio file into ./$base_name/ ..."
# create directory for segments
mkdir -p "$base_name"

# extract segments
for ((i = 0; i < ${#segments[@]}; i++)); do
    echo "${segments[i]} ..."
    leading_zeros=$(printf "%05d" $i) # pad with 5 zeros
    ffmpeg -hide_banner -i "$in_file" ${segments[i]} -c:a aac -b:a 128k "${base_name}/${base_name}_${leading_zeros}.aac" || exit 1
done

echo "Done splitting."
