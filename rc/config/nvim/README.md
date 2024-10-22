# Neovim configs

Last used with Neovim v0.10.2 on WSL Ubuntu.

## Example configuration files

See the corresponding [README](example-configs/readme.md).

## Tips

### clangd

* The [example clangd config](example-configs/clangd-config) contains hints for
  cross-compiling and resolving system header issues. The `clangd` [system
  headers](https://clangd.llvm.org/guides/system-headers) documentation is also
  helpful.
* When specifying paths with embedded spaces in `compile_flags.txt`, do not
  introduce quotes or backslashes to escape as this will be handled by
  `clangd`. For example:
  ```
  -Ipath with spaces
  ```

### Python

* Formatter options may be specified through a project top-level
  `pyproject.toml`, for example:
    ```
    [tool.black]
    unstable = true

    [tool.isort]
    profile = "black"
    ```
  Using the unstable option for black may be useful to have it break long
  strings, see the [future style docs][black-future]. `isort` can also be
  configured for `black` compatibility by specifying the profile (see
  [docs][isort-black]).
* [Pyright](https://github.com/microsoft/pyright) can read type stubs placed in
  the `typings` directory. This can be customized using the `stubPath` option
  in the `pyrightconfig.json`. See also [Generating Type Stubs][type-stubs].

### UltiSnips

* Add snippets under the `UltiSnips/specific` directory for snippets that are
  meant to be machine-specific and not saved in the repo, see the UltiSnips
  plugin setup.

[nvim-config-dir]: https://neovim.io/doc/user/starting.html#config
[type-stubs]: https://github.com/microsoft/pyright/blob/main/docs/type-stubs.md#generating-type-stubs
[black-future]: https://black.readthedocs.io/en/stable/the_black_code_style/future_style.html
[isort-black]: https://pycqa.github.io/isort/docs/configuration/black_compatibility.html
