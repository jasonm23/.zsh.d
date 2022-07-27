kill-ring () {
  for e in ${killring[@]}
  do
      echo -n "$e" | tr '\n' '⤶'
  done
  echo "$CUTBUFFER" | tr '\n' '⤶'
}
zle -N kill-ring

kill-ring-fzf () {
	kill-ring | fzf --reverse
}
zle -N kill-ring-fzf

bindkey "^Xk" kill-ring-fzf
