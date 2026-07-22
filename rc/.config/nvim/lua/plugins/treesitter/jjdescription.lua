return {
  {
    LazyDep("nvim-treesitter"),
    optional = true,

    opts = {
      _my_parsers = { jjdescription = true },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        jjdescription = require("util.hl").make_dim_ts_hls("jjdescription", {
          "@constant", -- Change ID
          "@diff.plus", -- A
          "@diff.minus", -- D
          "@diff.delta", -- M
          "@string.special.path", -- Changed file
          "@keyword.directive", -- JJ: ignore-rest
        }),
      },
    },
  },
}
