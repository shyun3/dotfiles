if ! (( $+commands[zoxide] )); then
    return
fi

# Derived from CTRL-T in fzf key-bindings.zsh
fzf_zoxide() {
  LBUFFER="$LBUFFER$(zoxide query -i)"
  local ret=$?
  zle reset-prompt
  return $ret
}

zle -N fzf_zoxide
bindkey '\ez' fzf_zoxide  # Alt-z
