return {
  {
    require("lazy-deps").which_key,
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
    "kylechui/nvim-surround",
    event = "VeryLazy", -- To allow which-key to load mapping descriptions

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
      { "ss", "cl", desc = "Delete character and enter insert" },
    },
  },
}
