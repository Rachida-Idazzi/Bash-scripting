#!/usr/bin/env bash
# ============================================================
# Objective:  Monitor a directory for changes (create/modify/delete) and log each change with a timestamp.
# ============================================================

#After installing the inotifywait pakage

set -euo pipefail

monitor_directory() {
    local directory="$1"
if [ -z "$1" ]; then 
    echo "No directory provided! Try: $0 <directory>"
    return 1
fi

if [ ! -d "$directory" ]; then
    echo "$directory does not exist!" 
    return 1
fi

inotifywait -m -e create,delete,modify --format '%T %e %w%f' --timefmt '%Y-%m-%d %H:%M:%S' "$directory" | while read -r line; do
echo "$line" >> change_log.txt 

# tee -a change_log.txt (can be used to check the log live)
done

}

monitor_directory "$1"



