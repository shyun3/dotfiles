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

Install `dotdrop`:
```sh
sudo apt update
sudo apt install dotdrop
```

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

If using WSL, apply the following first:
```sh
sudo env HOME="$HOME" "$(which dotdrop)" -p wsl-root install
```
WSL needs restarting to apply all changes. A distribution can be shutdown in
PowerShell by running `wsl --terminate <distroName>`.

For all Linux distributions:
```sh
dotdrop -p linux install
```
Zsh may need restarting to apply all changes.

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

### Neovim

* Run `:checkhealth` to see if there are issues that need resolving
* See `$VIMRUNTIME` to access Neovim source files
* To activate Gutentags operation, create an appropriate `.gutctags` file, then
  reload the buffer being edited with `:e` (to trigger the `BufReadPost` event,
  see [code][gutentags-detect]). Finally, run `:GutentagsUpdate!`.
* To activate projectionist functionality, create an appropriate
  `.projections.json` file, then run `:filetype detect` on the buffer of
  interest (to trigger the `FileType` event, see [code][projectionist-detect]).

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

* Place machine-specific settings in `~/.zshenv`, e.g.:
    * `$path=(/path/to/dir $path)`
    * SSH identities, see [Oh My Zsh plugin][omz-ssh-agent]

[gutentags-detect]: https://github.com/ludovicchabant/vim-gutentags/blob/aa47c5e29c37c52176c44e61c780032dfacef3dd/plugin/gutentags.vim#L100
[omz-ssh-agent]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh-agent#identities
[projectionist-detect]: https://github.com/tpope/vim-projectionist/blob/5ff7bf79a6ef741036d2038a226bcb5f8b1cd296/plugin/projectionist.vim#L139-L144
[wsl-interop-comment]: https://github.com/microsoft/WSL/issues/8843#issuecomment-1624028222
