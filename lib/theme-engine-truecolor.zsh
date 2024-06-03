source ~/.zsh.d/lib/theme-engine.zsh

PROMPT='%F{$Bc}[%# %F{$Nc}%n%F{$Bc}@%F{$Mc}%M$(is_ssh)%F{$Bc}|%F{$Tc}%D{%I:%M%p}%F{$Bc}]$(git_info)$obreak%F{$Bc}[%F{$Pc}%~%F{$Bc}]$reset_color
'
