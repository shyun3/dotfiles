return {
  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        function(colors)
          return {
            ["@lsp.type.concept"] = { fg = colors.sapphire },
            ["@lsp.typemod.variable.classScope"] = { link = "@property" },
            ["@lsp.typemod.variable.fileScope"] = {
              link = "@lsp.typemod.variable.classScope",
            },
            ["@lsp.typemod.variable.globalScope"] = {
              fg = colors.lavender, -- @property
              style = { "bold" },
            },
          }
        end,
      },
    },
  },

  {
    LazyDep("mason-lspconfig"),
    optional = true,

    opts = {
      ensure_installed = { "clangd" },
    },
  },
}
