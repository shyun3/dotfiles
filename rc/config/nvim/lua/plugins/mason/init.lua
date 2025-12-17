return {
  {
    "mason-org/mason.nvim",
    lazy = false, -- Lazy loading is not recommended

    opts = {},

    keys = {
      { "<Leader>mm", "<Cmd>Mason<CR>" },
    },
  },

  { import = "plugins.mason.mason-tool-installer" },
  { import = "plugins.mason.mason-lspconfig" },
}
