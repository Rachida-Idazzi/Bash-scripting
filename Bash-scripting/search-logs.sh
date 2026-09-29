#!/bin/bash

# ============================================================
# Objective:  Search for a word or phrase across all .log files in a directory and list files that match.
# ============================================================

set -euo pipefail

search_phrase() {
    local phrase="$1"
    local directory="$2"

if [ -z "$phrase" ] || [ -z "$directory" ]; then 
    echo "Missing information! Try: $0 <phrase> <directory>"
    return 1
fi 

if [ ! -d "$directory" ]; then
    echo "$directory does not exist"
    return 1
fi

echo "Matching files for $phrase in $directory:"
local matches=$(find "$directory" -type f -name "*.log" -exec grep -l "$phrase" {} + )
if [ -n "$matches" ]; then
    echo "$matches"
else
    echo "No matches found!"
fi

}

search_phrase "$1" "$2"
