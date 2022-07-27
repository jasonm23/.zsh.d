clean_video_names(){
  video_name_pruning_stem="(XVid|DVDRip|BRRip|BluRay|WEB|HDTV|PROPER|REPACK|HDRIP|INTERNAL)"
  video_name_extensions="\.(mp4|mkv|avi|mpg|mov)"
  find . -depth 1 -type f \
      | grep -E -i ".*$video_name_pruning_stem.*" \
      | \
      while read a
      do
        new_name=$(psed "s/\.$video_name_pruning_stem.*$video_name_extensions$/.\2/i" <<< "${a}")
        mv -v "$a" "${new_name}"
      done
}

capitalize_period_delimited_words() {
  period_delimited_words=${1//./ }
  echo ${(C)period_delimited_words// /.}
}

capitalize_video_names() {
  find . -depth 1 | grep -E -v '[A-Z]' | while read a
  do
    capitalized_name=$(capitalize_period_delimited_words "$a" \
        | psed 's/\.tv\./.TV./i' \
        | psed 's/(mp4|mkv|avi|mpg|mov)$/\L$1/i' \
        | psed 's/s([0-9]+)e([0-9]+)/S$1E$2/i'
                    )
    echo "$a -> $capitalized_name"
    mv "$a" "$capitalized_name"
  done
}

fix_show_names() {
  echo "> Clean video names"
  clean_video_names
  echo "> Capitalize video names"
  capitalize_video_names
}

fix_three_digit_show() {
  find -E  . -depth 1 -iregex '.*\.[0-9]{3}\..*' | while read file; do
    new_name=$(sed -E 's/(.*)\.([0-9])([0-9]{2})\.(.*)/\1.S0\2E\3.\4/' <<< $file)
    echo "Confirm:"
    echo "$file -> $new_name"
    select confirm in Yes No Cancel
    do
      case confirm in
        Cancel)  return;;
           Yes)  mv -v "$file" "$new_name"; return;;
            No)  return;;
      esac
    done
  done
}
