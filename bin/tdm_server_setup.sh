#!/bin/zsh --login

rvm use 2.2.3@zsh-bin --create
rvm wrapper 2.2.3@zsh-bin
cd ~/.zsh.d/bin/
bundle
