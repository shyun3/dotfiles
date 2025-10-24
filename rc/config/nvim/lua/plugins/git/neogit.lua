return {
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "NeogitOrg/neogit",

    config = true,

    cmd = "Neogit",

    keys = {
      { "<Leader>gl", "<Cmd>NeogitLog<CR>", desc = "Git: Log" },
    },
  },
}
