# zsh-d

This is my standard zsh startup for Mac OS X. It uses Antidote and
oh-my-zsh, there is also support for additional modularized
configuration.

### Installation and Usage

Just git clone

    git clone git@github.com:jasonm23/.zsh.d ~/.zsh.d

Now run `~/.zsh.d/install`, you're all done.

### Antidote

You can update packages used by antidote (see .zshrc) by running

    antidote update

For more info on antidote,  https://getantidote.github.io/ 

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

If dependency ordering is necessary. Follow the `initrc` convention and use named
ordering, e.g. `00_name.zsh`.

### Contributing

Pull Requests are welcome, but this repo isn't really intended for general use, it's simply a useful template for teams which have no shared `~/` for zsh.

# Notes...

- Literate experiment...
    - [video-functions](literate/video-functions.md) uses `bin/mdlit`
