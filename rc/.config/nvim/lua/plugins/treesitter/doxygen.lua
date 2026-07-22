return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      _my_parsers = { doxygen = true },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        doxygen = require("util.hl").make_dim_ts_hls("doxygen", {
          "@keyword",
          "@variable.parameter",
          "@tag",
          "@markup.italic",
          "@function",
          "@label",
          "@keyword.modifier",
          "@operator",
        }),
      },
    },
  },
}
