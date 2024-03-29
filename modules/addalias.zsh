addalias() {
  # addalias will add a persistent alias in ~/.zsh_aliases
  # It will also ensure you're not overwriting an existing alias unintentionally.

  if (( $# < 2 )); then
    echo "Usage: $0 <alias> <command> [args...]"
  else
    abbrev=$1
    shift 1
    command="$*"
    matching_alias=$(alias $abbrev)
    if [[ $matching_alias == "" ]]; then
      tmp=$(mktemp /tmp/add-alias.XXXXXXXXXX)
      echo "$abbrev  => $command"
      echo "alias $abbrev='$command'" > $tmp
      source $tmp
      cat $tmp >> $HOME/.zsh.d/modules/aliases.zsh
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
      grep "$abbrev=" -v $HOME/.zsh.d/modules/aliases.zsh > $tmp
      cat $tmp > $HOME/.zsh.d/modules/aliases.zsh
      rm $tmp
      unalias $abbrev
    fi
  fi
}

add-alias() {
  addalias "$@"
}

rm-alias() {
  rmalias "$@"
}

remove-alias() {
  rmalias "$@"
}

removealias() {
  rmalias "$@"
}
