---@class MyCatppuccinOptions: CatppuccinOptions
---@field _my_custom_highlights { [string]: table }
---  Highlight group -> Highlight definition map

local function hl_overrides(colors)
  return {
    --- Syntax
    Label = { style = { "bold" } },
    Macro = { style = { "bold", "nocombine" } },
    PreProc = { link = "Keyword" },

    --- Treesitter
    ["@attribute.python"] = { link = "Function" },

    ["@function.builtin"] = {
      fg = colors.blue, -- Same as function color, default was same as literals
      style = { "italic" },
    },

    ["@keyword.import.c"] = { link = "Include" },
    ["@keyword.import.cpp"] = { link = "@keyword.import.c" },

    ["@module"] = {
      -- The default of italic yellow is now used by built-in types
      link = "Special", -- Default built-in module link
    },
    ["@module.builtin"] = {
      fg = colors.pink, -- Default built-in module color
      style = { "italic" },
    },

    ["@punctuation.special"] = { link = "@punctuation.delimiter" },
    ["@string.escape"] = { style = { "bold" } },

    ["@type.builtin"] = {
      fg = colors.yellow, -- Same as type color
      style = { "italic" },
    },

    ["@variable.parameter"] = { link = "@variable" },

    --- LSP
    ["@lsp.type.decorator.python"] = { link = "@attribute.python" },

    ["@lsp.typemod.class.defaultLibrary"] = {
      link = "@lsp.typemod.type.defaultLibrary",
    },
    ["@lsp.typemod.namespace.defaultLibrary"] = { link = "@module.builtin" },
    ["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },

    -- clangd
    ["@lsp.type.concept"] = { fg = colors.sapphire },
    ["@lsp.typemod.variable.classScope"] = { link = "@property" },
    ["@lsp.typemod.variable.fileScope"] = {
      link = "@lsp.typemod.variable.classScope",
    },
    ["@lsp.typemod.variable.globalScope"] = {
      fg = colors.lavender, -- Property color
      style = { "bold" },
    },

    -- lua_ls
    ["@lsp.typemod.variable.global"] = {
      link = "@lsp.typemod.variable.globalScope",
    },
  }
end

return {
  LazyDep("catppuccin"),
  name = "catppuccin",
  priority = 1000,

  opts = {
    styles = {
      comments = {}, -- Clear italic
      loops = { "italic" },
      keywords = { "italic" },
      booleans = { "italic" },
    },

    custom_highlights = function(colors)
      local opts = require("catppuccin").options

      return vim.tbl_extend(
        "error",
        require("plugins.colorscheme.integrations").dropbar_overrides,
        hl_overrides(colors),

        ---@cast opts MyCatppuccinOptions
        opts._my_custom_highlights
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
