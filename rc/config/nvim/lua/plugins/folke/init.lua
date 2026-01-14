return {
  {
    ---@module 'snacks'
    "folke/snacks.nvim",

    opts = {
      lazygit = {
        win = {
          style = "lazygit",

          -- Disable <Esc> twice quickly to enter normal mode
          -- Derived from https://github.com/folke/snacks.nvim/issues/280#issuecomment-2987923844
          keys = { term_normal = false },
        },
      },
    },

    keys = {
      {
        "<Leader>lg",
        function() Snacks.lazygit() end,
        desc = "Open lazygit",
      },
      {
        "<Leader>lf",
        function() Snacks.lazygit.log_file() end,
        desc = "lazygit: Open log of current file",
      },
    },
  },

  { import = "plugins.folke.lazydev" },
  { import = "plugins.folke.noice" },
  { import = "plugins.folke.which-key" },
}
