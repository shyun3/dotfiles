# Installation

The following instructions assume the use of Ubuntu Linux unless otherwise
specified.

## .bashrc

Add the following line at the end of `.bashrc`:
```bash
source /path/to/bashrc-common.sh
```

## .clangd

Copy script to C/C++ project root and customize:
```bash
cp /path/to/clangd-config /path/to/project/.clangd
```

For use with [clangd][] (v11 or later).

## compile\_flags.txt

Copy script to C/C++ project root and customize. For use with [clangd][].

## \*/fd/ignore

Symlink the global [fd][] ignore file (supported in v8.1 or later):
```bash
ln -sf /path/to/fdignore_global ~/.config/fd/ignore
```

## .gitconfig

Update the global include path:
```bash
git config --global include.path "/path/to/gitconfig-common"
```

Symlink the global ignore file:
```bash
ln -sf /path/to/gitignore_global ~/.gitignore_global
```

When using PowerShell and referencing WSL paths, the equivalent commands may
look like:
```powershell
git config --global include.path "\\wsl`$\path\to\gitconfig-common"

New-Item -Type SymbolicLink -Path "$Env:UserProfile\.gitignore_global" `
    -Target "\\wsl`$\path\to\gitignore_global"
```
PowerShell must be run as administrator to create symbolic links.

## .projections.json

Copy script to project root and customize. For use with [vim-projectionist][]:
```bash
cp /path/to/projections.json /path/to/project/.projections.json
```

## projects.vim

Copy script to Neovim config directory and customize:
```bash
cp /path/to/projects.vim ~/.config/nvim
```

## settings.json

First, make sure Windows Terminal is not running. Then, remove existing
settings using PowerShell as administrator:
```powershell
rm $Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\*
```

Symlink the settings file:
```powershell
New-Item -Type SymbolicLink `
    -Path $Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json `
    -Target "\\wsl`$\path\to\winterm-settings.json"
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

[clangd]: https://clangd.llvm.org/
[fd]: https://github.com/sharkdp/fd
[vim-projectionist]: https://github.com/tpope/vim-projectionist
