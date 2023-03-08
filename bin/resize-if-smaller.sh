#!/bin/bash

# Check if the number of arguments is correct
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <image_path> <width> <height>"
    exit 1
fi

# Parse the arguments
image_path=$1
width=$2
height=$3

# Check if the image file exists
if [[ ! -f $image_path ]]; then
    echo "Error: $image_path does not exist."
    exit 1
fi

# Get the original width and height of the image
original_width=$(identify -format "%w" "$image_path")
original_height=$(identify -format "%h" "$image_path")

# Check if the image is smaller than the requested size
if [[ $original_width -lt $width || $original_height -lt $height ]]; then
    # Calculate the new size
    new_width=$width
    new_height=$height

    # Resize the image
    resized_image_path="${image_path%.*}-resized.${image_path##*.}"
    convert "$image_path" -resize "${new_width}x${new_height}" "$resized_image_path"

    # Backup the original image
    backup_image_path="${image_path}.backup"
    mv "$image_path" "$backup_image_path"

    # Rename the resized image to the original name
    mv "$resized_image_path" "$image_path"
    echo "Image ${image_path} resized successfully from ($original_width x $original_height) to ($width x $height)"
else
    echo "Image ${image_path} is already larger ($original_width x $original_height) than the requested size ($width x $height)."
fi
