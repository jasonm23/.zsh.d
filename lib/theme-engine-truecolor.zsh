source ~/.zsh.d/lib/theme-engine.zsh

# Handle optional long var names
[[ -z "$BracketColor" ]] || Bc=$BracketColor
[[ -z "$NameColor" ]] || Nc=$NameColor
[[ -z "$MachineNameColor" ]] || Mc=$MachineNameColor
[[ -z "$TimeColor" ]] || Tc=$TimeColor
[[ -z "$DateColor" ]] || Dc=$DateColor
[[ -z "$PathColor" ]] || Pc=$PathColor
[[ -z "$RVM_Color" ]] || RMVc=$RVM_Color

PROMPT='%F{$Bc}[%# %F{$Nc}%n%F{$Bc}@%F{$Mc}%M$(is_ssh)%F{$Bc}|%F{$Tc}%D{%I:%M%p}%F{$Bc}]$(git_info)$obreak%F{$Bc}[%F{$Pc}%~%F{$Bc}]$reset_color
'
