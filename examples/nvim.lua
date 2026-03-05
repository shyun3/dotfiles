local group = vim.api.nvim_create_augroup("MyProject", { clear = false })

-- Check if config was already sourced
local autocmds = vim.api.nvim_get_autocmds({ group = group })
if #autocmds > 0 then return end

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,

  -- Place config in project root
  pattern = vim.fn.expand("<script>:p:h") .. "/*.asm",

  desc = "Set ASM syntax",

  callback = function()
    if vim.bo.filetype == "asm" then vim.bo.filetype = "nasm" end
    if vim.bo.filetype == "nasm" then vim.b.asterisk_force_ignorecase = 1 end
  end,
})
