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

    config = function(_, opts)
      require("which-key").setup(opts)

      for _, mode in pairs({ "i", "s", "x", "c" }) do
        vim.keymap.set(
          mode,
          "<C-q>",
          function() require("which-key").show({ mode = mode }) end,
          { desc = "which-key: Show mappings" }
        )
      end
    end,

    keys = {
      { "<Leader>?", "<Cmd>WhichKey<CR>" },
      { "<C-q>", mode = { "i", "v", "c" } },
    },
  },

  { import = "plugins.folke.noice" },
}
