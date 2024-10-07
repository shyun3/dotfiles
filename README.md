# Installation

## .bashrc

Add the following line at the end of `.bashrc`:
```bash
source /path/to/bashrc-common.sh
```

Note that this common script was written assuming that Ubuntu Linux was being
used.

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
