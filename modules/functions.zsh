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

vid2gif() {
  ffmpeg -i "$1" -vf scale=800:-1 -r 10 -f image2pipe -vcodec ppm - |\
    convert -delay 5 -layers Optimize -loop 0 - "$2"
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
  git remote set-url origin $https_remote
}

git-https2ssh () {
  https_remote=$(get-git-remote-url "https:")
  ssh_remote=$(replace-github-https-with-ssh $https_remote)
  git remote set-url origin $ssh_remote
}

interactive-kill() {
  echo "$1"
  echo "Kill [N/y]"
  read i_cfm
  if [[ $i_cfm = "y" ]]; then
    kill -9 $(numbers-only $2)
  fi
}

numbers-only() {
  echo $1 \
    | sed 's/[^0-9]//g'
}

interactively-kill-ruby () {
  ruby_procs=$(ps aux \
                 | grep -E 'ruby|spring' \
                 | grep -v 'grep')
  ruby_procs_arr=()

  echo $ruby_procs \
    | \
    while read prc; do
      ruby_procs_arr+=("$prc")
    done

  pids=$(echo $ruby_procs | \
           cut -c17-22)

  if [[ $ruby_procs = "" ]];then
    echo "No ruby / spring processes..."
    return
  fi

  echo "- Current Ruby processes ----> "
  echo $ruby_procs
  echo "- Aggressively kill -9 all? [i/y/N] (i = interactive)"

  read cfm

  if [[ $cfm = "y" ]]; then
    for p in $pids
    do
      kill -9 $(numbers-only $p)
    done
  fi

  if [[ $cfm = "i" ]]; then
    for rp in ${ruby_procs_arr[@]}
    do
      interactive-kill $rp $(echo $rp \
                               | cut -c17-22)
    done
  fi
}

is_ssh() {
  [[ "" != $( echo $(who -m) | cut -d' ' -f6) ]] && echo $ZSH_THEME_IS_SSH_SYMBOL
}

addalias() {
  if [[ "$1" == "" ]]; then
    echo "No alias specified"
  else
    abbrev=$1
    command="$2"
    matching_alias=$(alias $abbrev)
    if [[ $matching_alias == "" ]]; then
      tmp=$(tempfile)
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
    echo "No alias specified"
  else
    abbrev=$1
    matching_alias=$(alias $abbrev)
    if [[ $matching_alias == "" ]]; then
      echo "Alias: $abbrev is not defined"
    else
      echo "Removing: $abbrev"
      tmp=$(tempfile)
      grep "$abbrev=" -v $HOME/.zsh_aliases > $tmp
      cat $tmp > $HOME/.zsh_aliases
      rm $tmp
      unalias $abbrev
    fi
  fi
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
