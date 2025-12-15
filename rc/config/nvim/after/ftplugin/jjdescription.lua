vim.opt_local.colorcolumn = "+1"

-- Warn when 1st line of message exceeds 50 characters
vim.fn.matchadd("@text.danger", [[\v%1l%>50v.+$]])
