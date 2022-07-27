# Git helper functions

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
  git remote set-url ${1:-origin} $ssh_remote
}

git-delete-remote-tag () {
  git push origin :refs/tags/${1}
}


git-mass-status() {
  for a in $(fd --type d --maxdepth 1 --exclude .git)
  do
    pushd -q "$a"
    if [[ -d .git ]]; then
      changes=$(git status --short | wc -l | tr -d " \n")
      if (( changes > 0 )); then
        suffix=$( (( changes > 1 )) && echo "changes" || echo "change" )
        echo "⟶ : $a : $changes $suffix"
      fi
    fi
    popd -q
  done | fzf --header="[ Enter: add-all & commit | C-x: clean ]" \
      -m  \
      -d: \
      --with-nth 2,3 \
      --preview 'git-mass-status-preview status "{2}"' \
      --bind 'ctrl-x:execute(git-mass-status-preview clean {2}):reload,enter:execute(git-mass-status-preview addall {2})+abort'
}

git-commits-this-week () {
	git log --oneline --since last-week | wc -l | tr -d '\n '
}
