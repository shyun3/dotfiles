local lualine_require = require("lualine_require")

local default_options = { colored = false }

local M = lualine_require.require("lualine.components.filetype"):extend()

function M:init(options)
  options = vim.tbl_deep_extend("keep", options or {}, default_options)
  M.super.init(self, options)
end

return M
