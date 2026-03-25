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
      -- Don't autosave new files
      and vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1
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

-- Enable cursorline only on active window
-- Derived from https://github.com/LazyVim/LazyVim/discussions/2031#discussioncomment-7595365
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  group = group,
  desc = "Enable cursorline",

  callback = function()
    if vim.w.my_last_cursorline then
      vim.w.my_last_cursorline = nil
      vim.wo.cursorline = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  group = group,
  desc = "Disable cursorline",

  callback = function()
    if vim.wo.cursorline then
      vim.w.my_last_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- Show cursor only when focused
vim.api.nvim_create_autocmd("FocusLost", {
  group = group,
  desc = "Hide cursor",

  callback = function()
    local gcr = vim.o.guicursor
    local delim = gcr:len() > 0 and "," or ""
    vim.o.guicursor = gcr .. delim .. "a:MyInvisibleCursor"
  end,
})
vim.api.nvim_create_autocmd("FocusGained", {
  group = group,
  desc = "Show cursor",

  callback = function()
    vim.o.guicursor = vim.o.guicursor:gsub(",?a:MyInvisibleCursor", "")
  end,
})
