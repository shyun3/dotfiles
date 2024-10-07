# Installation

The following instructions assume the use of Ubuntu Linux unless otherwise
specified.

## .zshrc

Install `zsh`: `apt install zsh`.

Install [Oh My Zsh](https://ohmyz.sh/).

Make some symlinks, overwriting the created `.zshrc`:
```zsh
ln -sf /path/to/dotfiles/zshrc ~/.zshrc
ln -s /path/to/dotfiles/p10k.zsh ~/.p10k.zsh
```

Install [Powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#oh-my-zsh).

### Plugin Notes

If using Ubuntu 22.04, consider installing `fzf` through `apt`. If installing
through Git, there is no need to run the `install` script as this is covered by
the plugin.

Prefer the automatic installer for [pyenv][]. This will also install
`pyenv-virtualenv`. Make sure to install the [Python build
dependencies][python-build-deps]. Prefer the latest Python and set it as the
global version:
```zsh
pyenv install 3
pyenv global 3
```

When installing [nvm][], make sure not to update the shell config (see
[additional notes][nvm-install-notes]):
```zsh
# Fill in the version
PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/<VERSION>/install.sh | bash'
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

New-Item -Type SymbolicLink -Path "$Env:UserProfile\.gitignore_global" `
    -Target "\\wsl.localhost\LinuxDistro\path\to\gitignore_global"
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

## Windows Terminal settings

First, make sure Windows Terminal is not running. Then, remove existing
settings using PowerShell:
```powershell
rm $Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\*
```

Now, symlink the settings file:
```powershell
New-Item -Type SymbolicLink `
    -Path $Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json `
    -Target "$DOTFILES\winterm-settings.json"
```

After starting WSL, symlink the `default` home directory:
```zsh
sudo ln -s /home/<user> /home/default
```

## wsl.conf

Symlink the [WSL config file][wsl-conf]:
```zsh
sudo ln -s /path/to/dotfiles/wsl.conf /etc/wsl.conf
```

# Setup

Update Git config:
```
git config --global user.name "username"
git config --global user.email "user@mail.com"
```

Make sure `zsh` sources `/etc/profile` by adding the following line to
`/etc/zsh/zprofile`:
```zsh
emulate sh -c 'source /etc/profile'
```
Taken from this [bug report][zsh-profile-bug].

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
* The directories `$HOME/bin` and `$HOME/.local/bin` are only added to the
  `PATH` if they exist

[fd]: https://github.com/sharkdp/fd
[pyenv]: https://github.com/pyenv/pyenv?tab=readme-ov-file#automatic-installer
[python-build-deps]: https://github.com/pyenv/pyenv?tab=readme-ov-file#install-python-build-dependencies
[nvm]: https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script
[nvm-install-notes]: https://github.com/nvm-sh/nvm?tab=readme-ov-file#additional-notes
[univ-ctags]: https://docs.ctags.io/en/latest/option-file.html#order-of-loading-option-files
[wsl-conf]: https://docs.microsoft.com/en-us/windows/wsl/wsl-config#per-distribution-configuration-options-with-wslconf
[wsl-interop-comment]: https://github.com/microsoft/WSL/issues/8843#issuecomment-1624028222
[zsh-profile-bug]: https://bugs.launchpad.net/ubuntu/+source/zsh/+bug/1800280
