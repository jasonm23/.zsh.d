## ffmpeg handy functions

This document uses literate markdown for shell scripting.

#### process and source via sed

```sh
sed -n '/^```sh @code/,/^```/ p' < video-functions.md | sed '/^```/ d'
```

# Intro

This is a growing collection of video processing functions I use for making
small videos for my music releases. I hope you find them useful.

## File formats etc...

So, `ffmpeg` will handle pretty much any video, image, sound, font format you
throw at it. See [ffmpeg](https://ffmpeg.org) for more info.

## ffpb = Progress bar for ffmpeg

Before we get into it, these functions all use `ffpb` a progress bar for
`ffmpeg`. All functions are using `ffpb` in place of `ffmpeg`.

The command can be switched back to `ffmpeg` in all cases.


```sh
pip install ffpb
```

### video-to-gif

From a `video` convert it to a looping `gif`.

```sh
# example usage
video-to-gif movie.mp4 looped.gif
```

Code

```sh @code
video-to-gif() {
    input="$1"
    output="$2"

    ffpb -i "$input" \
      -vf scale=800:-1 \
      -r 10 \
      -f image2pipe \
      -vcodec ppm - \
      | \
      convert \
      -delay 5 \
      -layers Optimize \
      -loop 0 - \
      "$output"
}
```

### video-from-image-and-audio

Using an `image` and a piece of `audio`, create video `output`

```sh
# example usage
video-from-image-and-audio image.jpg music.mp3 output.mp4
```

Code

```sh @code
video-from-image-and-audio() {
  if (( $# != 3 )); then
    echo "Usage: $0 <image> <audio> <output.mp4>"
  else
    ffpb -loop 1 -i "$1" \
      -i "$2" \
      -c:v libx264 \
      -c:a aac \
      -tune stillimage \
      -b:a 192k \
      -pix_fmt yuv420p \
      -shortest \
      "$3"
  fi
}
```

### video-loop-with-audio

Using a short `video` and longer `audio`, loop the video until the
audio ends, `output` to a new video.

```sh
# example usage
video-loop-with-audio short_video.mp4 long_audio.mp3 output.mp4
```

Code 

```sh @code

video-loop-with-audio() {
  if (( $# != 3 )); then
    echo "Usage: $0 <video> <audio> <output>"
  else
    video="$1"
    audio="$2"
      ffpb -stream_loop -1 \
           -i "$video" \
           -i "$audio" \
           -map 0:v:0 \
           -map 1:a:0 \
           -shortest \
           -c copy \
           "$3"
  fi
}
```

### video-crop-resize

Resize and crops a video to fit to 1920x1080, maintaining aspect-ratio. A better name for this would
probably be `video-fill-to-1080p`.

```sh
# example usage
video-crop-resize video.mp4 output.mp4
```

Code

```sh @code
video-crop-resize () {
  if (( $# != 2 )); then
    echo "Usage: $0 <input-video> <output-video>"
  else
    video="$1"
    output="$2"

    # width and height
    $(ffprobe -v quiet -show_format -show_streams background.mp4  | grep -E '^(width|height)=')

    if (( (1920.0 / $width) * $height > 1080 )); then
      filter="scale=1920:-2,crop=in_w:1080"
    else
      filter="scale=-2:1080,crop=1920:in_h"
    fi
    
   ffpb -i "$video" \
        -vf "$filter" \
        -vcodec libx264 \
        "$output"
  fi
}
```

### video-transparent-overlay

Give an `opacity` setting `(0.0 - 1.00)`, a transparent `image` and a `video`. 
Create a video with the transparent image on top of the video. Video and image 
dimensions should match for best results.

```sh
# example usage
video-transparent-overlay 0.9 opacity.png video.mp4 output.mp4
```

Code

```sh @code
video-transparent-overlay() {
  if (( $# != 4 )); then
    echo "Usage: $0 <opacity 0-1> <transparent-image> <video> <output-video>"
  else
    alpha=$1
    transparent_image=$2
    video=$3
    output=$4

    ffpb \
        -i $video \
        -i $transparent_image \
        -filter_complex "[1:v]format=argb, geq=r='r(X,Y)': a='${alpha}*alpha(X,Y)'[zork]; [0:v][zork]overlay" \
        -vcodec libx264 \
        $output
  fi
}
```

### video-pixelate

With `pixels` of a given size, pixelate `video` to `output`

```sh
# example usage
video-pixelate 50 video.mp4 output.mp4
```

Code

```sh @code
video-pixelate() {
  if (( $# != 3 )); then
    echo "Usage: $0 <pixel-size> <input-video> <output-video>"
  else
    pix="$1"
    input="$2"
    output="$3"
    dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of "csv=p=0:s=\:" "$input")
    ffpb -i "$input" -filter_complex "[0:v] scale='iw/${pix}:-1', scale='${dimensions}:flags=neighbor'" "$output"
  fi
}
```

### video-overlay-text

Place text on a `video`. You have to specify `font`, `color`, `text_size` as well as the `text`
itself.  Generates a new video to `output`

```sh
# example usage
video-overlay-text video.mp4 \
                   /path/to/font.ttf "#FFFFFF" 24 "Oh hai!" output.mp4
```

Code

```sh @code
video-overlay-text () {
  if (( $# != 6 )); then
    echo "Usage: $0 <input-video> <path_to/font_file> <text_color> <text_size> <text> <output-video>"
  else
    input="$1"
    fontfile="$2"
    text_color="$3"
    text_size="$4"
    text="$5"
    output="$6"
    ffmpeg -i "$input" -vf \
    \
        drawtext="fontfile=${fontfile}:
                  text='${text}':
                  fontcolor=${text_color}:
                  fontsize=${text_size}:
                  box=1:
                  boxcolor=black@0.5:
                  boxborderw=5:
                  x=(w-text_w)/2:
                  y=(h-text_h)/2" \
    \
                      -codec:a copy \
                      "$output"
  fi
}
```
