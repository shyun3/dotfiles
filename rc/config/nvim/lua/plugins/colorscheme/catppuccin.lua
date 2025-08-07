local hl_overrides = {
  Constant = { bold = true },
  Repeat = { italic = true },
  Statement = { italic = true },

  ["@function.builtin"] = { italic = true },

  -- Treesitter erroneously seems to think anything with `::` behind it is a
  -- module, so disable italics for C++
  ["@module.cpp"] = {},

  ["@lsp.typemod.variable.readonly"] = { link = "@constant" },
}

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  opts = {
    styles = {
      keywords = { "italic" },
    },

    custom_highlights = function()
      return vim.tbl_extend(
        "error",
        require("plugins.colorscheme.integrations").dropbar_overrides,
        hl_overrides
      )
    end,

    auto_integrations = true,

    integrations = {
      dropbar = { color_mode = true },
      indent_blankline = { scope_color = "lavender" },
    },
  },

  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
