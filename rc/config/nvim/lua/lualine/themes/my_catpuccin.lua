-- Derived from molokai in vim-airline-themes

local colors = require("lualine.themes.catppuccin")

--- Create a lualine c section colorscheme whose background lights up with
--- the mode color if buffer is modified
---
---@param mode string Mode name used by lualine theme
---
---@return fun(): {["fg"]: string | number, ["bg"]: string | number} colorscheme
local function make_c_section(mode)
  return function()
    return vim.bo.modified
        and { fg = colors[mode].a.fg, bg = colors[mode].a.bg }
      or colors.normal.c
  end
end

local modes = { "normal", "insert", "replace", "visual", "command", "terminal" }
local override = {}
for _, mode in ipairs(modes) do
  override[mode] = { c = make_c_section(mode) }
end

return vim.tbl_deep_extend("force", colors, override)
