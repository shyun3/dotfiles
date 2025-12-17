local group = vim.api.nvim_create_augroup("my_nvim", { clear = true })

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = group,
  nested = true,
  desc = "Save when leaving buffer",

  callback = function()
    if
      vim.fn.bufname() ~= ""
      and vim.bo.buftype == ""
      and not vim.bo.readonly
    then
      vim.cmd.update()
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight on yank",
  callback = function() vim.hl.on_yank() end,
})
