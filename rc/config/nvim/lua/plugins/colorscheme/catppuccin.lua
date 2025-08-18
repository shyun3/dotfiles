local function hl_overrides(colors)
  local color_util = require("catppuccin.utils.colors")
  return {
    --- Syntax
    Macro = { style = { "bold" } },

    --- Treesitter
    ["@property"] = { fg = colors.lavender },

    ["@variable.parameter"] = { link = "@variable" },

    -- Treesitter erroneously seems to think anything with `::` behind it is a
    -- module, so disable italic for C++
    ["@module.cpp"] = {},

    --- LSP
    ["@lsp.type.concept.cpp"] = { fg = color_util.darken(colors.yellow, 0.9) },

    ["@lsp.typemod.variable.classScope"] = { link = "@property" },
    ["@lsp.typemod.variable.fileScope"] = {
      link = "@lsp.typemod.variable.classScope",
    },

    -- Different highlight groups may be applied to `decltype` or `auto`
    -- depending on what clangd deduces, e.g. built-in type or class. This can
    -- be jarring so force highlight to keyword.
    ["@lsp.mod.deduced.cpp"] = { link = "Keyword" },

    --- Plugins
    HopNextKey = {
      -- Remove underline as it makes it difficult to tell apart `g` and `q`
      style = { "bold" },
    },
  }
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  opts = {
    styles = {
      loops = { "italic" },
      keywords = { "italic" },
    },

    custom_highlights = function(colors)
      return vim.tbl_extend(
        "error",
        require("plugins.colorscheme.integrations").dropbar_overrides,
        hl_overrides(colors)
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
