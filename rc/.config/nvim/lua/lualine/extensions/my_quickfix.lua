local M = vim.deepcopy(require("lualine.extensions.quickfix"))

M.sections.lualine_z = { "my_progress", "my_location" }

return M
