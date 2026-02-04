return {
  {
    LazyDep("noice"),
    optional = true,

    opts = {
      lsp = {
        progress = { enabled = false },
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",

    opts = {},
  },
}
