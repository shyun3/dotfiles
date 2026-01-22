return {
  LazyDep("ibl"),
  event = "VeryLazy",

  main = "ibl",

  opts_extend = { "exclude.filetypes" },

  opts = {
    indent = {
      char = "│", -- center aligned solid
    },

    whitespace = { remove_blankline_trail = false },

    scope = {
      show_start = false,
      show_end = false,
    },
  },
}
