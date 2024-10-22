# Example configuration files

This directory contains examples and templates for configuration files that are
often used in Neovim projects. The workflow is generally to copy needed files
to a project and customize as necessary.

## .clang-format

Copy to C/C++ project root and customize:
```sh
cp ~/.config/nvim/example-configs/clang-format-config /path/to/project/.clang-format
```

For use with [clang-format](https://clang.llvm.org/docs/ClangFormat.html). See
file for compatible version.

## .clangd

Copy to C/C++ project root and customize:
```sh
cp ~/.config/nvim/example-configs/clangd-config /path/to/project/.clangd
```

For use with [clangd][] (v11 or later).

## compile\_flags.txt

Copy to C/C++ project root and customize. For use with [clangd][].

## .gutctags

Copy to C/C++ project root and customize:
```sh
cp ~/.config/nvim/example-configs/gutctags /path/to/project/.gutctags
```

For use with [Gutentags][].

## .projections.json

Copy to project root and customize. For use with [vim-projectionist][]:
```sh
cp ~/.config/nvim/example-configs/projections.json /path/to/project/.projections.json
```

## projects.vim

Copy to Neovim config directory and customize:
```sh
cp ~/.config/nvim/example-configs/projects.vim ~/.config/nvim
```

## pyrightconfig.json

Copy to Python project root and customize.

[clangd]: https://clangd.llvm.org/
[Gutentags]: https://github.com/ludovicchabant/vim-gutentags
[vim-projectionist]: https://github.com/tpope/vim-projectionist
