local M = { DIM_HL_GROUP_PREFIX = "my_dim_" }

---@param color integer Color value, such as the `fg` field in the return value
---  of `vim.api.nvim_get_hl()`
---
---@return string Input converted to hex string in "#HHHHHH" format
function M.to_color_hex_str(color)
  return color and string.format("#%06X", color)
end

---@param color string Color hex string in format "#HHHHHH"
---
---@return integer Converted input
function M.from_color_hex_str(color) return tonumber(color:sub(2), 16) end

---@param lang string Treesitter language
---@param hls string[] Treesitter highlight groups, without language
---
---@return { [string]: vim.api.keyset.highlight } dim_hls Table of treesitter
---  language highlight groups to highlight definition maps that link to the
---  corresponding dim highlight group
function M.make_dim_ts_hls(lang, hls)
  local dim_hls = {}
  for _, group in ipairs(hls) do
    dim_hls[group .. "." .. lang] = { link = M.DIM_HL_GROUP_PREFIX .. group }
  end

  return dim_hls
end

return M
