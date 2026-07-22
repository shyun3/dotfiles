-- Same as default progress component, except percentages are shown instead of
-- "Top" and "Bot"
return function()
  local prog = require("lualine.components.progress")()
  if prog == "Top" then
    return "0%%"
  elseif prog == "Bot" then
    return "100%%"
  else
    return vim.trim(prog)
  end
end
