# Examples

This directory contains examples and templates for various configuration files.
Using these typically involves copying the files to a project, possibly
renaming them, and customizing their contents as needed.

| Example name | Destination name | Destination folder | Use with |
| ------------ | ---------------- | ------------------ | -------- |
| *_clang-format* | *.clang-format* | Project | `clang-format`
| *_clangd* | *.clangd* | Project | `clangd` |
| *_gutctags* | *.gutctags* | Project | **vim-gutentags** |
| *_projections.json* | *.projections.json* | Project | **vim-projectionist** |
| *03-scope-configs.toml* | Same | *~/.config/jj/conf.d* | `jj`
| *compile_flags.txt* | Same | Project | `clangd` |
| *projects.vim* | Same | *~/.config/nvim* | **vim-project** |
| *pyrightconfig.json* | Same | Project | `pyright` |
| *ssh-config* | *config* | *~/.ssh* | `ssh-add` |

Additional notes:
* *.gutctags*: See `g:gutentags_project_root`
* *03-scope-configs.toml*: Files in directory are loaded in lexicographic
  order, see [docs][jj-config]
* *projects.vim*: See **vim-project** Neovim config
* *pyrightconfig.json*: `pyright` can read type stubs placed in the `typings`
  directory. See also the `stubPath` option and [Generating Type
  Stubs][type-stubs].

## Windows Terminal JSON fragment extensions

Windows Terminal allows profiles to be added or modified outside of the main
settings file through [JSON fragment extensions][winterm-json-fragment]. Some
examples of these extensions are available here, with their names ending
`-fragment.json`. These files must be placed in the [proper
directories][winterm-json-fragment-loc].

Summarizing from the docs, extensions for the current user would be added as:

`$Env:LocalAppData/Microsoft/Windows Terminal/Fragments/{app-name}/{file-name}.json`

The `{app-name}` must match the corresponding `source` field of the profile in
the main Windows Terminal `settings.json`.

For this case, the MSYS2 fragment would be added as:

`$Env:LocalAppData/Microsoft/Windows Terminal/Fragments/MinGW/MSYS2.json`

Recall from the docs that the actual file name of the JSON does not matter.

See also the [Dynamic profiles][winterm-dyn-profiles] page for additional
examples of JSON contents.

[jj-config]: https://jj-vcs.github.io/jj/latest/config/#ways-to-specify-jj-config-details
[type-stubs]: https://github.com/microsoft/pyright/blob/main/docs/type-stubs.md#generating-type-stubs
[winterm-dyn-profiles]: https://docs.microsoft.com/en-us/windows/terminal/dynamic-profiles
[winterm-json-fragment-loc]: https://docs.microsoft.com/en-us/windows/terminal/json-fragment-extensions#applications-installed-from-the-web
[winterm-json-fragment]: https://docs.microsoft.com/en-us/windows/terminal/json-fragment-extensions
