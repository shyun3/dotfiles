-- Disable the (slow) builtin query linter
-- See `ft-query-plugin`
vim.g.query_lint_on = {}

local tabstop = 2 -- Taken from nvim-treesitter formatting standard
vim.opt_local.tabstop = tabstop
vim.opt_local.softtabstop = tabstop
vim.opt_local.shiftwidth = tabstop
