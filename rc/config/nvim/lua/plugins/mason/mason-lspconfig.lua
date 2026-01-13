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

    opts_extend = { "automatic_enable.exclude" },

    opts = {
      ensure_installed = {
        "basedpyright",
        "bashls",
        "clangd",
        "jsonls",
        "lua_ls",
        "mesonlsp",
        "taplo",
        "ts_query_ls",
        "vimls",
        "yamlls",
      },
    },
  },
}
