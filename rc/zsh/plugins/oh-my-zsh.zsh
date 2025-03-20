if [[ -n "$ZSH" ]]; then
    # This is run in oh-my-zsh.sh, but use-omz does not run that or check for
    # upgrade it seems
    source "$ZSH/tools/check_for_upgrade.sh"
fi
