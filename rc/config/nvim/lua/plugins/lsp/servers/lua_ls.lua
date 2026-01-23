return {
  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        {
          ["@lsp.typemod.variable.global"] = { link = "MyGlobalVariable" },
        },
      },
    },
  },

  {
    LazyDep("mason-lspconfig"),
    optional = true,

    opts = {
      ensure_installed = {
        "lua_ls@3.16.4", -- See lazydev.nvim#136
      },
    },
  },
}
