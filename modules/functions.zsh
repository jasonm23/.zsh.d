# Git helper functions
# Note: Hub has replaced many homemade functions here. see https://github.com/github/hub

git-branch-remote-delete() {
  branch_name=$1
  git push --force origin :$branch_name
}

git-quick-amend () {
  git commit --amend -C HEAD --reset-author
}

git-wip() {
  git commit -m "WIP - $(printf '%s ' "$@")"
}

git-commit-chore() {
  git commit -m "[Chore] $(printf '%s ' "$@")"
}

git-commit-hotfix() {
  git commit -m "[Hotfix] $(printf '%s ' "$@")"
}

git-authors() {
  git --no-pager log --format='%aN : %ae' \
      | sort -u
}

git-author-emails() {
  git --no-pager log --format='%aN : %ae' \
      | sort -u \
      | tr "\n" " "
}

git_pair_info(){
  git_email=$(git config user.email)
  if [[ $git_email =~ "pair+" ]]; then
    pair=$(echo $git_email \
        | sed \
        -e 's/pair\+//' \
        -e 's/@example.com//' \
        | tr "+" " ")
    echo "Pair: $pair"
  else
    echo "Git: $git_email"
  fi
}

origin() {
  git remote -v \
      | grep -E 'origin.*(fetch)' \
      | sed -e 's/origin//' -e 's/(fetch)//' \
      | tr -d "\t "
}

git-add-https-user () {
  if [ -z $1 ]; then
    echo "Username not set"
  else
    https_remote=$(git remote -v \
        | head -1 \
        | grep -E -o 'https:[^ ]*')
    existing_user=$(echo $https_remote \
        | grep  -E -o "[^/]*@")
    if [ -z $existing_user ]; then
      https_remote=$(echo $https_remote \
          | sed "s/https:\/\//https:\/\/$1@/")
    else
      https_remote=$(echo $https_remote \
          | sed "s/https:\/\/.*@/https:\/\/$1@/")
    fi
    echo $https_remote
    git remote set-url origin $https_remote
  fi
}

get-git-remote-url() {
  git remote -v \
      | head -1 \
      | grep -E -o "$1[^ ]*"
}

replace-github-https-with-ssh() {
  echo $1 \
      | sed -E \
      -e 's/https:\/\/([[:alnum:]_.-]*@)?/git@/' \
      -e 's/(.git)?$/.git/' \
      -e 's/github\.com\//github.com:/'
}

git-ssh2https () {
  git_remote=$(get-git-remote-url "git@")
  https_remote=$(echo $git_remote \
      | sed \
      -e 's/:/\//' \
      -e 's/git@/https:\/\//' \
      -e 's/\.git$//')
  git remote set-url ${1:-origin} $https_remote
}

git-https2ssh () {
  https_remote=$(get-git-remote-url "https:")
  ssh_remote=$(replace-github-https-with-ssh $https_remote)
  hub remote set-url ${1:-origin} $ssh_remote
}

numbers-only() {
  echo $1 \
      | sed 's/[^0-9]//g'
}

is_ssh() {
  [[ -n "$SSH_CLIENT" ]] && echo $ZSH_THEME_IS_SSH_SYMBOL
}

