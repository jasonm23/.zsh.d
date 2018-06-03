export PATH=$PATH:/usr/libexec

if [ ! -d $HOME/antigen ]; then
  git clone https://github.com/zsh-users/antigen.git $HOME/antigen
fi

source $HOME/antigen/antigen.zsh

# init antigen with oh-my-zsh
antigen use oh-my-zsh

# plugins... oh-my-zsh
antigen bundle aws
antigen bundle bower
antigen bundle brew
antigen bundle bundler
antigen bundle coffee
antigen bundle gem
antigen bundle git
antigen bundle heroku
antigen bundle knife
antigen bundle npm
antigen bundle nvm
antigen bundle python
antigen bundle rbenv
antigen bundle rake
antigen bundle ruby
antigen bundle ssh-agent
antigen bundle svn
antigen bundle thor
antigen bundle urltools
antigen bundle vagrant

if [[ `uname -a` =~ "Darwin" ]]; then
  antigen bundle osx
fi

# plugins... other sources
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle djui/alias-tips
antigen bundle mollifier/cd-gitroot

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

# Load modules after loading config (in case environment is adjusted)
# Source handmade modules
for z in $HOME/.zsh.d/modules/*.zsh; do
  source "$z"
done

export EMACS=yes
