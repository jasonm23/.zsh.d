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
  git --no-pager log --format='%aN : %ae' | sort -u
}

git-author-emails() {
  git --no-pager log --format='%aN : %ae' | sort -u | tr "\n" " "
}

git_pair_info(){
  git_email=$(git config user.email)
  if [[ $git_email =~ "pair+" ]]; then
    pair=$(echo $git_email | sed -e 's/pair\+//' -e 's/@example.com//' | tr "+" " ")
    echo "Pair: $pair"
  else
    echo "Git: $git_email"
  fi
}

origin() {
  git remote -v |\
    grep -E 'origin.*(fetch)' |\
    sed -e 's/origin//' -e 's/(fetch)//'|\
    tr -d "\t "
}

vid2gif() {
  ffmpeg -i "$1" -vf scale=800:-1 -r 10 -f image2pipe -vcodec ppm - |\
    convert -delay 5 -layers Optimize -loop 0 - "$2"
}

git-add-https-user () {
  if [ -z $1 ]; then
    echo "Username not set"
  else
    https_remote=$(git remote -v | head -1 | grep -E -o 'https:[^ ]*')
    existing_user=$(echo $https_remote | grep  -E -o "[^/]*@")
    if [ -z $existing_user ]; then
      https_remote=$(echo $https_remote | sed "s/https:\/\//https:\/\/$1@/")
    else
      https_remote=$(echo $https_remote | sed "s/https:\/\/.*@/https:\/\/$1@/")
    fi
    echo $https_remote
    git remote set-url origin $https_remote
  fi
}

get-git-remote-url() {
  git remote -v | head -1 | grep -E -o "$1[^ ]*"
}

replace-github-https-with-ssh() {
  echo $1 | sed -E \
                -e 's/https:\/\/([[:alnum:]_.-]*@)?/git@/' \
                -e 's/(.git)?$/.git/' \
                -e 's/github\.com\//github.com:/'
}

git-ssh2https () {
  git_remote=$(get-git-remote-url "git@")
  https_remote=$(echo $git_remote | sed -e 's/:/\//' -e 's/git@/https:\/\//' -e 's/\.git$//')
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
  echo $1 | sed 's/[^0-9]//g'
}

interactively-kill-ruby () {
  ruby_procs=$(ps aux | grep -E 'ruby|spring' | grep -v 'grep')
  ruby_procs_arr=()
  echo $ruby_procs | while read prc; do
    ruby_procs_arr+=("$prc")
  done
  pids=$(echo $ruby_procs | cut -c17-22)
  if [[ $ruby_procs = "" ]];then
    echo "No ruby / spring processes..."
    return
  fi
  echo "- Current Ruby processes ----> "
  echo $ruby_procs
  echo "- Aggressively kill -9 all? [i/y/N] (i = interactive)"
  read cfm
  if [[ $cfm = "y" ]]
  then
    for p in $pids
    do
      kill -9 $(numbers-only $p)
    done
  fi
  if [[ $cfm = "i" ]]
  then
    for rp in ${ruby_procs_arr[@]}
    do
      interactive-kill $rp $(echo $rp | cut -c17-22)
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

