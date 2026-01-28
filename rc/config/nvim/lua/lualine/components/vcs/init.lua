-- Derived from lualine "branch" component

local M = require("lualine.component"):extend()

local modules = require("lualine_require").lazy_require({
  vcs_branch = "lualine.components.vcs.vcs_branch",
  utils = "lualine.utils.utils",
})

---@type string?
local user_icon_option

function M:init(options)
  M.super.init(self, options)
  user_icon_option = self.options.icon

  modules.vcs_branch.init()
end

function M:update_status(is_focused)
  local buf = not is_focused and vim.api.nvim_get_current_buf()

  local branch = modules.vcs_branch.get_branch(buf)
  if not user_icon_option then self.options.icon = branch.icon end

  return modules.utils.stl_escape(branch[1])
end

return M
