return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      _my_parsers = { doxygen = false },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        doxygen = {
          ["@keyword.doxygen"] = { link = "my_dim_@keyword" },
          ["@variable.parameter.doxygen"] = {
            link = "my_dim_@variable.parameter",
          },
          ["@tag.doxygen"] = { link = "my_dim_@tag" },
          ["@markup.italic.doxygen"] = { link = "my_dim_@markup.italic" },
          ["@function.doxygen"] = { link = "my_dim_@function" },
          ["@label.doxygen"] = { link = "my_dim_@label" },
          ["@keyword.modifier.doxygen"] = { link = "my_dim_@keyword.modifier" },
          ["@operator.doxygen"] = { link = "my_dim_@operator" },
        },
      },
    },
  },
}
