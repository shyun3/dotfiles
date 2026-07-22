return {
  {
    "mason-org/mason.nvim",
    lazy = false, -- Lazy loading is not recommended

    opts = {},

    keys = {
      { "<Leader>mm", "<Cmd>Mason<CR>" },
    },
  },

  -- opts_extend
  { import = "plugins.03-mason.mason-lspconfig" },

  { import = "plugins.03-mason.mason-tool-installer" },
}
