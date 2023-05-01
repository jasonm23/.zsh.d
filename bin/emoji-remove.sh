#!/bin/bash

# Define a function to clean a filename of Unicode emojis
function clean_filename() {
    # Get the filename as an argument
    local filename="$1"

    # Use Perl to remove Unicode emojis from the filename
    local clean_filename="$(perl -Mutf8 -CS -e '$filename=shift;$filename=~s/[\x{1F600}-\x{1F64F}\x{2700}-\x{27BF}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{1F1E6}-\x{1F1FF}]//g;print $filename;' "$filename")"

    # Rename the file with the cleaned filename
    mv "$filename" "$clean_filename"
}

# Loop over the files in the current directory
for filename in *; do
    # Check if the file name contains any Unicode emojis
    if [[ "$(perl -Mutf8 -CS -ne 'print if /[\x{1F600}-\x{1F64F}\x{2700}-\x{27BF}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{1F1E6}-\x{1F1FF}]/' <<< "$filename")" ]]; then
        # If it does, clean the filename
        clean_filename "$filename"
        echo "Cleaned $filename"
    # else
    #   echo "No emojis found in $filename"
    fi
done
