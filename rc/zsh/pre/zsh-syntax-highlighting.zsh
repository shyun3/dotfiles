SYN_THEME=$ANTIDOTE_CACHE/catppuccin/zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
[[ ! -f $SYN_THEME ]] || source $SYN_THEME
unset SYN_THEME

# Disable cursor highlighting, as it causes the next character of an
# autosuggestion to light up
ZSH_HIGHLIGHT_HIGHLIGHTERS=(${ZSH_HIGHLIGHT_HIGHLIGHTERS:#cursor})
