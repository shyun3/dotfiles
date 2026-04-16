local M = {}

local DIM_HL_GROUP_PREFIX = "my_dim_"

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
function M.make_dim_hl(ref_name)
  local ref_hl = vim.api.nvim_get_hl(0, { name = ref_name, link = false })
  assert(ref_hl.fg, "Expected foreground color")

  local hex_fg = to_color_hex_str(ref_hl.fg)
  local dim_fg = require("catppuccin.utils.colors").darken(hex_fg, 0.8)
  ref_hl.fg = from_color_hex_str(dim_fg)

  vim.api.nvim_set_hl(
    0,
    DIM_HL_GROUP_PREFIX .. ref_name,
    ref_hl --[[@as vim.api.keyset.highlight]]
  )
end

---@param lang string Treesitter language
---@param hls string[] Treesitter highlight groups, without language
---
---@return { [string]: vim.api.keyset.highlight } dim_hls Table of treesitter
---  language highlight groups to highlight definition maps that link to the
---  corresponding dim highlight group
function M.make_dim_ts_hls(lang, hls)
  local dim_hls = {}
  for _, group in ipairs(hls) do
    dim_hls[group .. "." .. lang] = { link = DIM_HL_GROUP_PREFIX .. group }
  end

  return dim_hls
end

return M
