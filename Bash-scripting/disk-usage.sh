#!/bin/bash

# ============================================================
# Objective:  Check disk usage of a directory
#             alert if it exceeds a given threshold.
# ============================================================

set -euo pipefail 

directory="$1"
threshold="$2"

disk_usage=$(du -ms "$directory" | awk '{print $1}')

if [ "$disk_usage" -gt "$threshold" ]; then
    echo "Warning: $directory uses $disk_usage MB (Threshold: $threshold)"
    exit 1
    
else
    echo "OK: $directory uses $disk_usage MB (Threshold: $threshold)"
    exit 0
fi




