# General config defaults
git config --global --replace-all core.excludesfile     '~/.gitignore_global'

git config --global --replace-all pull.rebase           'true'
git config --global --replace-all push.default          'upstream'

# Let editors deal with whitespace cleanup for now... (To be continued...)
git config --global --unset core.whitespace
git config --global --unset apply.whitespace

git config --global --replace-all color.branch          'auto'
git config --global --replace-all color.diff            'auto'
git config --global --replace-all color.interactive     'auto'
git config --global --replace-all color.status          'auto'
git config --global --replace-all color.ui              'auto'

git config --global --replace-all branch.autosetupmerge 'true'

# Aliases

git config --global --replace-all alias.di              'diff'
git config --global --replace-all alias.co              'checkout'
git config --global --replace-all alias.ci              'commit'
git config --global --replace-all alias.br              'branch'

git config --global --replace-all alias.sta             'stash'
git config --global --replace-all alias.z               'stash'
git config --global --replace-all alias.snapshot        '! git stash save "snapshot: $(date)" && git stash apply "stash@{0}"'

git config --global --replace-all alias.st              'status -sb'

git config --global --replace-all alias.llog            'log --date=local'
git config --global --replace-all alias.l1              'log --oneline'
git config --global --replace-all alias.tree            'log --oneline --graph --decorate --all'

git config --global --replace-all alias.ap              '! git add --intent-to-add . && git add --patch'

git config --global --replace-all alias.ours            '! git checkout --ours $@ && git add $@'
git config --global --replace-all alias.theirs          '! git checkout --theirs $@ && git add $@'

# Note any $PATH accessible script called `git-$name` will run as
#
#    git $name
#
# You should setup complex git aliases like that.
#
# see ~/.zsh.d/bin/git-{rspec,jasmine,specs} for examples.
#
