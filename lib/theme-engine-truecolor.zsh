source ~/.zsh.d/lib/theme-engine.zsh

WeekDay="%(0w,Sun,)%(1w,Mon,)%(2w,Tue,)%(3w,Wed,)%(4w,Thu,)%(5w,Fri,)%(6w,Sat,)"

# Handle mandatory long var names
PROMPT='%F{$BracketColor}[%# %F{$NameColor}%n%F{$BracketColor}@%F{$MachineColor}%M$(is_ssh)%F{$BracketColor}|$WeekDay|%F{$TimeColor}%D{%I:%M%p}%F{$BracketColor}]$(git_info)
%F{$BracketColor}[%F{$PathColor}%~%F{$BracketColor}]$reset_color
'
