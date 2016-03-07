#!/bin/sh

TABLE="paths.table"
declare -A paths succeed failed ignored
declare -a temp 

# read file & destination paths by line
IFS=$'\n' read -d '' -ra temp < "$TABLE"

for line in "${temp[@]}"; do
    # delete in line comments
    line=${line%%\#*}
    # check whether the line not empty
    if [[ -n "${line// }" ]]; then
        # getting filename and destination path
        # ****n' pipes, i couldn't make them work, so:
        echo $line > ".tmpfile"
        read file dest < ".tmpfile"
        # store values in a dict
        paths["$file"]="$dest"
    fi
done; rm ".tmpfile"; unset temp

# iterate over the paths dict to ensure it's ok
for file in "${!paths[@]}"; do
    printf "%s %s\n" "$file" "${paths["$file"]}"
done

