return {
  "polirritmico/monokai-nightasty.nvim",
  lazy = false,
  priority = 1000,

  opts = {
    -- Add headers marks highlights (the `#` character) to Treesitter highlight query
    markdown_header_marks = true,

    on_highlights = function(hl)
      local dropbar = require("plugins.colorscheme.integrations").dropbar_custom
      for group, hl_map in pairs(dropbar) do
        hl[group] = hl_map
      end
    end,

    cache = false, -- Makes adjusting highlights easier

    auto_enable_plugins = false,
  },

  config = function(_, opts) require("monokai-nightasty").load(opts) end,
}
