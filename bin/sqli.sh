#!/bin/bash

# Read input from clipboard
input=$(pbpaste)

# Extract parameters line
params_line=$(echo "$input" | grep -- '-- PARAMETERS:')
params_line=${params_line#*-- PARAMETERS: [}
params_line=${params_line%]}

# Convert parameters line to an array
IFS=',' read -r -a params <<<"$params_line"

# Replace placeholders with parameters
output="$input"
for i in "${!params[@]}"; do
    placeholder="$((i + 1))"
    output=$(echo "$output" | perl -pe "s/\\\$${placeholder}(?![0-9])/${params[$i]}/g")
done

# Copy the result back to the clipboard
echo "$output"
