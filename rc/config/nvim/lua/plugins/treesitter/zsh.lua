return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      _my_parsers = {
        -- Treesitter indentexpr doesn't indent when entering a block
        zsh = false,
      },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        zsh = {
          ["@variable.parameter.zsh"] = { link = "@string" },
        },
      },
    },
  },
}
