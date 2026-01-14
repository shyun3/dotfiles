return {
  {
    LazyDep("blink.cmp"),
    optional = true,

    opts = {
      sources = {
        providers = {
          ctags = {
            opts = {
              tag_kinds_map = {
                ["4DGL"] = {
                  c = vim.lsp.protocol.CompletionItemKind.Constant,
                  d = vim.lsp.protocol.CompletionItemKind.Constant,
                  f = vim.lsp.protocol.CompletionItemKind.Function,
                  u = vim.lsp.protocol.CompletionItemKind.Constant,
                  v = vim.lsp.protocol.CompletionItemKind.Variable,
                },
              },
            },
          },
        },
      },
    },
  },

  { "shyun3/vim-4dgl", ft = "4dgl" },
}
