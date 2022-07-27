
pb-kill-line () {
  zle kill-line
  echo -n $CUTBUFFER | pbcopy
}
zle -N pb-kill-line

pb-kill-whole-line () {
  zle kill-whole-line
  echo -n $CUTBUFFER | pbcopy
}
bindkey "\ek"  pb-kill-whole-line
zle -N pb-kill-whole-line

pb-backward-kill-word () {
  zle backward-kill-word
  echo -n $CUTBUFFER | pbcopy
}
zle -N pb-kill-word

pb-kill-word () {
  zle kill-word
  echo -n $CUTBUFFER | pbcopy
}
zle -N pb-kill-word

pb-kill-buffer () {
  zle kill-buffer
  echo -n $CUTBUFFER | pbcopy
}
bindkey "\e^b" pb-kill-buffer
zle -N pb-kill-buffer

pb-copy-region-as-kill-deactivate-mark () {
  zle copy-region-as-kill
  zle set-mark-command -n -1
  echo -n $CUTBUFFER | pbcopy
}
zle -N pb-copy-region-as-kill-deactivate-mark
bindkey "\eK"  pb-copy-region-as-kill-deactivate-mark

pb-yank () {
  CUTBUFFER=$(pbpaste)
  zle yank
}
zle -N pb-yank
