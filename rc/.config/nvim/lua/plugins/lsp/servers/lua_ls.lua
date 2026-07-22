return {
  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        lua_ls = {
          ["@lsp.typemod.variable.global"] = { link = "MyGlobalVariable" },

          -- For some reason, lua_ls still highlights annotation keywords
          -- even if `semantic.annotation` is disabled
          ["@lsp.type.keyword.lua"] = { link = "NONE" },
        },
      },
    },
  },

  {
    LazyDep("conform"),
    optional = true,

    opts = {
      formatters_by_ft = {
        lua = { filter = function(client) return client.name ~= "lua_ls" end },
      },
    },
  },

  {
    LazyDep("mason-lspconfig"),
    optional = true,

    opts = {
      ensure_installed = { "lua_ls" },
    },
  },
}
