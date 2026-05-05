if ! (($+commands[zoxide])); then
    return
fi

# Derived from CTRL-T in fzf key-bindings.zsh
fzf_zoxide() {
    local query=$(zoxide query -i)
    LBUFFER="$LBUFFER${(q)query}"

    local ret=$?
    zle reset-prompt
    return $ret
}

zle -N fzf_zoxide
bindkey '\ez' fzf_zoxide # Alt-z
