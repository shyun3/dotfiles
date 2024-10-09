#!/bin/bash

# Sets up environment, installs packages
# Should be idempotent

set -eo pipefail

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

# Reads the tag of the latest release of a GitHub repo.
#
# Assumes that the tag starts with a 'v'. The 'v' is not included in the output.
#
# $1: GitHub slug in the form "owner/repo".
read_latest_github_tag() {
    # Derived from https://github.com/jesseduffield/lazygit?tab=readme-ov-file#ubuntu
    curl -s "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'
}

# These bin directories will only be added to PATH if they exist, see zshrc
mkdir -p ~/bin ~/.local/bin

# Packages
install_if_missing zsh fzf zoxide ranger atool
cmd_exists ctags-universal || yes_install universal-ctags
cmd_exists fd || {
    yes_install fd-find
    ln -s "$(which fdfind)" ~/.local/bin/fd
}
cmd_exists mountavfs || yes_install avfs

git clone git@github.com:jchook/ranger-zoxide.git \
    ~/.config/ranger/plugins/zoxide 2> /dev/null || true

# lazygit
if ! cmd_exists lazygit; then
    LAZYGIT_VERSION="$(read_latest_github_tag 'jesseduffield/lazygit')"
    tmpdir="$(mktemp -d)"
    curl -Lo "$tmpdir/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf "$tmpdir/lazygit.tar.gz" --directory="$tmpdir" lazygit
    sudo install "$tmpdir/lazygit" ~/.local/bin
fi

# pyenv
[[ -n "$PYENV_ROOT" ]] || curl https://pyenv.run | bash

# nvm
if [[ -z "$NVM_DIR" ]]; then
    NVM_VER="$(read_latest_github_tag 'nvm-sh/nvm')"
    PROFILE=/dev/null bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VER/install.sh | bash"
fi

# Oh My Zsh
[[ -n "$ZSH" ]] ||
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
[[ -n "$ZSH" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" 2> /dev/null || true

# chsh (should probably be last)
case "$SHELL" in
    */zsh) ;;
    *)
        echo "Changing shell to zsh..."
        sudo chsh -s "$(which zsh)"
        ;;
esac
