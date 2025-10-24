return {
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "NeogitOrg/neogit",

    opts = {
      -- Currently, this plugin is only being used for log
      filewatcher = { enabled = false },
      auto_refresh = false,

      kind = "floating",
      log_view = { kind = "split_below_all" },
    },

    cmd = "Neogit",

    keys = {
      { "<Leader>gl", "<Cmd>NeogitLog<CR>", desc = "Git: Log" },
    },
  },
}
