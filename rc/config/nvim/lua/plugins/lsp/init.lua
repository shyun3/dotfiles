return {
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",

    opts = {
      autocmd = {
        enabled = true,
        updatetime = -1,
        events = {
          -- Defaults
          "CursorHold",
          "CursorHoldI",

          "CursorMoved",
          "CursorMovedI",
          "FocusGained",
        },
      },
    },

    config = function(_, opts)
      require("nvim-lightbulb").setup(opts)

      local group = vim.api.nvim_create_augroup("my_lightbulb", {})
      vim.api.nvim_create_autocmd("FocusLost", {
        group = group,
        desc = "Clear lightbulb",

        callback = function(args)
          require("nvim-lightbulb").clear_lightbulb(args.buf)
        end,
      })
    end,
  },

  { import = "plugins.lsp.lspconfig" },
  { import = "plugins.lsp.fidget" },
  { import = "plugins.lsp.goto-preview" },
  { import = "plugins.lsp.servers" },
}
