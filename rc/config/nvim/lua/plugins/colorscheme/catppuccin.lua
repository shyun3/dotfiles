local function hl_overrides(colors)
  return {
    --- Syntax
    Macro = { style = { "bold" } },

    --- Treesitter

    -- Treesitter erroneously seems to think anything with `::` behind it is a
    -- module, so disable italic for C++
    ["@module.cpp"] = {},

    ["@variable.parameter"] = { link = "@variable" },

    --- LSP
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.variable.classScope"] = { fg = colors.lavender },
    ["@lsp.typemod.variable.fileScope"] = {
      link = "@lsp.typemod.variable.classScope",
    },
    ["@lsp.typemod.variable.defaultLibrary.lua"] = {
      link = "@variable.builtin",
    },

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
