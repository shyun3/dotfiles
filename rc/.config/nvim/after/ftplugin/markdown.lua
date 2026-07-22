local cols = require("util").column_limit
if cols > 0 then vim.bo.textwidth = cols - 1 end
