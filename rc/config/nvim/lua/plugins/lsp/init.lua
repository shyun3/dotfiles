return {
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",

    opts = {
      autocmd = {
        enabled = true,
        updatetime = -1,
        events = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
      },
    },
  },

  { import = "plugins.lsp.lspconfig" },
  { import = "plugins.lsp.fidget" },
  { import = "plugins.lsp.goto-preview" },
  { import = "plugins.lsp.servers" },
}
