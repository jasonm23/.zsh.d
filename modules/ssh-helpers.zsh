is_ssh() {
  [[ -n $SSH_CLIENT ]] && echo $ZSH_THEME_IS_SSH_SYMBOL
}
