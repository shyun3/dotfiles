#!/bin/bash

# Sets up environment, installs packages
# Should be idempotent

set -euo pipefail

cmd_exists() {
    hash "$1" 2> /dev/null
}

install_if_missing() {
    local pack
    for pack in "$@"; do
        dpkg-query \
            --showformat '${binary:Package} ${db:Status-Abbrev} ${Version}\n' \
            --show "$pack" | grep "^$pack ii" || sudo apt install -y "$pack"
    done
}

#######################################################################

# These bin directories will only be added to PATH if they exist, see zprofile
LOCAL="$HOME/.local"
BIN_HOME="$LOCAL/bin"
mkdir -p ~/bin "$BIN_HOME"

# Neovim 'undodir'
mkdir -p "$LOCAL/share/nvim/undo"

#######################################################################
# Packages
install_if_missing archivemount atool avfs nodejs npm ranger ripgrep tldr tree \
    universal-ctags xclip xdg-utils zsh

if [[ $(uname -r) =~ WSL ]]; then
    install_if_missing wslu
fi

#######################################################################
# GitHub binaries
cmd_exists eget || (cd "$BIN_HOME" && curl https://zyedidia.github.io/eget.sh |
    sh)

SCRIPT_DIR="$(dirname "$0")"
(cd "$SCRIPT_DIR" && ./eget_noclobber.py eget.toml)

#######################################################################
# uv
NVIM_DIR="$HOME/.config/nvim"
if [[ ! -d "$NVIM_DIR/.venv" ]]; then
    uv --directory "$NVIM_DIR" venv
    uv --directory "$NVIM_DIR" pip install pynvim
fi

pip_pkgs=(dotdrop ipython)
for pkg in "${pip_pkgs[@]}"; do
    uv tool install "$pkg"
done

#######################################################################
# Assets

# Performs a shallow git clone.
#
# $1: GitHub slug, in the form "owner/repo".
# $2: Destination directory. Silently skipped if directory exists.
git_take() {
    local slug="${1:?}"
    local dir="${2:?}"

    if [[ ! -d "$dir" ]]; then
        git clone --depth=1 "https://github.com/$slug.git" "$dir"
    fi
}

git_take jchook/ranger-zoxide ~/.config/ranger/plugins/zoxide
git_take mattmc3/antidote ~/.antidote

#######################################################################
# chsh (should probably be last)
SHELL="${SHELL:-}"
case "$SHELL" in
    */zsh) ;;
    *)
        echo "Changing shell to zsh..."
        sudo chsh -s "$(which zsh)" "$USER"
        ;;
esac
