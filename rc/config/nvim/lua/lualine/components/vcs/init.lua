local M = require("lualine.component"):extend()

M.init = require("lualine.components.branch").init
M.update_status = require("lualine.components.branch").update_status

return M
