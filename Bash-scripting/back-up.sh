#!/bin/bash

# ============================================================
# Objective:  Back up a directory to a target location
#             Keep only the last 5 backups.
# ============================================================

set -euo pipefail

backup() {
local source_dir="$1" 
local backup_dir="$2"

if [ ! -d "$source_dir" ]; then
    echo "Error: directory $source_dir does not exist!"
    return 1
fi

mkdir -p "$backup_dir"
time_stamp=$(date + "%Y-%m-%d_%H-%M-%S")

backup_name=$(backup_"$time_stamp".tar.gz)
tar -czf "$backup_dir/backup_name" "source_dir"
echo "Backup created successfully: $backup_name"

cd "$backup_dir" || exit #remaining cmds should ONLY run in the backup_dir(a safety net)

ls -t | sed -e '1,5d' | while IFS= read -r file;
do 
    rm -f "$file"
done

}

backup "$1" "$2"

