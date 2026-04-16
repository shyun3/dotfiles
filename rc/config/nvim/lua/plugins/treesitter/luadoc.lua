return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      _my_parsers = { luadoc = true },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        luadoc = require("util.hl").make_dim_ts_hls("luadoc", {
          "@keyword",
          "@keyword.import",
          "@keyword.coroutine",
          "@keyword.function",
          "@constant.builtin",
          "@keyword.return",
          "@keyword.modifier",
          "@variable",
          "@variable.builtin",
          "@function.macro",
          "@variable.parameter",
          "@variable.member",
          "@type.builtin",
          "@type",
          "@operator",
          "@module",
          "@string",
          "@number",
        }),
      },
    },
  },
}
