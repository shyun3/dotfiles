# Installation

The following instructions assume the use of Ubuntu Linux unless otherwise
specified.

## .bashrc

Install [Oh My Posh](https://ohmyposh.dev/docs/installation/linux). This will
require [Homebrew](https://brew.sh/).

Add the following lines at the end of `.bashrc`:
```bash
DOTFILES=/path/to/dotfiles/
source $DOTFILES/bashrc-common.sh
```

## `ctags` global option file

Symlink the [Universal Ctags][univ-ctags] global option file:
```bash
ln -s $DOTFILES/global.ctags ~/.ctags.d/global.ctags
```

## `fd` global ignore file

Symlink the [fd][] global ignore file (supported in v8.1 or later):
```bash
ln -s $DOTFILES/fdignore_global ~/.config/fd/ignore
```

## .gitconfig

Update the global include path:
```bash
git config --global include.path "/path/to/gitconfig-common"
```

Symlink the global ignore file:
```bash
ln -s $DOTFILES/gitignore_global ~/.gitignore_global
```

When using PowerShell and referencing WSL paths, the equivalent commands may
look like:
```powershell
git config --global include.path "\\wsl`$\LinuxDistro\path\to\gitconfig-common"

New-Item -Type SymbolicLink -Path "$Env:UserProfile\.gitignore_global" `
    -Target "\\wsl`$\LinuxDistro\path\to\gitignore_global"
```
PowerShell must be run as administrator to create symbolic links.

## .inputrc

Symlink the `readline` initialization file:
```bash
ln -s $DOTFILES/inputrc ~/.inputrc
```

## PowerShell user profile

Make sure that PowerShell's execution policy is not set to `Restricted`.

Install [Oh My Posh](https://ohmyposh.dev/docs/installation/windows).

Install the following prerequisites through PowerShell 7:
```powershell
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module posh-git -Scope CurrentUser -Force
```

Add the following lines at the end of the user PowerShell profile located at
`$PROFILE`:
```powershell
$DOTFILES = "\\wsl`$\LinuxDistro\path\to\dotfiles\"
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
```bash
sudo ln -s /home/<user> /home/default
```

## wsl.conf

Symlink the [WSL config file][wsl-conf]:
```bash
sudo ln -s $DOTFILES/wsl.conf /etc/wsl.conf
```

# Setup

Update Git config:
```
git config --global user.name "username"
git config --global user.email "user@mail.com"

# Linux
git config --global core.autocrlf input

# Windows
git config --global core.autocrlf input
```

# Tips

## Windows Terminal

* To specify machine-specific profiles, use JSON fragment extensions. For more
  info and examples, see the [examples](examples/) directory.
* To regenerate dynamic profiles that have been deleted, remove
  `$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\state.json`

[fd]: https://github.com/sharkdp/fd
[univ-ctags]: https://docs.ctags.io/en/latest/option-file.html#order-of-loading-option-files
[wsl-conf]: https://docs.microsoft.com/en-us/windows/wsl/wsl-config#per-distribution-configuration-options-with-wslconf
