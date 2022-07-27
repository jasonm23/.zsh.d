export PATH=$PATH:/usr/libexec

if [ ! -d $HOME/antigen ]; then
  git clone https://github.com/zsh-users/antigen.git $HOME/antigen
fi

source $HOME/antigen/antigen.zsh

# init antigen with oh-my-zsh
antigen use oh-my-zsh

# plugins... oh-my-zsh
antigen bundle aws
antigen bundle bundler
antigen bundle coffee
antigen bundle gem
antigen bundle git
antigen bundle fzf
antigen bundle npm
antigen bundle nvm
antigen bundle python
antigen bundle rake
antigen bundle ruby
antigen bundle thor
antigen bundle urltools
antigen bundle z
antigen bundle flutter

if [[ `uname -a` =~ "Darwin" ]]; then
  antigen bundle macos
  antigen bundle xcode
  antigen bundle brew
fi

# plugins... other sources
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle djui/alias-tips
antigen bundle mollifier/cd-gitroot

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

antigen apply

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

export FZF_DEFAULT_OPTS='--height 40% --border --info hidden'

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

# Export SSH_AUTH_SOCK and SSH_AGENT_PID
$(ssh-fix-env)

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

export PATH="/usr/local/opt/ruby/bin:$PATH"

