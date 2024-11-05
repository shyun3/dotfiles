#!/bin/bash

# Sets up environment, installs packages
# Should be idempotent

set -euo pipefail

cmd_exists() {
    local cmd="${1:?empty}"
    hash "$cmd" 2> /dev/null
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
# Assumes that the tag starts with a 'v'.
#
# $1: GitHub slug in the form "owner/repo".
#
# Return: Tag name, without a leading 'v'.
read_latest_github_tag() {
    local slug="${1:?empty}"

    # Derived from https://github.com/jesseduffield/lazygit?tab=readme-ov-file#ubuntu
    curl -s "https://api.github.com/repos/$slug/releases/latest" |
        grep -Po '"tag_name": "v\K[^"]*'
}

# Downloads a file from the latest tag of a GitHub repo.
#
# $1: GitHub slug in the form "owner/repo".
# $2: Base filename to download from the tag.
#   If the filename contains the version of the latest tag, replace it with the
#   placeholder string @VERSION@.
#
# Return: Path to temporary downloaded file. This will be in $SETUP_DIR.
download_latest_github_tag() {
    local slug="${1:?empty}"
    local filename="${2:?empty}"

    if [[ "$filename" =~ @VERSION@ ]]; then
        local version
        version="$(read_latest_github_tag "$slug")"

        filename="${filename/@VERSION@/$version}"
    fi

    local dst="$SETUP_DIR/$filename"
    curl -Lo "$dst" "https://github.com/$slug/releases/latest/download/$filename"

    echo "$dst"
}

# Installs Oh My Zsh custom themes or plugins.
#
# $1: Customization type, must be "themes" or "plugins".
# $rest: GitHub slugs in the form "owner/repo".
install_omz_custom() {
    local custom_type="${1:?empty}"
    shift

    local -A types=([themes]=1 [plugins]=1)
    if [[ -z "${types[$custom_type]}" ]]; then
        return 1
    fi

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

# For Oh My Zsh completions that are setup
OMZ_COMPS="$HOME/.oh-my-zsh/completions"
mkdir -p "$OMZ_COMPS"

# Neovim 'undodir'
mkdir -p ~/.local/share/nvim/undo

# Temporary directory for downloaded files
SETUP_DIR="$(mktemp -d /tmp/setup.$$.XXXXXXXX)"
trap 'rm -rf $SETUP_DIR' EXIT

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

cmd_exists bat ||
    yes_install "$(download_latest_github_tag 'sharkdp/bat' 'bat_@VERSION@_amd64.deb')"
cmd_exists fd ||
    yes_install "$(download_latest_github_tag 'sharkdp/fd' 'fd_@VERSION@_amd64.deb')"
cmd_exists viv ||
    tar xf "$(download_latest_github_tag 'jannis-baum/Vivify' 'vivify-linux.tar.gz')" \
        --directory ~/.local/bin --strip-components=1

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
    tar xf "$(download_latest_github_tag 'jesseduffield/lazygit' 'lazygit_@VERSION@_Linux_x86_64.tar.gz')" \
        --directory="$SETUP_DIR" lazygit
    install "$SETUP_DIR/lazygit" ~/.local/bin
fi

# pyenv
PYENV_ROOT="${PYENV_ROOT:-}"
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
    mv "$(download_latest_github_tag 'neovim/neovim' nvim.appimage)" "$NVIM"
    chmod u+x "$NVIM"
fi

# pipx
pip_pkgs=(ipython poetry)
for pkg in "${pip_pkgs[@]}"; do
    cmd_exists "$pkg" || pipx install "$pkg"
done

#######################################################################
# Oh My Zsh
ZSH="${ZSH:-}"
if [[ -z "$ZSH" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

install_omz_custom themes romkatv/powerlevel10k
install_omz_custom plugins zsh-users/zsh-syntax-highlighting zsh-users/zsh-autosuggestions

# dotdrop completion
if [[ ! -f "$OMZ_COMPS/_dotdrop-completion.zsh" ]]; then
    curl -Lo "$OMZ_COMPS/_dotdrop-completion.zsh" \
        https://raw.githubusercontent.com/deadc0de6/dotdrop/master/completion/_dotdrop-completion.zsh
fi

#######################################################################
# chsh (should probably be last)
SHELL="${SHELL:-}"
case "$SHELL" in
    */zsh) ;;
    *)
        echo "Changing shell to zsh..."
        chsh -s "$(which zsh)" "$USER"
        ;;
esac
