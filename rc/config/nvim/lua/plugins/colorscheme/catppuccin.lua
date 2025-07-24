local hl_overrides = {
  ["@function.builtin"] = { italic = true },

  -- Treesitter seems to think anything with :: behind it is a module
  ["@module.cpp"] = {},

  ["@lsp.typemod.variable.readonly"] = { link = "@constant" },
}

return {
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
        hl_overrides
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
}
