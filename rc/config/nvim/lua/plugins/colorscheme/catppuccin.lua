---@class MyCatppuccinOptions: CatppuccinOptions
---@field _my_custom_highlights (CtpHighlightOverrideFn | { [string]: CtpHighlight })[]

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
  }
end

return {
  LazyDep("catppuccin"),
  name = "catppuccin",
  priority = 1000,

  opts_extend = { "_my_custom_highlights" },

  opts = {
    styles = {
      comments = {}, -- Clear italic
      loops = { "italic" },
      keywords = { "italic" },
      booleans = { "italic" },
    },

    custom_highlights = function(colors)
      local opts = require("catppuccin").options

      local hls = hl_overrides(colors)

      ---@cast opts MyCatppuccinOptions
      for _, hl_override in ipairs(opts._my_custom_highlights or {}) do
        local hl_def = type(hl_override) == "function" and hl_override(colors)
          or hl_override
        hls = vim.tbl_extend("error", hls, hl_def)
      end

      return hls
    end,

    _my_custom_highlights = {
      -- User created
      function(colors)
        return {
          MyGlobalVariable = {
            fg = colors.lavender, -- @property
            style = { "bold" },
          },
        }
      end,
    },

    auto_integrations = true,
  },

  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
