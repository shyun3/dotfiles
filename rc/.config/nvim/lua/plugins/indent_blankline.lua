return {
  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      integrations = {
        indent_blankline = { scope_color = "lavender" },
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",

    main = "ibl",

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
  },
}
