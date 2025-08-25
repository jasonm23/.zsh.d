#
# Terminal
#

export TERM=xterm-256color
export EDITOR=edit
export LANGUAGE="en_US"
export LANG='en_US.UTF-8'
export LC_CTYPE="en_US.UTF-8"

if [[ -f $HOME/.cargo/bin/bat ]]; then
  export PAGER="bat --style=grid"
  export BAT_THEME=azure
fi

export COLORTERM=truecolor
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias: "
export ZSH_DISABLE_COMPFIX=true
export HISTSIZE=99999
export HISTFILESIZE=99999
export SAVEHIST=$HISTSIZE
export PIP_DEFAULT_TIMEOUT=100

plugins=(redis-cli)

if [[ -d /usr/libexec  ]]; then
  export PATH=$PATH:/usr/libexec
fi

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

typeset -gU cdpath fpath mailpath path

# Add /usr/local to fpath - zsh completion path
fpath+=(/usr/local/share/zsh/site-functions/)

# Set the list of directories that Zsh searches for programs.
path=(
  ./bin
  $HOME/bin
  $HOME/.zsh.d/bin
  ./script
  /usr/local/{bin,sbin}
  /usr/local/share/npm/bin
  $path
)

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

if [[ -e "$TMPDIR" ]]; then
  export TMPPREFIX="${TMPDIR%/}/zsh"
  if [[ ! -d "$TMPPREFIX" ]]; then
    mkdir -p "$TMPPREFIX"
  fi
fi

if [[ -d "$HOME/go" ]]; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
  if [[ -d "/usr/local/opt/go/libexec/bin" ]]; then
    export PATH=$PATH:/usr/local/opt/go/libexec/bin
  fi
fi

if [[ -d "/usr/local/go" ]]; then
  export PATH=$PATH:/usr/local/go/bin
fi

if [[ -d "/usr/local/lib/ruby/gems/3.2.0/bin" ]]; then
  export PATH=/usr/local/lib/ruby/gems/3.2.0/bin:$PATH
fi

if [[ -d $HOME/.rbenv/bin ]]; then
  export PATH=$HOME/.rbenv/bin:$PATH
fi

if [[ -d "$HOME/flutter/bin" ]]; then
  export PATH=$PATH:$HOME/flutter/bin
fi

if [[ -d "$HOME/.cask/bin" ]]; then
  export PATH="$HOME/.cask/bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -d "$HOME/.npm-global/bin" ]]; then
  export PATH="$HOME/.npm-global/bin:$PATH"
fi

if [[ -d "$HOME/bin" ]]; then
  export PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/.config/emacs/bin" ]]; then
  export PATH="$HOME/.config/emacs/bin:$PATH"
fi

if [[ -d "$HOME/.emacs.d/bin" ]]; then
  export PATH="$HOME/.emacs.d/bin:$PATH"
fi

# Mac android studio
if [[ -d '/Applications/Android Studio.app/Contents/jre/Contents/Home' ]]; then
  export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home'
fi

if [[ -e "/usr/local/bin/src-hilite-lesspipe.sh" ]]; then
  export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
fi

if [[ "$OSTYPE" == darwin* ]]; then
  export APPLE_SSH_ADD_BEHAVIOR=macos
fi

if [[ -e "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# Nim
if [[ -d $HOME/.nimble/bin ]]; then
  export PATH=$HOME/.nimble/bin:$PATH
fi

# X11 forwarding...
if [[ -z "$DISPLAY" && -n "$SSH_CONNECTION" ]]; then
    export DISPLAY=localhost:10.0
fi

# Linux Java
if [[ -d /usr/lib/jvm/java-8-openjdk-amd64 ]]; then
  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
  export PATH=$PATH:$JAVA_HOME/bin
fi

# Linux Android Dev
if [[ -d $HOME/Android ]]; then
  export ANDROID_HOME=$HOME/Android
  export PATH=$PATH:$ANDROID_HOME/tools/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

if [[ -e "/usr/local/cuda/bin" ]]; then
  export PATH=/usr/local/cuda/bin:$PATH
fi

if [[ -x $(which fnm) ]]; then
    source <(fnm env --shell zsh)
fi
