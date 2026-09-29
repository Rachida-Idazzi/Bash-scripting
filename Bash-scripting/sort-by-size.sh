#!/bin/bash
# ============================================================
# Objective:  Sort all .txt files in a directory by size, smallest to largest, and display them.
# ============================================================

sort_files() {
#Check if the argument is provided:
if [ -z "$1" ]; then
    echo "No directory provided"
    return 1
fi

#Check if directory exists:
if [ -d "$1" ]; then
    echo "The .txt files in the directory '$1' :"

#find the .txt files in the directory.
#Sort them by size from smaller to larger.
    find "$1" -type f -name "*.txt" -exec ls -lh {} + | awk '{print $5, $9}' | sort -k 1,1 -h
else
    echo "No such directory!"
    return 1
fi

}

sort_files "$1"
