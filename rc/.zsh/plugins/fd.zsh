if ! (($+commands[fd])) || ! (($+commands[vivid])); then
    return
fi

function fd() {
    # `LS_COLORS` overrides eza theme, so isolate to `fd` (see eza#1700). Note
    # that `LS_COLORS` only affects file and folder names, see discussion
    # catppuccin#2528.
    LS_COLORS=$(vivid generate catppuccin-mocha) command fd "$@"
}
