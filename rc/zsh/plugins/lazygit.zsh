if ! (( $+commands[lazygit] )); then
    return
fi

alias lg='lazygit'

export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$ANTIDOTE_CACHE/catppuccin/lazygit/themes-mergable/mocha/blue.yml"
