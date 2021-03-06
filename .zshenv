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
# Editors
#

export EDITOR='~/.zsh.d/bin/edit'
export PAGER='less'

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
export LESS=' -R -X -F '

#
# Temporary Files
#

if [[ -d "$TMPDIR" ]]; then
  export TMPPREFIX="${TMPDIR%/}/zsh"
  if [[ ! -d "$TMPPREFIX" ]]; then
    mkdir -p "$TMPPREFIX"
  fi
fi

alias git_branch_clean_up= 'git branch --merged | grep -v \* | xargs git branch -d'

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin

export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias: "
