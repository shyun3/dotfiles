-- Derived from lualine "branch" component

local M = require("lualine.component"):extend()

local modules = require("lualine_require").lazy_require({
  vcs_branch = "lualine.components.vcs.vcs_branch",
  utils = "lualine.utils.utils",
})

function M:init(options)
  M.super.init(self, options)
  if not self.options.icon then
    self.options.icon = "" -- e0a0
  end
  modules.vcs_branch.init()
end

function M:update_status(is_focused)
  local buf = not is_focused and vim.api.nvim_get_current_buf()
  local branch = modules.vcs_branch.get_branch(buf)
  return modules.utils.stl_escape(branch)
end

return M
