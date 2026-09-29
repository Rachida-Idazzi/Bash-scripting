#!/bin/bash
#================================================
# Objective: 
#	search .txt file in a given directory and count each file's lines and display the output as File: N


#set -x
set -uo pipefail


dir="$1"



verbose="${2:-}"

declare -A file_line_count

if [[ $# -eq 0 ]]; then
	echo "Error:no directory provided!" >&2
	echo "Try: $0 <directory>"
	exit1
fi

func(){

if [[ ! -d "$dir" ]] ; then
	echo "Error: No such directory!" >&2
	exit 2
fi

local file 

local total=0

while read -r file ; do 

  local count=0 #placed inside so it goes back to 0 for each iteration
	
  while IFS= read -r l || [[ -n "$l" ]]; do #IFS= preseves whitespaces, || [[ -n "$l" ]] handles missing final newlines.

			((count++)) #This starts at 0 (failure in arith )this is why I removed set -e
  done < "$file"

#Store in associative array:

	file_line_count["$file"]="$count"

	#this part is just for an alternative approach:~echo "File name : $file ; Number of lines : $count"~

 done < <(find "$dir" -type f -name "*.txt")

#Print a report:

for file in "${!file_line_count[@]}"; do 

echo "$file : ${file_line_count[$file]}"

# 3. Handle the v flag logic

    if [[ "$verbose" == "v" ]]; then

        ((total += file_line_count[$file]))

        echo "Running total: $total"
    fi


done

}

func "$dir"
