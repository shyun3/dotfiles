# Dotfiles

This project uses [mise](https://mise.jdx.dev/).

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

Run `bootstrap.ps1`. This will install `mise` and all dependencies.

### WSL

Assuming the Windows steps above were completed, install WSL using `pwsh` in
**administrator** mode:
```pwsh
wsl --install
```

### Linux

Install [mise](https://mise.jdx.dev/getting-started.html#installing-mise-cli):
```sh
curl https://mise.run | sh
```

Confirm that `mise` is on the `PATH`. If not, try restarting the shell.

## Installation

### Windows

Bootstrap `mise`:
```pwsh
mise bootstrap --adopt shyun3/dotfiles --yes
```
PowerShell may need restarting to apply all changes.

### Linux

Bootstrap `mise` (tested on WSL Ubuntu):
```sh
mise bootstrap --adopt git@github.com:shyun3/dotfiles.git --yes
```
Zsh may need restarting to apply all changes.

If using WSL, make sure to restart in order to apply all changes. A
distribution can be shutdown in PowerShell by running `wsl --terminate
<distroName>`.

## Updates

Applying future changes is simpler:
```sh
mise bs
```

Remember that updates to WSL configurations require a restart of the Linux
distribution.

## Tips

The [examples](examples) directory may also contain several tips, see its
corresponding [README](examples/README.md).

Also, the [wiki](https://github.com/shyun3/dotfiles/wiki) has a lot of useful
info.

### Jujutsu

Make sure to specify the user name and email. This can be done with scoped
configs, see [example](examples/user.toml).

### gitconfig

Additional global Git options are read from `~/.gitconfig-local`. This can be
useful for setting user details. See [example](examples/_gitconfig-local).

### Neovim

* Run `:checkhealth` to see if there are issues that need resolving
