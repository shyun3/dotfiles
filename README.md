# Installation

The following instructions assume the use of Ubuntu Linux.

## .bashrc

Add the following line at the end of `.bashrc`:
```bash
source /path/to/bashrc-common.sh
```

## compile_flags.txt

Copy script to C/C++ project root and customize. For use with `clangd`.

## \*/fd/ignore

Symlink the global `fd` ignore file:
```bash
ln -sf /path/to/fdignore_global ~/.config/fd/ignore
```

## .gitconfig

Add the following line at the end of `.gitconfig`:
```gitconfig
[include]
	path = /path/to/gitconfig-common
```

Symlink the global ignore file:
```bash
ln -sf /path/to/gitignore_global ~/.gitignore_global
```

## .projections.json

Copy script to project root and customize. For use with `vim-projectionist`:
```bash
cp /path/to/projections.json /path/to/project/.projections.json
```

## projects.vim

Copy script to Neovim config directory and customize:
```bash
cp /path/to/projects.vim ~/.config/nvim
```
