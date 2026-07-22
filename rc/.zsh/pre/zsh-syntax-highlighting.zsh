function load_zsh_syn_hl_theme {
    source $ANTIDOTE_CACHE/catppuccin/zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

    # Disable cursor highlighting, as it causes the next character of an
    # autosuggestion to light up
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(${ZSH_HIGHLIGHT_HIGHLIGHTERS:#cursor})
}
