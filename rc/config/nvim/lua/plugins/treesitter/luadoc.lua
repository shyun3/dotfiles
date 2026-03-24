return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      ensure_installed = { luadoc = false },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        luadoc = {
          ["@keyword.luadoc"] = { link = "my_dim@keyword" },
          ["@keyword.import.luadoc"] = { link = "my_dim@keyword.import" },
          ["@keyword.coroutine.luadoc"] = { link = "my_dim@keyword.coroutine" },
          ["@keyword.function.luadoc"] = { link = "my_dim@keyword.function" },
          ["@constant.builtin.luadoc"] = { link = "my_dim@constant.builtin" },
          ["@keyword.return.luadoc"] = { link = "my_dim@keyword.return" },
          ["@keyword.modifier.luadoc"] = { link = "my_dim@keyword.modifier" },
          ["@variable.luadoc"] = { link = "my_dim@variable" },
          ["@variable.builtin.luadoc"] = { link = "my_dim@variable.builtin" },
          ["@function.macro.luadoc"] = { link = "my_dim@function.macro" },
          ["@variable.parameter.luadoc"] = {
            link = "my_dim@variable.parameter",
          },
          ["@variable.member.luadoc"] = { link = "my_dim@variable.member" },
          ["@type.builtin.luadoc"] = { link = "my_dim@type.builtin" },
          ["@type.luadoc"] = { link = "my_dim@type" },
          ["@operator.luadoc"] = { link = "my_dim@operator" },
          ["@module.luadoc"] = { link = "my_dim@module" },
          ["@string.luadoc"] = { link = "my_dim@string" },
          ["@number.luadoc"] = { link = "my_dim@number" },
        },
      },
    },
  },
}
