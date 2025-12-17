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
    dependencies = { LazyDep("nvim-treesitter-jjconfig"), LazyDep("lspconfig") },
    event = "VeryLazy",

    opts_extend = { "automatic_enable.exclude" },

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
    },
  },
}
