alias lg='lazygit'

if (($+commands[lazygit])); then
    export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$ANTIDOTE_CACHE/catppuccin/lazygit/themes-mergable/mocha/blue.yml"
fi
