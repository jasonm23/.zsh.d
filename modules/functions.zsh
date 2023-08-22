
psed() {
  # use like non -i sed
  perl -C -Mutf8 -pe $1
}

abspath () {
  case "$1" in
    /*)printf "%s\n" "$1";;
    *)printf "%s\n" "$PWD/$1";;
  esac;
}

sedrename() {
  if [ $# -gt 1 ]; then
    sed_pattern=$1
    shift
    for file in $(ls $@); do
      target="$(sed $sed_pattern <<< $file)"
      mkdir -p "$(dirname $(abspath $target))"
      mv -v "$file" "$target"
    done
  else
    echo "usage: $0 sed_pattern files..."
  fi
}

ec() {
  emacsclient -n "$@" 2> /dev/null
  if [[ $? == 1 ]]; then
    open -a Emacs.app  -- "$@"
  fi
}

get_gallery_jpgs () {
  gallery_url="$1"
  curl -s "$gallery_url" | pup 'a[href$=".jpg"] attr{href}' | while read a
  do
    echo $a
    wget $a
  done
}

srch() {
  if (( $# == 1 )); then
    pth=$(pwd)
    name="$1"
  else
    pth=$1
    name="$2"
  fi

  echo "Search: $pth $name"
  find -E "$pth" -iregex ".*${name// /.*}.*"
}

#  search using a list of keywords in the pasteboard
srch_pb() {
  pbpaste | while read name
  do
    srch "$1" "$name"
  done
}

randomize_timestamps_in_folder () {
  for a in *
  do
    CC="20"
    YY="$(printf "%02i" $(shuf -n 1 -i 0-22 ))"
    MM="$(printf "%02i" $(shuf -n 1 -i 1-12 ))"
    DD="$(printf "%02i" $(shuf -n 1 -i 1-28 ))"
    hh="$(printf "%02i" $(shuf -n 1 -i 0-23 ))"
    mm="$(printf "%02i" $(shuf -n 1 -i 0-59 ))"
    ss="$(printf "%02i" $(shuf -n 1 -i 0-59 ))"
    tstamp="${CC}${YY}${MM}${DD}${hh}${mm}.${ss}"
    touch -t "${tstamp}" "${a}"
    echo "$a $tstamp"
  done
}

get_thai () {
  encoded=$(urlencode "$1")
  url="https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=th&dt=t&q=${encoded}"
  curl -s "${url}" | perl -pe 's/^.*?"(.*?)".*$/\1/'
}

google_translate_line () {
  text="$1"
  source_lang="${2:-en}"
  target_lang="${3:-th}"

  local escaped="sl=$source_lang&tl=$target_lang&q=$text"

  echo $(wget -qO- \
      -U "AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1" \
      --header "'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'" \
      --header "'User-Agent': 'AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1'" \
      --post-data "$escaped" \
      "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=$target_lang&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e")
}

id3() {
if (( $# != 6 )); then
  echo "Usage: $0 <title> <artist> <album> <year> <genre>"
else
  id3v2 -2 \
    -t "$1" \
    -a "$2" \
    -A "$3" \
    -y "$4" \
    -g "$5" \
    "$6"
fi
}

invert-image () {
  convert "$1" -channel RGB -negate "$2"
}

bluetooth-power-toggle() {
  blueutil --power 0; sleep 13; blueutil --power 1
}

fmpc () {
  host=192.168.1.100
  local song_position
  song_position=$(
    mpc -h $host \
    -f "%position%) %artist% - %title%" \
    playlist \
    | fzf --reverse )
  i=$(echo "$song_position" | sed 's/^\([0-9]+\).*$/\1/' )
  mpc -h $host -q play $i
}

emacs-package-version () {
  if (( $# < 2 )); then
    echo "Usage: $0 <version> <elisp-package.el> [elisp-package.el ...]"
    return
  fi
  version="$1"
  shift
  for a in "$@"
  do
    sed -ibak "s/;; Version: [.0-9]*/;; Version: $version/" "$a"
    rm "${a}bak"
  done
}

