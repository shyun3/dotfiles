# Installation

The following instructions assume the use of Ubuntu Linux unless otherwise
specified.

## .bashrc

Add the following line at the end of `.bashrc`:
```bash
source /path/to/bashrc-common.sh
```

## .clangd

Copy script to C/C++ project root and customize. For use with [clangd][].

## compile\_flags.txt

Copy script to C/C++ project root and customize. For use with [clangd][].

## \*/fd/ignore

Symlink the global `fd` ignore file:
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
git config --global include.path "\\wsl`$\Ubuntu\path\to\gitconfig-common"

New-Item -Type SymbolicLink -Path "C:\path\to\USERPROFILE\.gitignore_global"
    -Target "\\wsl`$\Ubuntu\path\to\gitignore_global"
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

[clangd]: https://clangd.llvm.org/
[vim-projectionist]: https://github.com/tpope/vim-projectionist
