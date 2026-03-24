return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      ensure_installed = { doxygen = false },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        doxygen = {
          ["@keyword.doxygen"] = { link = "my_dim@keyword" },
          ["@variable.parameter.doxygen"] = {
            link = "my_dim@variable.parameter",
          },
          ["@tag.doxygen"] = { link = "my_dim@tag" },
          ["@markup.italic.doxygen"] = { link = "my_dim@markup.italic" },
          ["@function.doxygen"] = { link = "my_dim@function" },
          ["@label.doxygen"] = { link = "my_dim@label" },
          ["@keyword.modifier.doxygen"] = { link = "my_dim@keyword.modifier" },
          ["@operator.doxygen"] = { link = "my_dim@operator" },
        },
      },
    },
  },
}
