if ! (( $+commands[yazi] )); then
    return
fi

alias y='yazi'

# Derived from https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
function yazi() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
