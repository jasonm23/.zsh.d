rounded_corner_image() {

    if [[ $# != 3 ]]; then
        cat <<-USAGE
		$0 <input image png> <corner radius> <output image png>
		USAGE
    fi

    local image=$1
    local w=$(identify -format '%w' "$1")
    local h=$(identify -format '%h' "$1")
    local r=$2

    convert \
        -size ${w}x${h} \
        xc:black \
        -fill white \
        -draw "roundRectangle 0,0,${w},${h} ${r},${r}" \
        mask_temp.png

    convert \
        $image \
        mask_temp.png \
        -alpha Off \
        -compose CopyOpacity \
        -composite \
        $3

    rm mask_temp.png
}
