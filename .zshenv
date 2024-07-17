#
# Terminal
#

export TERM=xterm-256color

if [[ -e /usr/libexec  ]]; then
  export PATH=$PATH:/usr/libexec
fi

export LANGUAGE="en_US"
export LC_CTYPE="en_US.UTF-8"
export LANG="C.UTF-8"
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
export BAT_THEME=azure

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

if [[ "$(which src-hilite-lesspipe.sh)" == "src-hilite-lesspipe.sh not found" ]]; then
  # no src-hilite-lesspipe
else
  export LESSPIPE=`which src-hilite-lesspipe.sh`
  export LESSOPEN="| ${LESSPIPE} %s"
fi

#
# Temporary Files
#

if [[ -d "$TMPDIR" ]]; then
  export TMPPREFIX="${TMPDIR%/}/zsh"
  if [[ ! -d "$TMPPREFIX" ]]; then
    mkdir -p "$TMPPREFIX"
  fi
fi

if [[ -e "$HOME/go" ]]; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
  if [[ -e "/usr/local/opt/go/libexec/bin" ]]; then
    export PATH=$PATH:/usr/local/opt/go/libexec/bin
  fi
fi

if [[ -e "/usr/local/lib/ruby/gems/3.2.0/bin" ]]; then
  export PATH=/usr/local/lib/ruby/gems/3.2.0/bin:$PATH
fi

if [[ -e "$HOME/flutter/bin" ]]; then
  export PATH=$PATH:$HOME/flutter/bin
fi

export COLORTERM=truecolor

export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias: "

if [[ -e "$HOME/.cask/bin" ]]; then
  export PATH="$HOME/.cask/bin:$PATH"
fi

if [[ -e "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -e "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -e "$HOME/.npm-global/bin" ]]; then
  export PATH="$HOME/.npm-global/bin:$PATH"
fi

if [[ -e "$HOME/bin" ]]; then
  export PATH="$HOME/bin:$PATH"
fi

export LC_CTYPE="en_US.UTF-8"

if [[ -e '/Applications/Android Studio.app/Contents/jre/Contents/Home' ]]; then
  export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home'
fi

export HISTSIZE=99999
export HISTFILESIZE=99999
export SAVEHIST=$HISTSIZE

if [[ -e "/usr/local/bin/src-hilite-lesspipe.sh" ]]; then
  export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
fi

if [[ "$OSTYPE" == darwin* ]]; then
  export APPLE_SSH_ADD_BEHAVIOR=macos
fi

export PIP_DEFAULT_TIMEOUT=100

if [[ -e "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi
