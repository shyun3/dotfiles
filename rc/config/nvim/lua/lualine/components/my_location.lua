-- Derived from location component
return function()
  local line = vim.fn.line(".")
  local max_line = vim.fn.line("$")

  local col = vim.fn.charcol(".")
  local virt_col = vim.fn.virtcol(".")
  local col_str = col .. (col == virt_col and "" or "-" .. virt_col)

  -- Symbols taken from airline
  return string.format(":%d/%d≡ ℅:%s", line, max_line, col_str)
end
