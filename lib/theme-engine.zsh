# setup colours and then source this file

# Use with xterm-256color, see the xterm page at wikipedia
# for a color chart with xterm color indecies.
# http://en.wikipedia.org/wiki/xterm
# - gist - https://gist.github.com/jasonm23/2868981
# - SVG - https://gist.githubusercontent.com/jasonm23/2868981/raw/xterm-256color.svg
# - Yaml - https://gist.githubusercontent.com/jasonm23/2868981/raw/xterm-256color.yaml

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="$fg_bold[red]($fg_bold[white]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$fg_bold[red])"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY=" ✨ "
ZSH_THEME_IS_SSH_SYMBOL="⚡️️ "

# optional line-break
obreak="
"
# The final % (or #) prompt is always on a new line.
PROMPT='$FG[$Bc][%# $FG[$Nc]%n$FG[$Bc]@$(is_ssh)$FG[$Mc]%M$FG[$Bc]|$FG[$Tc]%D{%I:%M%p} $FG[$Dc]%D{%a %d/%b} (%D{%z})$FG[$Bc]]$FG[$Bc][$(git_prompt_info)$FG[$RVMc]$(rvm_prompt_info)$FG[$Bc]][$FG[$Pc]$(git_pair_info)$FG[$Bc]]$obreak$FG[$Bc][$FG[$Pc]%~$FG[$Bc]]$reset_color
'
