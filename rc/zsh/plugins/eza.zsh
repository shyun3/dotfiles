mkdir -p ~/.config/eza

EZA_THEME_DIR="$HOME/.cache/antidote/eza-community/eza-themes"
[[ -d "$EZA_THEME_DIR" ]] &&
    cp "$EZA_THEME_DIR/themes/one_dark.yml" ~/.config/eza/theme.yml
unset EZA_THEME_DIR