addalias() {
  # addalias will add a persistent alias in ~/.zsh_aliases
  # It will also ensure you're not overwriting an existing alias unintentionally.

  if (( $# != 2 )); then
    echo "Usage: $0 <alias> <command>"
  else
    abbrev=$1
    command="$2"
    matching_alias=$(alias $abbrev)
    if [[ $matching_alias == "" ]]; then
      tmp=$(mktemp /tmp/add-alias.XXXXXXXXXX)
      echo "$abbrev  => $command"
      echo "alias $abbrev='$command'" > $tmp
      source $tmp
      cat $tmp >> $HOME/.zsh_aliases
      rm $tmp
    else
      echo "Alias: $abbrev is already defined"
      echo "$(alias $abbrev)"
    fi
  fi
}

rmalias() {
  if [[ "$1" == "" ]]; then
    echo "Usage: $0 <alias>"
  else
    abbrev=$1
    matching_alias=$(alias $abbrev)
    if [[ $matching_alias == "" ]]; then
      echo "Alias: $abbrev is not defined"
    else
      echo "Removing: $abbrev"
      tmp=$(mktemp /tmp/add-alias.XXXXXXXXXX)
      grep "$abbrev=" -v $HOME/.zsh_aliases > $tmp
      cat $tmp > $HOME/.zsh_aliases
      rm $tmp
      unalias $abbrev
    fi
  fi
}

add-alias() {
  addalias "$@"
}

remove-alias() {
  rmalias "$@"
}

removealias() {
  rmalias "$@"
}

tmbvurl() {
  u=$1
  o=50
  p=${2:-0}
  ((c=$p * $o))
  url="http://tumblrview.com/onepage.php?user=${u}&offset=$c&limit=${o}&page=${p}"
  echo $url
}

getpage_tmb() {
  u=$1
  p=$2
  curl -s `tmbvurl ${u} ${p}` \
      | pup 'img attr{src}'
}

getpage_list_tmb() {
  u=$1
  o=50
  curl -s "http://tumblrview.com/index.php?user=${u}&offset=0&limit=${o}&submit=GO" \
      | pup ".number text{}" \
      | tr "\n" " "
}

psed() {
  # use like non -i sed
  perl -C -Mutf8 -pe $1
}

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
      if [[ $confirm == "Cancel" ]]; then
        return
      elif [[ $confirm == "Yes" ]]; then
        mv -v $file $new_name
        continue 2
      elif [[ $confirm == "No" ]]; then
        continue 2
      fi
    done
  done
}

abspath () { case "$1" in
               /*)printf "%s\n" "$1";;
               *)printf "%s\n" "$PWD/$1";;
             esac; }

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
  emacsclient -n $@ 2> /dev/null
  if [[ $? == 1 ]]; then
    open -a Emacs.app  -- $@
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

# When a list of names / (ordered) keyword searches in the pasteboard, supply a path search for filename matches
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

google_translate_line () {
  source_lang="$1"
  target_lang="$2"
  text="$3"

  local escaped="sl=$source_lang&tl=$target_lang&q=$text"

  echo $(wget -qO- \
      -U "AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1" \
      --header "'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'" \
      --header "'User-Agent': 'AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1'" \
      --post-data "$escaped" \
      "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=$target_lang&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e")
}

git-delete-remote-tag () {
  git push origin :refs/tags/${1}
}

ssh-agent-check() {
  SSH_AGENT_COUNT=$(pgrep ssh-agent | wc -l | tr -d " ")
  if ((${SSH_AGENT_COUNT} != 1)); then
    echo "(${SSH_AGENT_COUNT}) ssh-agents are running"
  else
    echo "ok"
  fi
}

ssh-agent-sock() {
  agent_pid=$1
  SSH_AUTH_SOCK=$(lsof | grep ssh-agent | grep -E -o "/var/folders.*")
}

ssh-fix-env() {
  echo "export SSH_AGENT_PID=$(pgrep ssh-agent | head -1)"
  echo "export SSH_AUTH_SOCK=$(lsof  | \
      grep -E "ssh-agent.*/private/tmp/com.apple.launchd.*$" | \
      grep -E -o "/private/tmp/com.apple.launchd.*$")"
}

git-mass-status() {
  for a in *
  do
    cd "$1"
    if [[ -d $a ]]; then
      echo "⟶   [$a]"
      cd "$a"
      git status --short
      cd ..
    fi
  done
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

addfunction() {
	fn=$1
	if [[ "$(which $fn)" =~ "() " ]]; then
		<<-FN
		$(which ${fn})

		Add this to ~/.zsh.d/modules/functions.zsh ?
		FN
        read -sq
		if [[ $? == 0 ]]; then
          wc_l=$(which $fn | wc -l | tr -d ' \n' )
          echo >> ~/.zsh.d/modules/functions.zsh
          which $1 >> ~/.zsh.d/modules/functions.zsh
          grep -n -A$wc_l "$fn" ~/.zsh.d/modules/functions.zsh
		fi
	else
		<<-HELP
		Usage: addfuncton <function>

		Add function to ~/.zsh.d/modules/functions.zsh
		HELP
	fi
}

zshd() {
    cd ~/.zsh.d
}

movie-missing-thai-srt () {
    movies=${1:-/Volumes/NextStep/Movies}
	fd --type directory . "$movies" | while read d
	do
		[[ "$(fd '.*srt$' "$d" | tr -d "\n" )" =~ "th.srt" ]] || echo $d
	done
}

movie-missing-srt () {
    movies=${1:-/Volumes/NextStep/Movies}
	fd --type directory . "$movies" | while read d
	do
		[[ "$(fd '.*srt$' "$d" | tr -d "\n" )" =~ ".srt" ]] || echo $d
	done
}

movie-has-thai-srt () {
    movies=${1:-/Volumes/NextStep/Movies}
	fd  --type directory . "$movies"  | while read d
	do
		[[ "$(fd '.*srt$' "$d" | tr -d "\n" )" =~ "th.srt" ]] && echo $d
	done
}

get_subs() {
	 py ~/workspace/OpenSubtitlesDownload/OpenSubtitlesDownload.py \
         -u jasonm23 \
         -p "$(security find-generic-password -w -s OpenSubtitlesKey -a OPEN_SUBS_KEY)" \
         --cli \
         -l eng "$1"
}

get_thai () {
	encoded=$(urlencode "$1") 
	url="https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=th&dt=t&q=${encoded}" 
	curl -s "${url}" | perl -pe 's/^.*?"(.*?)".*$/\1/'
}

get-missing-subtitles () {
	folder="$(movie-missing-srt | fzf)" 
	if [[ -d "${folder}" ]]
	then
		movie=$(fd "(mp4|mkv|avi)$" "${folder}" | fzf) 
		if [[ -f "${movie}" ]]
		then
			get_subs "${movie}"
			downloaded="${movie%.*}.srt" 
			if [[ -f "${downloaded}" ]]
			then
				english_srt="${movie%.*}.en.srt" 
				mv "${movie%.*}.srt" "${english_srt}"
				echo "${folder}:"
				ls -G -s1 "$folder"
				open -a Progression
				srt translate "${english_srt}" > "${english_srt/.en./.th.}"
			else
				echo "Sorry, no subtitles were downloaded for $(basename "${movie}")"
				return 1
			fi
		else
			return 1
		fi
	else
		return 1
	fi
}
