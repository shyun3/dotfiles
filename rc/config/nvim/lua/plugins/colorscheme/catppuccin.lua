---@class MyCatppuccinOptions: CatppuccinOptions
---@field _my_custom_highlights { [string]: CtpHighlight | CtpHighlightOverrideFn }

local DIM_HLS = {
  "@constant.builtin",
  "@function",
  "@function.macro",
  "@keyword",
  "@keyword.coroutine",
  "@keyword.function",
  "@keyword.import",
  "@keyword.modifier",
  "@keyword.return",
  "@label",
  "@markup.italic",
  "@module",
  "@number",
  "@operator",
  "@string",
  "@tag",
  "@type",
  "@type.builtin",
  "@variable",
  "@variable.builtin",
  "@variable.member",
  "@variable.parameter",

  -- Built-in
  "Added",
  "Changed",
  "Removed",
}

---@param color integer Color value, such as the `fg` field in the return value
---  of `vim.api.nvim_get_hl()`
---
---@return string Input converted to hex string in "#HHHHHH" format
local function to_color_hex_str(color)
  return color and string.format("#%06X", color)
end

---@param color string Color hex string in format "#HHHHHH"
---
---@return integer Converted input
local function from_color_hex_str(color) return tonumber(color:sub(2), 16) end

--- Creates a dim version of the input highlight group
---
--- Resulting highlight group name will be "my_dim_" followed by the input name
---
---@param ref_name string Highlight group name
local function make_dim_hl(ref_name)
  local ref_hl = vim.api.nvim_get_hl(0, { name = ref_name, link = false })
  assert(ref_hl.fg, "Expected foreground color")

  local hex_fg = to_color_hex_str(ref_hl.fg)
  local dim_fg = require("catppuccin.utils.colors").darken(hex_fg, 0.8)
  ref_hl.fg = from_color_hex_str(dim_fg)

  vim.api.nvim_set_hl(
    0,
    "my_dim_" .. ref_name,
    ref_hl --[[@as vim.api.keyset.highlight]]
  )
end

return {
  LazyDep("catppuccin"),
  name = "catppuccin",
  priority = 1001,

  opts = {
    styles = {
      comments = {}, -- Clear italic
      loops = { "italic" },
      keywords = { "italic" },
      booleans = { "italic" },
    },

    custom_highlights = function(colors)
      local opts = require("catppuccin").options

      local hls = {}

      ---@cast opts MyCatppuccinOptions
      for _, hl_override in pairs(opts._my_custom_highlights or {}) do
        local hl_def = type(hl_override) == "function" and hl_override(colors)
          or hl_override
        hls = vim.tbl_extend("error", hls, hl_def)
      end

      return hls
    end,

    _my_custom_highlights = {
      syntax = function(colors)
        return {
          Label = { style = { "bold" } },
          Macro = { fg = colors.red, style = { "bold", "nocombine" } },
          PreProc = { link = "Keyword" },
        }
      end,

      jjdescription = {
        jjAdded = { link = "my_dim_Added" },
        jjRemoved = { link = "my_dim_Removed" },
        jjChanged = { link = "my_dim_Changed" },
      },

      treesitter = function(colors)
        return {
          ["@attribute.python"] = { link = "Function" },

          ["@function.builtin"] = {
            fg = colors.blue, -- @function
            style = { "italic" },
          },
          ["@function.macro"] = { link = "Macro" },

          ["@keyword.import.c"] = { link = "Include" },
          ["@keyword.import.cpp"] = { link = "@keyword.import.c" },

          ["@module"] = {
            link = "Special", -- Neovim default @module.builtin
          },
          ["@module.builtin"] = {
            fg = colors.pink, -- Custom @module
            style = { "italic" },
          },

          ["@punctuation.special"] = { link = "@punctuation.delimiter" },
          ["@string.escape"] = { style = { "bold" } },

          ["@type.builtin"] = {
            fg = colors.yellow, -- @type
            style = { "italic" },
          },

          ["@variable.builtin"] = {
            fg = colors.text, -- @variable
            style = { "italic" },
          },
          ["@variable.parameter"] = { link = "@variable" },
        }
      end,

      lsp = {
        ["@lsp.type.decorator.python"] = { link = "@attribute.python" },

        ["@lsp.typemod.class.defaultLibrary"] = {
          link = "@lsp.typemod.type.defaultLibrary",
        },
        ["@lsp.typemod.namespace.defaultLibrary"] = { link = "@module.builtin" },
        ["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },
        ["@lsp.typemod.variable.defaultLibrary"] = {
          style = { "italic" }, -- Not linking to avoid overriding colors
        },
      },

      user = function(colors)
        return {
          MyGlobalVariable = {
            fg = colors.lavender, -- @property
            style = { "bold" },
          },
          MyInvisibleCursor = {
            blend = 100, -- See `:h tui-cursor-shape`

            -- Need to specify something here or highlight won't be invisible
            fg = colors.base,
          },
        }
      end,
    },

    auto_integrations = true,
  },

  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-nvim")

    -- Should be done after colorscheme is updated to make use of the final
    -- colors
    for _, name in ipairs(DIM_HLS) do
      make_dim_hl(name)
    end
  end,
}
