# Usage:
#   color24 ff8800 "Text with foreground only"
#   color24 ff8800 000000 "Text with foreground and background"

color24() {
  local fg=${1:l}
  local bg=""
  local text=""
  
  if [[ $# -eq 2 ]]; then
    text=$2
  elif [[ $# -eq 3 ]]; then
    bg=${2:l}
    text=$3
  else
    echo "Usage: color24 <fg_hex> [bg_hex] <text>"
    return 1
  fi

  fg=${fg/#\#/}
  [[ -n $bg ]] && bg=${bg/#\#/}

  local r_fg=$((16#${fg[1,2]}))
  local g_fg=$((16#${fg[3,4]}))
  local b_fg=$((16#${fg[5,6]}))

  local esc="\e[38;2;${r_fg};${g_fg};${b_fg}m"

  if [[ -n $bg ]]; then
    local r_bg=$((16#${bg[1,2]}))
    local g_bg=$((16#${bg[3,4]}))
    local b_bg=$((16#${bg[5,6]}))
    esc+="\e[48;2;${r_bg};${g_bg};${b_bg}m"
  fi

  print -n "${esc}${text}\e[0m"
}

