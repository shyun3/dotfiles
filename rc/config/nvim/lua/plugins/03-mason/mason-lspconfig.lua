return {
  {
    LazyDep("mason-tool-installer"),
    optional = true,

    opts = {
      integrations = {
        ["mason-lspconfig"] = false, -- To allow lazy loading
      },
    },
  },

  {
    LazyDep("mason-lspconfig"),
    event = "VeryLazy",

    opts_extend = { "ensure_installed", "automatic_enable.exclude" },

    opts = {
      ensure_installed = {
        "basedpyright",
        "bashls",
        "jsonls",
        "mesonlsp",
        "taplo",
        "ts_query_ls",
        "vimls",
        "yamlls",
      },
    },

    config = function(_, opts)
      -- LSP configs seem to get merged when LSP servers are enabled. If
      -- plugins are loaded afterward, their LSP configs do not appear to get
      -- applied.
      vim.api.nvim_exec_autocmds("User", { pattern = "LspEnablePre" })

      require("mason-lspconfig").setup(opts)
    end,
  },
}
