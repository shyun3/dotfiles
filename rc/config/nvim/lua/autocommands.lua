local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", { clear = true })

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = myAutoGroup,
  desc = "Save when leaving buffer",
  nested = true,
  callback = function()
    if vim.fn.bufname() ~= "" and vim.bo.buftype == "" then vim.cmd.update() end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = myAutoGroup,
  desc = "Highlight on yank",
  callback = function() vim.highlight.on_yank() end,
})
