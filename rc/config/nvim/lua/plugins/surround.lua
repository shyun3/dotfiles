return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = {
      spec = {
        { "s", desc = "Surround" },
        { "<C-g>", mode = "i", desc = "Surround" },
      },

      triggers = {
        { "s" }, -- Built-in maps are never triggered, so add manually
      },
    },
  },

  {
    LazyDep("nvim-surround"),

    opts = {
      keymaps = {
        normal = "sy",
        normal_cur = "syy",
        normal_line = "sY",
        normal_cur_line = "sYY",

        delete = "sd",

        change = "sc",
        change_line = "sC",
      },

      aliases = {
        a = false,
        b = { ")", "}", "]" },
        B = false,
        r = false,
        s = false,
      },
    },

    keys = {
      { "s" },
      { "<C-g>", mode = "i" },

      { "ss", "cl", desc = "Delete character and enter insert" },
    },
  },
}
