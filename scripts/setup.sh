#!/bin/bash

# Sets up environment, installs packages
# Should be idempotent

set -euo pipefail

cmd_exists() {
    hash "$1" 2> /dev/null
}

yes_install() {
    sudo apt install -y "$@"
}

install_if_missing() {
    for pack in "$@"; do
        cmd_exists "$pack" || yes_install "$pack"
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
install_if_missing zsh ranger atool nodejs npm xclip archivemount tldr tree
cmd_exists ctags-universal || yes_install universal-ctags
cmd_exists rg || yes_install ripgrep
cmd_exists mountavfs || yes_install avfs
cmd_exists xdg-open || yes_install xdg-utils

if [[ $(uname -r) =~ WSL ]]; then
    cmd_exists wslview || yes_install wslu
fi

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

if cmd_exists uv; then
    pip_pkgs=(dotdrop ipython)
    for pkg in "${pip_pkgs[@]}"; do
        cmd_exists "$pkg" || uv tool install "$pkg"
    done
fi

#######################################################################
# Assets

# Performs a shallow git clone.
#
# $1: GitHub slug, in the form "owner/repo".
# $2: Destination directory.
#   If Destination already exists, errors will be silently suppressed.
git_take() {
    local slug="${1:?}"
    local dir="${2:?}"
    git clone --depth=1 "https://github.com/${slug}.git" "$dir" 2> /dev/null ||
        true
}

git_take jchook/ranger-zoxide ~/.config/ranger/plugins/zoxide
git_take mattmc3/antidote ~/.antidote

#######################################################################
# Completions
COMP_DIR="$HOME/.zsh/completion"
mkdir -p "$COMP_DIR"

bat --completion zsh > "$COMP_DIR/_bat-completion.zsh"

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
