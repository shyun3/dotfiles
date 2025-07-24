return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    opts = {
      styles = {
        conditionals = {},
      },

      custom_highlights = function()
        return vim.tbl_extend(
          "error",
          require("plugins.colorscheme.integrations").dropbar_overrides,
          {
            ["@function.builtin"] = { italic = true },
          }
        )
      end,

      integrations = {
        dropbar = {
          enabled = true,
          color_mode = true,
        },
        hop = true,
        mason = true,
        noice = true,
        notify = true,
        snacks = { enabled = true },
        which_key = true,
      },
    },

    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      -- Add headers marks highlights (the `#` character) to Treesitter highlight query
      markdown_header_marks = true,

      on_highlights = function(hl)
        local dropbar =
          require("plugins.colorscheme.integrations").dropbar_custom
        for group, hl_map in pairs(dropbar) do
          hl[group] = hl_map
        end
      end,
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,

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

  { import = "plugins.colorscheme.molokai" },
}
