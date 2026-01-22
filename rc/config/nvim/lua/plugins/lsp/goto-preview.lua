return {
  { "rmagatti/logger.nvim", lazy = true },

  {
    LazyDep("goto-preview"),
    event = "LspAttach",

    opts = {
      default_mappings = true,
      references = { provider = "fzf_lua" },

      post_open_hook = function(_, win)
        -- Fix highlights in floating windows
        -- Derived from #64
        vim.api.nvim_set_option_value("winhighlight", "Normal:", { win = win })
      end,
    },

    config = function(_, opts)
      require("goto-preview").setup(opts)

      require("which-key").add({
        { "gp", desc = "Preview LSP" },
      })
    end,
  },
}
