if ! [[ -e ${ZDOTDIR:-~}/.antidote ]]; then
    git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# Config ZSH Highlighter
[[ ! -z $ZSH_HIGHLIGHT_HIGHLIGHTERS ]] && ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
[[ ! -z $ZSH_HIGHLIGHT_STYLES ]] && ZSH_HIGHLIGHT_STYLES[globbing]=fg=yellow

# apply theme
host_theme=$HOME/.zsh.d/themes/$(hostname).zsh-theme

if [ -r $host_theme ]; then
    source $host_theme
else
  # apply default theme
  source $HOME/.zsh.d/themes/ocodo.zsh-theme
fi

# Get zmv
autoload zmv

# Load local config
[[ -r $HOME/.zsh.d/local.zsh ]] && source $HOME/.zsh.d/local.zsh
[[ -r $HOME/.zshrc.local ]] &&  source $HOME/.zshrc.local

# Load modules after loading config (in case environment is adjusted)
# Source handmade modules

for z in $HOME/.zsh.d/modules/*.zsh; do
  source "$z"
done

# Load literate markdown shell scripts
for z in $HOME/.zsh.d/literate/*.md; do
  tempfile=$(mktemp)
  $HOME/.zsh.d/bin/mdlit "$z" > $tempfile
  source $tempfile
  rm $tempfile
done

export EMACS=emacs

# Allow completion to expand around [._-], for example:
# .z.d [TAB] -> .zsh.d
# m-s [TAB] -> markdown-soma
# M_A [TAB] -> Massive_Attack
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# We bind M-l to it's default, oh-my-zsh clobbers M-l (Alt-l) by binding it to "ls<RET>"
bindkey "l" down-case-word # Alt/Opt/Meta-l lowercase from cursor to word end

# Make C-u consistent with bash backward-kill-line
bindkey "\C-u" backward-kill-line

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

autoenv_activate="$HOME/.autoenv/activate.sh"
if [[ -e "$autoenv_activate" ]]; then
    source "$autoenv_activate"
fi

setopt histignorespace
setopt globdots
setopt histignoredups
setopt histignorealldups
setopt interactivecomments
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

if [[ -e "$HOME/.autoenv/activate.sh" ]]; then
    source ~/.autoenv/activate.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [[ "$(pwd)" != "$HOME" ]]; then
    cd "$HOME"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ $USER == root ]]; then
    echo "Root user, skipping ssh-agent setup."
else
  if [[ $SSH_AUTH_SOCK == $HOME/.ssh/sock && $SSH_AGENT_PID == $(pidof ssh-agent) ]]; then
      echo "ssh-agent connected"
      ssh-add -l
  elif pidof ssh-agent && [[ -e ~/.ssh/sock ]]; then
      echo "ssh-agent re-connect to PID $(pidof ssh-agent)"
  else
    echo "ssh-agent start"
    rm -rf ~/.ssh/sock
    ssh-agent -a ~/.ssh/sock
  fi
    export SSH_AUTH_SOCK=~/.ssh/sock
    export SSH_AGENT_PID=$(pidof ssh-agent)
    ssh-add -l
fi

echo ".zsh.d checking for updates..."
git -C $HOME/.zsh.d remote update > /dev/null

zsh_d_git_status=$(git -C $HOME/.zsh.d status --ahead-behind | grep -F 'Your branch')

if [[ "${zsh_d_git_status}" =~ 'ahead|behind' ]]; then
    echo ".zsh.d - ${zsh_d_git_status}"
fi
