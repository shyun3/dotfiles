bat --completion zsh > $ZSH_CACHE_DIR/completions/_bat

CATPPUCCIN_THEME_DIR="$(bat --config-dir)/themes"
if [[ ! -d "$CATPPUCCIN_THEME_DIR" ]]; then
    mkdir -p $CATPPUCCIN_THEME_DIR
    cp $ANTIDOTE_CACHE/catppuccin/bat/themes/*.tmTheme $CATPPUCCIN_THEME_DIR

    bat cache --build
fi
unset CATPPUCCIN_THEME_DIR
