local M = require("lualine.component"):extend()

function M:init(options) M.super.init(self, options) end

-- Show @recording messages
-- Derived from https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components
function M:update_status()
  return require("noice").api.status.mode.has()
      and require("noice").api.status.mode.get()
    or ""
end

return M
