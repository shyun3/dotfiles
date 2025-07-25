return {
  {
    ---@module 'snacks'
    "folke/snacks.nvim",

    opts = {
      lazygit = {
        theme = {
          activeBorderColor = { fg = "Character", bold = true },
          searchingActiveBorderColor = { fg = "Character", bold = true },
        },
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
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",

    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    opts = { preset = "modern" },
  },

  { import = "plugins.folke.noice" },
}
