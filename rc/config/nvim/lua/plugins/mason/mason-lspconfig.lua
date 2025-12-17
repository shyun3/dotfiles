return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { LazyDep("nvim-treesitter-jjconfig"), LazyDep("lspconfig") },
  event = "VeryLazy",

  opts = {
    ensure_installed = {
      "basedpyright",
      "bashls",
      "clangd",
      "jsonls",
      "lua_ls",
      "tombi",
      "ts_query_ls",
      "vimls",
      "yamlls",
    },

    automatic_enable = {
      exclude = {
        "stylua", -- Only for formatting
      },
    },
  },
}
