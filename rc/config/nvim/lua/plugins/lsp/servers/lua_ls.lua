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
      ensure_installed = { "lua_ls" },

      _my_lsp_configs = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
            },
          },
        },
      },
    },
  },
}
