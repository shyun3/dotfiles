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

# Installs Oh My Zsh custom themes or plugins.
#
# $1: Customization type, must be "themes" or "plugins".
# $rest: GitHub slugs in the form "owner/repo".
install_omz_custom() {
    local -A types=([themes]=1 [plugins]=1)
    if [[ -z "${types[$1]}" ]]; then
        return 1
    fi

    local custom_type=$1
    shift

    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local src
    for slug in "$@"; do
        src=$(cut -d / -f 2 <<< "$slug")
        dst="$custom_dir/$custom_type/$src"
        if [[ ! -d "$dst" ]]; then
            git clone --depth=1 "https://github.com/$slug" "$dst"
        fi
    done
}

#######################################################################

# This bin directory will only be added to PATH if it exists, see zprofile
mkdir -p ~/bin

# Neovim 'undodir'
mkdir -p ~/.local/share/nvim/undo

#######################################################################
# Packages
install_if_missing zsh ranger atool nodejs npm bat xclip archivemount tldr
cmd_exists ctags-universal || yes_install universal-ctags
cmd_exists fd || yes_install fd-find
cmd_exists rg || yes_install ripgrep
cmd_exists mountavfs || yes_install avfs
cmd_exists xdg-open || yes_install xdg-utils

if [[ $(uname -r) =~ WSL ]]; then
    cmd_exists wslview || yes_install wslu
fi

#######################################################################

# fzf
if ! cmd_exists fzf; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin
fi

# zoxide
cmd_exists zoxide || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# ranger
git clone git@github.com:jchook/ranger-zoxide.git \
    ~/.config/ranger/plugins/zoxide 2> /dev/null || true

# lazygit
if ! cmd_exists lazygit; then
    LAZYGIT_VERSION="$(read_latest_github_tag 'jesseduffield/lazygit')"
    tmpdir="$(mktemp -d)"
    curl -Lo "$tmpdir/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf "$tmpdir/lazygit.tar.gz" --directory="$tmpdir" lazygit
    install "$tmpdir/lazygit" ~/.local/bin
fi

# Vivify
if ! cmd_exists viv; then
    tmpdir="$(mktemp -d)"
    curl -Lo "$tmpdir/vivify-linux.tar.gz" https://github.com/jannis-baum/Vivify/releases/latest/download/vivify-linux.tar.gz
    tar xf "$tmpdir/vivify-linux.tar.gz" --directory ~/.local/bin --strip-components=1
fi

# pyenv
if [[ -z "$PYENV_ROOT" ]]; then
    curl https://pyenv.run | bash

    # Install Python build dependencies
    # See https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    yes_install build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils \
        tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # Installing Python through pyenv sets up shims for `python` and `pip`
    pyenv install 3
    pyenv global 3

    pyenv virtualenv 3 neovim
    pyenv activate neovim
    pip install pynvim
    pyenv deactivate
fi

# Neovim
if ! cmd_exists nvim; then
    NVIM="$HOME/.local/bin/nvim"
    curl -Lo "$NVIM" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x "$NVIM"
    "$NVIM" --headless +qa
fi

# pipx
pip_pkgs=(ipython poetry)
for pkg in "${pip_pkgs[@]}"; do
    cmd_exists "$pkg" || pipx install "$pkg"
done

#######################################################################
# Oh My Zsh
if [[ -z "$ZSH" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

install_omz_custom themes romkatv/powerlevel10k
install_omz_custom plugins zsh-users/zsh-syntax-highlighting zsh-users/zsh-autosuggestions

#######################################################################
# chsh (should probably be last)
case "$SHELL" in
    */zsh) ;;
    *)
        echo "Changing shell to zsh..."
        sudo chsh -s "$(which zsh)"
        ;;
esac
