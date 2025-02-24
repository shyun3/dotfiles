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
        dpkg-query --show "$pack" 2> /dev/null | grep "$pack" ||
            sudo apt install -y "$pack"
    done
}

#######################################################################

# These bin directories will only be added to PATH if they exist, see zprofile
LOCAL="$HOME/.local"
BIN_HOME="$LOCAL/bin"
mkdir -p ~/bin "$BIN_HOME"

# Neovim 'undodir'
DATA_HOME="$LOCAL/share"
mkdir -p "$DATA_HOME/nvim/undo"

#######################################################################
# Packages
install_if_missing archivemount atool avfs nodejs npm ranger ripgrep tldr tree \
    universal-ctags xclip xdg-utils zsh
[[ $(uname -r) =~ WSL ]] && install_if_missing wslu

#######################################################################
# GitHub binaries
cmd_exists eget || (cd "$BIN_HOME" && curl https://zyedidia.github.io/eget.sh |
    sh)

SCRIPT_DIR="$(dirname "$0")"
EGET_CONFIG="$SCRIPT_DIR/eget.toml" eget --download-all

# Extracted file doesn't get renamed properly
eget neovim/neovim --asset=x86 --to="$BIN_HOME/nvim" --upgrade-only

# Since the repo name differs from the binary name, specify target file to make
# sure upgrades work properly. See the following comment:
# https://github.com/zyedidia/eget/issues/65#issuecomment-2602644737
for file in viv vivify-server; do
    eget jannis-baum/Vivify --file=$file --to="$BIN_HOME/$file" --upgrade-only
done

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

# Obtains the latest commit of a Git repo.
#
# $1: GitHub slug, in the form "owner/repo".
# $2: Destination directory.
git_take() {
    local slug="${1:?}"
    local dir="${2:?}"

    if [[ ! -d "$dir" ]]; then
        git clone --depth=1 "https://github.com/${slug}.git" "$dir"
    else
        (cd "$dir" && git pull --depth=1 "$dir")
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
