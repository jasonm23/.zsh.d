is_ssh() {
  [[ -n $SSH_CLIENT ]] && echo $ZSH_THEME_IS_SSH_SYMBOL
}

ssh-add-fzf() {
  ssh-add $(find ~/.ssh/ | grep -v -F ".pub" | grep -o '.*id.*' | fzf -m | tr '\n' ' ')
}
