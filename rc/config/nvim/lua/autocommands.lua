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

-- Show colorcolumn only on insert
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  desc = "Set colorcolumn",

  callback = function(args)
    local bufnr = args.buf
    if vim.b[bufnr].my_disable_colorcolumn then
      vim.wo.colorcolumn = ""
      return
    end

    local tw = vim.bo[bufnr].textwidth
    local cc = tw == 0 and require("util").column_limit or tw + 1
    vim.wo.colorcolumn = tostring(cc)
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  desc = "Clear colorcolumn",
  callback = function() vim.wo.colorcolumn = "" end,
})
