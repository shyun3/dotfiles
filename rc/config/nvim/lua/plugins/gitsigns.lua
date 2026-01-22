return {
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
}
