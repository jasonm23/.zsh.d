zsh-theme-fzf() {
    theme=$(find $HOME/.zsh.d/themes/ | rg -o "themes/(.*)\.zsh-theme" --replace '$1' | fzf)
    theme_file="$HOME/.zsh.d/themes/${theme}.zsh-theme"
    echo "Theme: ${theme_file}"
    source "${theme_file}"
}
