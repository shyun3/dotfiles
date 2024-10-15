# Installation

The following instructions assume the use of Ubuntu Linux unless otherwise
specified.

First, run `setup.sh` to install the prerequisites.

## .zshrc

Make some symlinks, overwriting the created `.zshrc`:
```zsh
ln -sf /path/to/dotfiles/zprofile ~/.zprofile
ln -sf /path/to/dotfiles/zshrc ~/.zshrc
ln -s /path/to/dotfiles/p10k.zsh ~/.p10k.zsh
```

## `ctags` global option file

Symlink the [Universal Ctags][univ-ctags] global option file:
```zsh
ln -s /path/to/dotfiles/global.ctags ~/.ctags.d/global.ctags
```

## `fd` global ignore file

Symlink the [fd][] global ignore file (supported in v8.1 or later):
```zsh
ln -s /path/to/dotfiles/fdignore_global ~/.config/fd/ignore
```

## .gitconfig

Update the global include path:
```zsh
git config --global include.path "/path/to/gitconfig-common"
```

Symlink the global ignore file:
```zsh
ln -s /path/to/dotfiles/gitignore_global ~/.gitignore_global
```

When using PowerShell and referencing WSL paths, the equivalent commands may
look like:
```powershell
git config --global include.path "\\wsl.localhost\LinuxDistro\path\to\gitconfig-common"
```

## `lazygit` config file

Symlink the [lazygit](https://github.com/jesseduffield/lazygit) config file:
```zsh
ln -sf /path/to/dotfiles/lazygit-config.yml ~/.config/lazygit/config.yml
```

## PowerShell user profile

Make sure that PowerShell's execution policy is not set to `Restricted`. For
example:
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass
```

Install [Oh My Posh](https://ohmyposh.dev/docs/installation/windows).

Install the following prerequisites through PowerShell 7:
```powershell
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module posh-git -Scope CurrentUser -Force
```

Add the following lines at the end of the user PowerShell profile located at
`$PROFILE`:
```powershell
$DOTFILES = "\\wsl.localhost\LinuxDistro\path\to\dotfiles\"
. "$DOTFILES\profile-common.ps1"
```

Changes may require restarting Windows Terminal to take effect.

## `ranger`

Symlink the [ranger](https://ranger.github.io/index.html) directory:
```sh
ln -s /path/to/dotfiles/ranger ~/.config
```

## Windows Terminal settings

After starting WSL, symlink the `default` home directory:
```zsh
sudo ln -s /home/<user> /home/default
```

## wsl.conf

Symlink the [WSL config file][wsl-conf]:
```zsh
sudo ln -s /path/to/dotfiles/wsl.conf /etc/wsl.conf
```

# Suggestions

Update Git config:
```
git config --global user.name "username"
git config --global user.email "user@mail.com"
```

Install the [Python build dependencies][python-build-deps]. Prefer the latest
Python and set it as the global version:
```zsh
pyenv install 3
pyenv global 3
```

# Tips

## Windows Terminal

* To specify machine-specific profiles, use JSON fragment extensions. For more
  info and examples, see the [examples](examples/) directory.
* To regenerate dynamic profiles that have been deleted, remove
  `$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\state.json`

## WSL

* If Windows applications cannot be called from WSL, try entering the
  following:
  ```sh
  sudo systemctl mask systemd-binfmt.service
  ```
  Taken from this [comment][wsl-interop-comment]. More details can be found in
  issue [#8843](https://github.com/microsoft/WSL/issues/8843).

## Zsh

* Place machine-specific settings in `~/.zshenv`

[fd]: https://github.com/sharkdp/fd
[python-build-deps]: https://github.com/pyenv/pyenv?tab=readme-ov-file#install-python-build-dependencies
[univ-ctags]: https://docs.ctags.io/en/latest/option-file.html#order-of-loading-option-files
[wsl-conf]: https://docs.microsoft.com/en-us/windows/wsl/wsl-config#per-distribution-configuration-options-with-wslconf
[wsl-interop-comment]: https://github.com/microsoft/WSL/issues/8843#issuecomment-1624028222
