# zsh-d

This is my standard zsh startup for Mac OS X. It uses Antigen and
oh-my-zsh, there is also support for additional modularized
configuration. 

### Installation and Usage

Just git clone

    git clone git@github.com:jasonm23/zsh-d ~/.zsh.d

Now run `~/.zsh.d/init`, you're all done.

### Antigen

You can update packages used by antigen (see .zshrc) by running

    antigen update

For more info on antigen, see https://github.com/zsh-users/antigen

### Machine specific themes

There is a set of themes in `~/.zsh.d/` you can name a theme based on
your machines's `hostname` and it will auto load.

### Local Config

This config is designed to be a master config for a team's machines.

You can setup local configuration in a file called `~/.zshrc.local` (and/or
a file called `~/.zsh.d/local.zsh` it will be _.gitignore_d) 

### Quick Dirty Modules

You can add files with a `.zsh` extension to `~/.zsh.d/modules`.
They will be auto-included in your startup.

Note: modules will run in alphabetical order. It's a simplistic system, and
it's assumed that modules will be standalone.

If dependenices are deemed necessary, create modules named
`00_name.zsh` and order them as you would for `/etc/init.d`.

### Contributing

Pull Requests are welcome, but this repo isn't really intended for general use, it's simply a useful template for teams which have no shared `~/` for zsh.

### Undocumented

There are many things in this config that need to be documented.

- bin
    - brew-up - run a brew install on all machines listed in `~/LOCAL`
    - edit - run edit using Emacs or Vim
    - emacs-app - run emacs as app from the command line
    - git-jasmine - run jasmine specs on suites added to git index
    - git-pair - set up the git local user as a pair, see script for usage.
    - git-rspec - run rspec spec on suites added to git index
    - git-scrublocals - remove local only branches interactively
    - git-specs - TODO
    - mirror - turn on off mirroring on multiple screens

- These files in ./bin run a small http server (via sinatra) to turn on / off target display mode.
	- target-display-mode
	- tdm-box
	- tdm-server
	- tdm_daemon.sh
	- tdm_server_setup.sh

- modules
	- aliases.zsh - a big collection of useful aliases
	- autoenv.zsh - autoenv config
	- bindkey.zsh - unbind a couple of keys that 
	- functions.zsh - many functions of varying usefulness 
	- gitconfig.zsh - setup git config 
	- iterm-shell-integration.zsh - iterm integration
	- z.zsh - init z config (fuzzy matching cd alternative)

