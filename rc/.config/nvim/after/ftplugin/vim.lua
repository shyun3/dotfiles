vim.opt_local.textwidth = 0

local tabstop = 2
vim.opt_local.tabstop = tabstop
vim.opt_local.softtabstop = tabstop
vim.opt_local.shiftwidth = tabstop

if vim.fn.exists("g:vim_indent_cont") == 0 then
  vim.g.vim_indent_cont = tabstop
end
