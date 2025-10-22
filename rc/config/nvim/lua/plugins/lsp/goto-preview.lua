return {
  { "rmagatti/logger.nvim", lazy = true },

  {
    require("lazy-deps").which_key,
    optional = true,

    opts = {
      spec = {
        { "gp", desc = "Preview LSP" },
      },
    },
  },

  {
    "rmagatti/goto-preview",
    event = "LspAttach",

    opts = {
      default_mappings = true,
      references = { provider = "fzf_lua" },
      vim_ui_input = false, -- Handled by noice

      post_open_hook = function(_, win)
        -- Fix highlights in floating windows
        -- Derived from #64
        vim.api.nvim_set_option_value("winhighlight", "Normal:", { win = win })
      end,
    },
  },
}
