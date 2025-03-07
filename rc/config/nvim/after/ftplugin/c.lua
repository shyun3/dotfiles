-- DoxygenToolkit.vim plugin
if vim.g.loaded_DoxygenToolkit == 1 then
  vim.keymap.set("n", "<Leader>d", "<Cmd>Dox<CR>", { buffer = true })
end
