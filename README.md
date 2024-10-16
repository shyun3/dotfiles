# Installation

These dotfiles are deployed using [dotdrop](https://dotdrop.readthedocs.io/en/latest/).

# Windows

Install [Scoop](https://scoop.sh/) by running the following in PowerShell:
```pwsh
Set-ExecutionPolicy -Scope CurrentUser Bypass
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
This will also install Git.

Clone the repo:
```pwsh
git clone https://github.com/shyun3/dotfiles.git $Env:UserProfile/.config/dotdrop
```

Run `bootstrap.ps1`. This will install `dotdrop` and all dependencies.

To deploy the dotfiles, call `dotdrop`:
```pwsh
dotdrop -p windows install
```

# Ubuntu

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

## `lazygit` config file

Symlink the [lazygit](https://github.com/jesseduffield/lazygit) config file:
```zsh
ln -sf /path/to/dotfiles/lazygit-config.yml ~/.config/lazygit/config.yml
```

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

Add `.local_vars.yaml` under the repo root with the Git user details defined:
```yaml
variables:
  git_name: My Name
  git_email: name@email.tld
```
Run `dotdrop` install again to regenerate the gitconfig with the user details.

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