git-group-push () {
  if (( $# < 1 )); then
    echo "Usage: $0 <git-repo> [git-repo ...]"
    return
  fi
  start="$(pwd)"
  for repo in "$@"
  do
    cd "$repo"
    echo "Push ${repo}"
    git push
    cd "$start"
  done
}

git-group-pull () {
  if (( $# < 1 )); then
    echo "Usage: $0 <git-repo> [git-repo ...]"
    return
  fi

  start="$(pwd)"
  for repo in "$@"
  do
    cd "$repo"
    echo "Pull --rebase ${repo}"
    git pull --rebase
    cd "$start"
  done
}

git-group-commit () {
  if (( $# < 2 )); then
    echo "Usage: $0 <version> <commit-message> <git-repo> [git-repo ...]"
    return
  fi

  start="$(pwd)"
  message="$1"
  shift
  for repo in "$@"
  do
    echo "$repo : Add all & commit"
    cd "$repo"
    git commit -a -m "${message}"
    cd "$start"
  done
}

ogit() {
  [[ $# < 2 ]] && echo "Usage: $0 repo/path commands..." && return
  _PATH=$1
  shift
  git -C "${_PATH}" "$@"
}

ogit-group() {
  [[ $# < 3 ]] && [[ ! "$@" =~  " -- "   ]] && echo "Usage: $0 <repo/paths>[...] -- <commands>"  && return
  OGIT_PATHS_COMPLETED=0
  OGIT_PATHS=()
  for opt in "$@"; do
    [[ "--" == "$opt" ]] && OGIT_PATHS_COMPLETED=1 && shift
    [[ $OGIT_PATHS_COMPLETED == 1 ]] && break || OGIT_PATHS+=("$opt") && shift
  done
  echo "git command: $@"
  echo "repo paths: ";printf '%s\n' "${OGIT_PATHS[@]}"
  echo "================================================================================"
  for p in "$OGIT_PATHS[@]"; do
    echo "${p}:"
  echo "--------------------------------------------------------------------------------"
    ogit "$p" "$@"
  echo ""
  done
}

doom---upgrade () {
  build_dir=$(find $HOME/.emacs.d/.local/straight -depth 1 -type d --iname "build*")
	for package in $@
	do
		echo "checking $package..."
    build=$(find "$build_dir" -depth 1 -type d -iname "${package}")
    modified=$(find $HOME/.emacs.d/.local/straight/modified -depth 1 -type d -iname "${package}")
		dir=$(find $HOME/.emacs.d/.local/straight/repos -depth 1 -type d -iname "${package}")
		if [[ "$dir" == "" ]]
		then
			echo "$package not found\nRetry and refine package name: $package"
		elif (( $(wc -l <<<$dir) > 1 ))
		then
			echo "$package found: \n$dir\nRetry and refine package name: $package"
		else
      if [[ "/" != "$modified" && ".." != "$modified" && "." != "$modified"  && -d "$modified" ]]; then
        rm -rf "$modified"
      fi
      if [[ "/" != "$build" && ".." != "$build" && "." != "$build"  && -d "$build" ]]; then
        rm -rf "$build"
      fi
			rm -rf "$dir"
		fi
	done
	~/.emacs.d/bin/doom sync
}

doom-upgrade () {
	if [[ "$1" == "" ]]
	then
		doom---upgrade $(find ~/.emacs.d/.local/straight/repos/ -type d -depth 1 | while read a; do echo $(basename $a); done | fzf -m | tr '\n' ' ' )
	else
		doom---upgrade "$@"
	fi
}

extract_frames() {
    if [ "$#" -ne 5 ]; then
        echo "Usage: extract_frames input_file start_time end_time fps output_name"
        return 1
    fi
    ffmpeg -i "$1" -ss "$2" -to "$3" -vf fps="$4",scale=1920:1080 "$5".%03d.png
}


gmm() {
	git commit -m "$*"
}
