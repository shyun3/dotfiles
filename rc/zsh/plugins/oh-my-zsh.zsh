if [[ -n "$ZSH" ]]; then
    # This is run in oh-my-zsh.sh, but use-omz does not run that or check for
    # upgrade it seems
    #
    # There is a check in this script for stdout attached to terminal or
    # Powerlevel10k instant prompt. For some reason, this fails even though
    # Powerlevel10k is being sourced beforehand. Maybe antidote also messes
    # with the terminal redirect.
    #
    # Anyway, force the instant prompt variable to allow the script to proceed
    POWERLEVEL9K_INSTANT_PROMPT=on source "$ZSH/tools/check_for_upgrade.sh"
fi
