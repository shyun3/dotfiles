# Dotfiles

This project uses [dotdrop](https://dotdrop.readthedocs.io/en/latest/) and
[mise](https://mise.jdx.dev/).

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

### Linux

Clone the repo:
```sh
git clone git@github.com:shyun3/dotfiles.git ~/.dotfiles
```

Install [mise](https://mise.jdx.dev/getting-started.html#installing-mise-cli):
```sh
curl https://mise.run | sh
```

Confirm that `mise` is on the `PATH`. If not, try restarting the shell.

## Installation

### Windows

```pwsh
dotdrop -p windows install
```
PowerShell may need restarting to apply all changes.

### Linux

If using WSL, apply the following first:
```sh
mise -C ~/.dotfiles -E root bootstrap
```
Make sure to trust the `mise` config, if prompted.

WSL needs restarting to apply all changes. A distribution can be shutdown in
PowerShell by running `wsl --terminate <distroName>`.

Then, install the Linux dotfiles (tested on Ubuntu):
```sh
cd ~/.dotfiles
mise trust
mise bootstrap -E linux --update
```
Zsh may need restarting to apply all changes.

## Tips

The [examples](examples) directory may also contain several tips, see its
corresponding [README](examples/README.md).

Also, the [wiki](https://github.com/shyun3/dotfiles/wiki) has a lot of useful
info.

### mise-en-place

Auto-detection of the platform environment can be enabled in
`~/.config/mise/miserc.toml`:
```toml
auto_env = true
```
See [docs](https://mise.jdx.dev/configuration/environments.html#platform-environments)
for more details.

This will simplify the call for installing dotfiles:
```sh
mise bootstrap
```

### Jujutsu

Make sure to specify the user name and email. This can be done with scoped
configs, see [example](examples/02-user.toml).

### gitconfig

Additional global Git options are read from `~/.gitconfig-local`. This can be
useful for setting user details. See [example](examples/_gitconfig-local).

### Neovim

* Run `:checkhealth` to see if there are issues that need resolving
