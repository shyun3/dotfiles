-- Warn when 1st line of message exceeds 50 characters
vim.fn.matchadd("@text.danger", [[\v%1l%>50v.+$]])

vim.opt_local.winhighlight:append({
  diffFile = "my_dim_diffFile",
  diffIndexLine = "my_dim_diffIndexLine",
  diffOldFile = "my_dim_diffOldFile",
  diffNewFile = "my_dim_diffNewFile",
  diffAdded = "my_dim_diffAdded",
  diffRemoved = "my_dim_diffRemoved",
})
