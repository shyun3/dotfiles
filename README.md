# Installation

## .bashrc

Add the following line at the end of `.bashrc`:
```bash
source /path/to/bashrc-common.sh
```

Note that this common script was written assuming that Ubuntu Linux was being
used.

## compile_flags.txt

Copy script to C/C++ project root and customize. For use with `clangd`.

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

## projects.vim

Copy script to Neovim config directory and customize:
```bash
cp /path/to/projects.vim ~/.config/nvim
```
