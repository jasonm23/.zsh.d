# Customize to your needs...
alias gap='git add -N . && git add -p'
alias gpb='git push -u origin head'
alias gup='git pull --rebase --autostash'

alias grbrm='git-branch-remote-delete' # from functions.zsh
alias gbrrm='git-branch-remote-delete' # from functions.zsh
alias gbrd='git-branch-remote-delete' # from functions.zsh

alias gwb='current_branch' # from oh-my-zsh
alias grhd='git reset --hard'

alias gquick='git-quick-amend'
alias gquik='git-quick-amend'
alias gquak='git-quick-amend'
alias gqa='git-quick-amend'

[[ ! -z "$(alias gwip)" ]] && unalias gwip
alias gwip='git-wip' # from functions.zsh
alias gcwip='git-wip' # from functions.zsh

alias ghot='git-commit-hotfix' # from functions.zsh
alias gchot='git-commit-hotfix' # from functions.zsh
alias gchotfix='git-commit-hotfix' # from functions.zsh
alias ghotfix='git-commit-hotfix' # from functions.zsh

alias gcchor='git-commit-chore' # from functions.zsh
alias gcchore='git-commit-chore' # from functions.zsh
alias gchor='git-commit-chore' # from functions.zsh
alias gchore='git-commit-chore' # from functions.zsh

alias ghclone='gh repo clone'

# Edit and Aliases
alias e='edit'
alias ae='edit ~/.zsh.d/modules/aliases.zsh'
alias ar='source ~/.zsh.d/modules/aliases.zsh'
alias fur='for a in $HOME/.zsh.d/modules/*; do source "$a";done; eval "$(mdlit ~/.zsh.d/literate/video-functions.md)"'
alias ze='edit ~/.zshrc'
alias zv='edit ~/.zshenv'

# Listing
alias l='ls -a1'
alias ll='ls -halF'
alias la='ls -halF'

# Rails / Spring / Rspec
alias rp='rspec'
alias rpf='rspec --fail-fast'
alias rspecf='rspec --fail-fast'

alias rs='rails server'
alias rc='rails console'
alias rd='rails db'

alias ikr='interactively-kill-ruby' # from functions.zsh

alias rdm='rake db:migrate'
alias rdmr='rake db:migrate:redo'
alias rdmt='rake db:migrate db:test:prepare'

# Edit latest rails migration
alias eldm='edit `find ./db/migrate | tail -1`'

alias gitx='/Applications/GitX.app/Contents/Resources/gitx'

# Jump to Postgres repl
alias psq='psql -U postgres'

# what's my IP?
alias ifconfig_me='dig +short myip.opendns.com @resolver1.opendns.com'

# unix timestamp
alias timestamp='date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s"'


alias gcln='git clean -fd'

alias gtypist='gtypist -b -S -s -i'

alias yump3='youtube-dl --extract-audio --audio-format mp3'

alias diff='/usr/local/bin/diff'

alias doom='~/.emacs.d/bin/doom'
alias bsr='brew services restart'
alias ..='cd ..'
alias ...='cd ../..'
alias inkscape='/Applications/Inkscape.app/Contents/MacOS/inkscape'
alias bss='brew services stop'
alias ffpython='/Applications/FontForge.app/Contents/MacOS/FFPython'
alias killdock='killall -KILL Dock'
alias killfinder='killall -KILL Finder'
alias cdz='cd ~/.zsh.d'
