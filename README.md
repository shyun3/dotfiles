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

### Linux

Clone the repo:
```sh
git clone git@github.com:shyun3/dotfiles.git ~/.config/dotdrop
```

Get a temporary copy of `dotdrop`:
```sh
git clone https://github.com/deadc0de6/dotdrop.git /tmp/dotdrop

cd /tmp/dotdrop
python3 -m venv venv

source venv/bin/activate
pip install -r requirements.txt
```
The installation process will include a permanent version of `dotdrop`.

## Installation

To install or update the dotfiles, call `dotdrop` as listed below.

### Windows

```pwsh
dotdrop -p windows install
```
PowerShell may need restarting to apply all changes.

### Linux

If using WSL, apply the following first:
```sh
sudo ./dotdrop.sh -c ~/.config/dotdrop/config.yaml -p wsl-root install
```
WSL needs restarting to apply all changes. A distribution can be shutdown in
PowerShell by running `wsl --terminate <distroName>`.

For all Linux distributions:
```sh
./dotdrop.sh -c ~/.config/dotdrop/config.yaml -p linux install
deactivate
```
Zsh may need restarting to apply all changes.

## Tips

The [examples](examples) directory may also contain several tips, see its
corresponding [README](examples/README.md).

Also, the [wiki](https://github.com/shyun3/dotfiles/wiki) has a lot of useful
info.

### Jujutsu

Make sure to specify the user name and email. This can be done with scoped
configs, see [example](examples/03-scope-configs.toml). If the same user name
will be used for all repos, a separate config can be created, e.g.:
```toml
# ~/.config/jj/conf.d/02-default-config.toml

[user]
name = "My Name"
```

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

### Neovim

* Run `:checkhealth` to see if there are issues that need resolving
