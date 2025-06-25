local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", { clear = true })

-- See https://github.com/ibhagwan/nvim-lua/blob/main/lua/autocmd.lua
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  group = myAutoGroup,
  desc = "Enable cursorline for active window",
  callback = function()
    if not vim.o.cursorline and not vim.o.previewwindow then
      vim.opt_local.cursorline = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
  group = myAutoGroup,
  desc = "Disable cursorline for active window",
  callback = function()
    if vim.o.cursorline and not vim.o.previewwindow then
      vim.opt_local.cursorline = false
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = myAutoGroup,
  desc = "Highlight on yank",
  callback = function() vim.highlight.on_yank() end,
})
