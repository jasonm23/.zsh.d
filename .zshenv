#
# Terminal
#

export TERM=xterm-256color

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors/Pagers
#

export EDITOR=edit
export PAGER="bat --style=grid"
export BAT_THEME=gruvbox-dark

#
# fzf
#

export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || bat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

typeset -gU cdpath fpath mailpath path

if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Add /usr/local to fpath - zsh completion path
fpath+=(/usr/local/share/zsh/site-functions/)

# Set the list of directories that Zsh searches for programs.
path=(
  ./bin
  ~/bin
  ~/.zsh.d/bin
  ./script
  /usr/local/{bin,sbin}
  /usr/local/share/npm/bin
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

export LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"

#
# Temporary Files
#

if [[ -d "$TMPDIR" ]]; then
  export TMPPREFIX="${TMPDIR%/}/zsh"
  if [[ ! -d "$TMPPREFIX" ]]; then
    mkdir -p "$TMPPREFIX"
  fi
fi

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=/usr/local/lib/ruby/gems/3.2.0/bin:$PATH
export PATH=$PATH:$HOME/flutter/bin
export COLORTERM=truecolor
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias: "

export PATH="$HOME/.cask/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export LC_CTYPE="en_US.UTF-8"
export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home'

export HISTSIZE=99999
export HISTFILESIZE=99999
export SAVEHIST=$HISTSIZE

export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
export APPLE_SSH_ADD_BEHAVIOR=macos

export PIP_DEFAULT_TIMEOUT=100
