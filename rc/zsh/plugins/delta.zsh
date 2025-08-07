if (( $+commands[delta] )); then
    # Completion gets overriden by builtin script, see delta#1022. Re-override
    # to fix completion.
    compdef _delta delta
fi
