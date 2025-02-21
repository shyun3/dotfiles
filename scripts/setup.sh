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

export EGET_BIN="$BIN_HOME"
cmd_exists bat || eget sharkdp/bat --asset=gnu
cmd_exists fd || eget sharkdp/fd --asset=gnu
cmd_exists delta || eget dandavison/delta --asset=gnu
cmd_exists viv || eget jannis-baum/Vivify --all
cmd_exists fzf || eget junegunn/fzf
cmd_exists zoxide || eget ajeetdsouza/zoxide
cmd_exists lazygit || eget jesseduffield/lazygit
cmd_exists nvim || eget neovim/neovim
cmd_exists uv || eget astral-sh/uv --asset=gnu --all
unset EGET_BIN

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
[[ -f "$DATA_HOME/delta/themes.gitconfig" ]] || eget dandavison/delta --source \
    --file=themes.gitconfig --to="$DATA_HOME/delta/themes.gitconfig"

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
git_take mattmc3/antidote "${ZDOTDIR:-$HOME}/.antidote"

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
