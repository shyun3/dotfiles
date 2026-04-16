return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      _my_parsers = { zsh = true },
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
