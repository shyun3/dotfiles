# Dotfiles

This project uses [dotdrop](https://dotdrop.readthedocs.io/en/latest/).

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

Run `bootstrap.ps1`. This will install `dotdrop` and all dependencies. Restart
PowerShell to apply any changes to `PATH`.

### WSL

Assuming the Windows steps above were completed, install WSL using `pwsh` in
**administrator** mode:
```pwsh
wsl --install
```

### Ubuntu

Launch Bash and run `bootstrap.sh`. This will install `dotdrop` and all
dependencies. Restart the shell to apply any changes to `PATH`.

Clone the repo:
```sh
git clone git@github.com:shyun3/dotfiles.git ~/.config/dotdrop
```

## Installation

To install or update the dotfiles, call `dotdrop` as listed below.

### Windows

```pwsh
dotdrop -p windows install
```
PowerShell may need restarting to apply all changes.

### Linux

```sh
dotdrop -p linux install
```
Zsh may need restarting to apply all changes.

If using WSL, apply the following as well:
```sh
sudo dotdrop -p wsl-root -c ~/.config/dotdrop/config.yaml install
```
WSL needs restarting to apply all changes. Make sure to wait for at least [8
seconds][8-sec-rule] after closing all WSL shells.

## Tips

The [examples](examples) directory may also contain several tips, see its
corresponding [README](examples/README.md).

### gitconfig

Add `.local_vars.yaml` under the repo root with the global Git user details
defined:
```yaml
variables:
  git_name: My Name
  git_email: name@email.tld
```
Run `dotdrop` install to regenerate the gitconfig.

Alternatively, if per-directory user details are desired then Git profiles may
be specified. For example:
```yaml
variables:
  git_name: My Name
  git_profiles:
    - ~/projects
    - ~/personal
```

The email may be set for any repos under the listed directories by including it
in a `.gitprofile`:
```sh
git config -f ~/projects/.gitprofile user.email real@work.tld
git config -f ~/personal/.gitprofile user.email fake@priv.tld
```

### Windows Terminal

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

[8-sec-rule]: https://learn.microsoft.com/en-us/windows/wsl/wsl-config#the-8-second-rule-for-configuration-changes
[wsl-interop-comment]: https://github.com/microsoft/WSL/issues/8843#issuecomment-1624028222
