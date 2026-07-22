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

  {
    LazyDep("vim-endwise"),
    optional = true,

    opts = {
      _my_filetypes = {
        ["4dgl"] = {
          addition = [[\=submatch(0)=~"#IF" ? "#ENDIF" : ]]
            .. [[submatch(0)=~"#" ? "#END" : ]]
            .. [[submatch(0)=="while" ? "wend" : ]]
            .. [[submatch(0)=="for" ? "next" : "end" . submatch(0)]],
          words = "IF,IFNOT,CONST,DATA,func,switch,if,while,for",
          pattern = [[\v%(]]
            .. [[%(^\s*\zs#%(IF|IFNOT|CONST|DATA)>)|]]
            .. [[<%(func|switch)>|]]
            .. [[<%(if|while|for)>]]
            .. [[\ze\s*\(.*\)[^;]*$)]],
          syngroups = "4dglPreCondit,4dglConstant,4dglPreProc,4dglKeyword,"
            .. "4dglCond,4dglRepeat",
        },
      },
    },
  },

  { "shyun3/vim-4dgl", ft = "4dgl" },
}
