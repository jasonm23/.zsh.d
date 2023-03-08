#!/bin/bash

# Set up variables
resize_script="resize-if-smaller.sh"
image_dir="$1"
width="$2"
height="$3"

# Check if arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 image_dir width height"
  exit 1
fi

# Check if the image directory exists
if [ ! -d "$image_dir" ]; then
  echo "Error: $image_dir is not a directory."
  exit 1
fi

# Loop through images in the directory
for image_path in "$image_dir"/*.{jpg,jpeg,png,gif,webp}; do

  # Check if the file is an image
  if [ -f "$image_path" ]; then

    # Resize the image and overwrite original
    "$resize_script" "$image_path" "$width" "$height"

  fi
done
