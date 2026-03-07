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

    init = function() vim.g.nvim_surround_no_normal_mappings = true end,

    opts = {
      aliases = {
        a = false,
        b = { ")", "}", "]" },
        B = false,
        r = false,
        s = false,
      },
    },

    keys = {
      {
        "sy",
        "<Plug>(nvim-surround-normal)",
        desc = "Add a surrounding pair around a motion",
      },
      {
        "syy",
        "<Plug>(nvim-surround-normal-cur)",
        desc = "Add a surrounding pair around the current line",
      },
      {
        "sY",
        "<Plug>(nvim-surround-normal-line)",
        desc = "Add a surrounding pair around a motion, on new lines",
      },
      {
        "sYY",
        "<Plug>(nvim-surround-normal-cur-line)",
        desc = "Add a surrounding pair around the current line, on new lines",
      },

      {
        "sd",
        "<Plug>(nvim-surround-delete)",
        desc = "Delete a surrounding pair",
      },

      {
        "sc",
        "<Plug>(nvim-surround-change)",
        desc = "Change a surrounding pair",
      },
      {
        "sC",
        "<Plug>(nvim-surround-change-line)",
        desc = "Change a surrounding pair, putting replacements on new lines",
      },

      { "<C-g>", mode = "i" },
      { "S", mode = "x" },
      { "gS", mode = "x" },

      { "ss", "cl", desc = "Delete character and enter insert" },
    },
  },
}
