if (( $+commands[delta] )); then
    delta --generate-completion zsh > $ZSH_CACHE_DIR/completions/_delta

    # Completion gets overriden by builtin script, see delta#1022. Re-override
    # to fix completion.
    compdef _delta delta
fi
