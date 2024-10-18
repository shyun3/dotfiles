# dotfiles

These dotfiles are deployed using [dotdrop](https://dotdrop.readthedocs.io/en/latest/).

## Prerequisites

The following instructions assume a first-time setup is being performed.

### Windows

First, install PowerShell 7 using `cmd` or `powershell`:
```pwsh
winget install --id Microsoft.PowerShell --source winget
```

Launch PowerShell 7 and install [Scoop](https://scoop.sh/):
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

### WSL

Assuming the Windows steps above were completed, install WSL using `pwsh` in
**administrator** mode:
```pwsh
wsl --install
```

### Ubuntu

Install `dotdrop`:
```sh
sudo apt install dotdrop
```

Clone the repo:
```sh
git clone git@github.com:shyun3/dotfiles.git ~/.config/dotdrop
```

Run `setup.sh` to install the prerequisites.

## Installation

To install or update the dotfiles, call `dotdrop` as listed below. A shell
restart may be needed to apply the latest changes.

### Windows

```pwsh
dotdrop -p windows install
```

### Linux

```sh
dotdrop -p linux install
```

If using WSL, apply the following as well:
```sh
sudo dotdrop -p wsl-root -c ~/.config/dotdrop/config.yaml install
```

## Suggestions

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

## Tips

### Windows Terminal

* To specify machine-specific profiles, use JSON fragment extensions. For more
  info and examples, see the [examples](examples/) directory.
* To regenerate dynamic profiles that have been deleted, remove
  `$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\state.json`

### WSL

* If Windows applications cannot be called from WSL, try entering the
  following:
  ```sh
  sudo systemctl mask systemd-binfmt.service
  ```
  Taken from this [comment][wsl-interop-comment]. More details can be found in
  issue [#8843](https://github.com/microsoft/WSL/issues/8843).

### Zsh

* Place machine-specific settings in `~/.zshenv`

[python-build-deps]: https://github.com/pyenv/pyenv?tab=readme-ov-file#install-python-build-dependencies
[wsl-interop-comment]: https://github.com/microsoft/WSL/issues/8843#issuecomment-1624028222
