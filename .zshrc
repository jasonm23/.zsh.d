if [ ! -f $HOME/antigen/antigen.zsh ]; then
  git clone git://github.com/zsh-users/antigen.git $HOME/antigen
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
antigen bundle osx
antigen bundle python
antigen bundle rbenv
antigen bundle rake
antigen bundle ruby
antigen bundle ssh-agent
antigen bundle svn
antigen bundle thor
antigen bundle urltools
antigen bundle vagrant

# plugins... other sources
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle djui/alias-tips
antigen bundle mollifier/cd-gitroot

# Config ZSH Highlighter
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[globbing]=fg=yellow

# apply theme
host_theme=$HOME/.zsh.d/themes/$(hostname).zsh-theme

if [ -r $host_theme ]; then
  source $host_theme
else
  # apply default theme
  antigen theme ocodo/oh-my-zsh themes/ocodo
fi

# tell antigen we're done
antigen apply

# Let's have zmv
autoload zmv

# Load local config
if [ -f $HOME/.zsh.d/local.zsh ]; then
  source $HOME/.zsh.d/local.zsh
fi

if [ -f $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local
fi

# Load modules after loading config (in case environment is adjusted)

# Source handmade modules
for z in $HOME/.zsh.d/modules/*.zsh; do
  source "$z"
done

source $HOME/.iterm2_shell_integration.zsh

export EMACS=yes
