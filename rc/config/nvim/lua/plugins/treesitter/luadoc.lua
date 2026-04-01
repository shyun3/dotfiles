return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      _my_parsers = { luadoc = false },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        luadoc = {
          ["@keyword.luadoc"] = { link = "my_dim_@keyword" },
          ["@keyword.import.luadoc"] = { link = "my_dim_@keyword.import" },
          ["@keyword.coroutine.luadoc"] = { link = "my_dim_@keyword.coroutine" },
          ["@keyword.function.luadoc"] = { link = "my_dim_@keyword.function" },
          ["@constant.builtin.luadoc"] = { link = "my_dim_@constant.builtin" },
          ["@keyword.return.luadoc"] = { link = "my_dim_@keyword.return" },
          ["@keyword.modifier.luadoc"] = { link = "my_dim_@keyword.modifier" },
          ["@variable.luadoc"] = { link = "my_dim_@variable" },
          ["@variable.builtin.luadoc"] = { link = "my_dim_@variable.builtin" },
          ["@function.macro.luadoc"] = { link = "my_dim_@function.macro" },
          ["@variable.parameter.luadoc"] = {
            link = "my_dim_@variable.parameter",
          },
          ["@variable.member.luadoc"] = { link = "my_dim_@variable.member" },
          ["@type.builtin.luadoc"] = { link = "my_dim_@type.builtin" },
          ["@type.luadoc"] = { link = "my_dim_@type" },
          ["@operator.luadoc"] = { link = "my_dim_@operator" },
          ["@module.luadoc"] = { link = "my_dim_@module" },
          ["@string.luadoc"] = { link = "my_dim_@string" },
          ["@number.luadoc"] = { link = "my_dim_@number" },
        },
      },
    },
  },
}
