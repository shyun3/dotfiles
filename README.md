# Installation

The following instructions assume the use of Ubuntu Linux unless otherwise
specified.

## .bashrc

Add the following line at the end of `.bashrc`:
```bash
source /path/to/bashrc-common.sh
```

## `ctags` global option file

Symlink the [Universal Ctags][univ-ctags] global option file:
```bash
ln -s /path/to/global.ctags ~/.ctags.d/global.ctags
```

## `black` global configuration file

Symlink the [black][] global configuration file:
```bash
ln -s /path/to/black.toml ${XDG_CONFIG_HOME:-~/.config}/black
```

## `fd` global ignore file

Symlink the [fd][] global ignore file (supported in v8.1 or later):
```bash
ln -s /path/to/fdignore_global ~/.config/fd/ignore
```

## .gitconfig

Update the global include path:
```bash
git config --global include.path "/path/to/gitconfig-common"
```

Symlink the global ignore file:
```bash
ln -s /path/to/gitignore_global ~/.gitignore_global
```

When using PowerShell and referencing WSL paths, the equivalent commands may
look like:
```powershell
git config --global include.path "\\wsl`$\path\to\gitconfig-common"

New-Item -Type SymbolicLink -Path "$Env:UserProfile\.gitignore_global" `
    -Target "\\wsl`$\path\to\gitignore_global"
```
PowerShell must be run as administrator to create symbolic links.

## .inputrc

Symlink the `readline` initialization file:
```bash
ln -s /path/to/inputrc ~/.inputrc
```

## profile.ps1

Add the following line at the end of the user PowerShell 7 profile located at
`$home\Documents\PowerShell\profile.ps1`:
```powershell
. "\path\to\profile-common.ps1"
```

Make sure that PowerShell's execution policy is not set to `Restricted`.

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
    -Target "\\wsl`$\LinuxDistro\path\to\winterm-settings.json"
```

## wsl.conf

Symlink the [WSL config file][wsl-conf]:
```bash
sudo ln -s /path/to/wsl.conf /etc/wsl.conf
```

# Setup

Update Git config:
```
git config --global user.name "username"
git config --global user.email "user@mail.com"

# Linux
git config --global core.autocrlf input

# Windows
git config --global core.autocrlf true
```

[black]: https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#where-black-looks-for-the-file
[fd]: https://github.com/sharkdp/fd
[univ-ctags]: https://docs.ctags.io/en/latest/option-file.html#order-of-loading-option-files
[wsl-conf]: https://docs.microsoft.com/en-us/windows/wsl/wsl-config#per-distribution-configuration-options-with-wslconf
