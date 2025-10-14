return {
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy",

    opts = {
      on_highlights = function(hl)
        local dropbar =
          require("plugins.colorscheme.integrations").dropbar_custom
        for group, hl_map in pairs(dropbar) do
          hl[group] = hl_map
        end
      end,
    },
  },

  { import = "plugins.colorscheme.catppuccin" },
  { import = "plugins.colorscheme.molokai" },
}
