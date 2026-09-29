#!/bin/bash

# ============================================================
# Objective:  Read a KEY=VALUE configuration file and print each key-value pair.
# ============================================================

set -euo pipefail

key_value() {

config_file="$1"

if [[ ! -f "$config_file" ]]; then 
    echo "Error: file $config_file does not exist!" >&2
    return 1
fi

while IFS='=' read r key value; do 
    #Skip blank lines
if [[ -z "$key" ]]; then
    continue
fi

    #Skip comments
if [[ "$key" =~ ^[[:space:]]*# ]]; then
    continue
fi

echo "Key:$key; Value:$value"

done < "$config_file"

}

key_value "$1"
