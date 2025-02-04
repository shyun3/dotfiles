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

# Reads the tag of the latest release of a GitHub repo.
#
# Ignores a possible 'v' at the start of the tag.
#
# $1: GitHub slug in the form "owner/repo".
#
# Return: Tag name, without any leading 'v'.
read_latest_github_tag() {
    # Derived from https://github.com/jesseduffield/lazygit?tab=readme-ov-file#ubuntu
    curl -s "https://api.github.com/repos/$1/releases/latest" |
        grep -Po '"tag_name": "v?\K[^"]*'
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
    local slug="${1:?}"
    local filename="${2:?}"

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
    local custom_type="${1:?}"
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

# These bin directories will only be added to PATH if they exist, see zprofile
LOCAL="$HOME/.local"
BIN_HOME="$LOCAL/bin"
mkdir -p ~/bin "$BIN_HOME"

# Neovim 'undodir'
DATA_HOME="$LOCAL/share"
mkdir -p "$DATA_HOME/nvim/undo"

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

if ! cmd_exists bat; then
    yes_install "$(download_latest_github_tag 'sharkdp/bat' 'bat_@VERSION@_amd64.deb')"
    sudo apt-mark hold bat # On Ubuntu, the executable is installed as `batcat`
fi

if ! cmd_exists fd; then
    yes_install "$(download_latest_github_tag 'sharkdp/fd' 'fd_@VERSION@_amd64.deb')"
    sudo apt-mark hold fd # On Ubuntu, the executable is installed as `fdfind`
fi

if ! cmd_exists delta; then
    yes_install "$(download_latest_github_tag 'dandavison/delta' 'git-delta_@VERSION@_amd64.deb')"
    curl --create-dirs -Lo "$DATA_HOME/delta/themes.gitconfig" \
        https://raw.githubusercontent.com/dandavison/delta/main/themes.gitconfig
fi

cmd_exists viv ||
    tar xf "$(download_latest_github_tag 'jannis-baum/Vivify' 'vivify-linux.tar.gz')" \
        --directory "$BIN_HOME" --strip-components=1

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
cmd_exists lazygit ||
    tar xf "$(download_latest_github_tag 'jesseduffield/lazygit' 'lazygit_@VERSION@_Linux_x86_64.tar.gz')" \
        --directory="$BIN_HOME" lazygit

# uv
if ! cmd_exists uv; then
    curl -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 sh

    cd ~/.config/nvim
    uv venv
    uv pip install pynvim
    cd -
fi

if cmd_exists uv; then
    pip_pkgs=(dotdrop ipython)
    for pkg in "${pip_pkgs[@]}"; do
        cmd_exists "$pkg" || uv tool install "$pkg"
    done
fi

# Neovim
cmd_exists nvim ||
    install "$(download_latest_github_tag 'neovim/neovim' nvim-linux-x86_64.appimage)" \
        "$BIN_HOME/nvim"

#######################################################################
# Oh My Zsh
ZSH="${ZSH:-}"
if [[ -z "$ZSH" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

install_omz_custom themes romkatv/powerlevel10k
install_omz_custom plugins zsh-users/zsh-syntax-highlighting zsh-users/zsh-autosuggestions

OMZ_COMPS="$HOME/.oh-my-zsh/completions"
mkdir -p "$OMZ_COMPS"

# dotdrop completion
if [[ ! -f "$OMZ_COMPS/_dotdrop-completion.zsh" ]]; then
    curl -Lo "$OMZ_COMPS/_dotdrop-completion.zsh" \
        https://raw.githubusercontent.com/deadc0de6/dotdrop/master/completion/_dotdrop-completion.zsh
fi

# delta completion
if [[ ! -f "$OMZ_COMPS/_delta-completion.zsh" ]]; then
    delta --generate-completion zsh > "$OMZ_COMPS/_delta-completion.zsh"
fi

# meson completion
if [[ ! -f "$OMZ_COMPS/_meson-completion.zsh" ]]; then
    curl -Lo "$OMZ_COMPS/_meson-completion.zsh" \
        https://raw.githubusercontent.com/mesonbuild/meson/refs/heads/master/data/shell-completions/zsh/_meson
fi

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
