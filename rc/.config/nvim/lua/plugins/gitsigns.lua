return {
  {
    LazyDep("tabby"),
    optional = true,

    opts = {
      option = {
        tab_name = {
          _my_name_fallbacks = {
            ["gitsigns-blame"] = "[Gitsigns-blame]",
          },
        },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",

    opts = {
      -- Currently, this plugin is only being used for blame
      signcolumn = false,
      watch_gitdir = { enable = false },
    },

    keys = {
      { "<Leader>gb", "<Cmd>Gitsigns blame<CR>", desc = "Git: Blame" },
    },
  },
}
