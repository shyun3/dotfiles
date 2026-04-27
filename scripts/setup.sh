#!/bin/bash

# Sets up environment, installs packages
# Should be idempotent

set -euo pipefail

cmd_exists() {
    command -v "$1" &> /dev/null
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
LOCAL_DIR="$HOME/.local"
BIN_HOME="$LOCAL_DIR/bin"
mkdir -p ~/bin "$BIN_HOME"

# Custom zsh completions
mkdir -p ~/.zsh-complete

# Neovim 'undodir'
mkdir -p "$LOCAL_DIR/share/nvim/undo"

#######################################################################
# Packages
#
# Guidelines for inclusion:
# - Not present in mise
# - Same name across Linux distros and macOS
# - Don't care about version updates

install_if_missing 7zip avfs tree universal-ctags xclip xdg-utils zsh

if [[ $(lsb_release -si 2> /dev/null) == Ubuntu ]]; then
    install_if_missing update-notifier-common
fi

if [[ $(uname -r) =~ WSL ]]; then
    # This is needed so that `xdg-open` can open links in Windows browser
    install_if_missing wslu
fi

#######################################################################
# mise

# Using exact location since PATH updates may not have been applied yet
MISE="$BIN_HOME/mise"

cmd_exists "$MISE" || curl https://mise.run | sh
"$MISE" install

#######################################################################
# antidote

if [[ ! -d ~/.antidote ]]; then
    git clone --depth=1 "https://github.com/mattmc3/antidote.git" ~/.antidote
fi

#######################################################################
# chsh (should probably be last)
SHELL="${SHELL:-}"
case "$SHELL" in
    */zsh) ;;
    *)
        echo "Changing shell to zsh..."
        sudo chsh --shell "$(which zsh)" "$USER"
        ;;
esac
