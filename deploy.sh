#!/bin/bash

TABLE="./paths.table"
declare -A paths succeed failed ignored
declare -a temp 

# TODO implement interactive mode
#      like this:
# where to link $filename? [default = $filepath]
deploy()
{
    ;
}

check_ignored()
{
    ;
}

print_statistics()
{
    ;
}

read_config_table()
{
    # read file & destination paths by line
    IFS=$'\n' read -d '' -r -a temp < "$TABLE"

    for line in "${temp[@]}"; do
        # delete in line comments
        line=${line%%\#*}
        # check whether the line not empty
        if [[ -n "${line// }" ]]; then
            # get filename and destination path
            # ****n' pipes, I couldn't make them work, thus:
            echo $line > ".tmpfile"
            read file dest < ".tmpfile"
            # store values in a dict
            paths["$file"]="$dest"
        fi
    done; rm ".tmpfile"; unset temp

    # iterate through the paths dict to ensure it's ok
    for file in "${!paths[@]}"; do
        printf "%s %s\n" "$file" "${paths["$file"]}"
    done
}

main()
{
    ;
}

main
